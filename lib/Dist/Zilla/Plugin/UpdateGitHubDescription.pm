package Dist::Zilla::Plugin::UpdateGitHubDescription;

use Moose;
with qw/ Dist::Zilla::Role::AfterBuild /;

use Config::Identity::GitHub;
my $agent = LWP::UserAgent->new;

sub update {
    my $self = shift;
    my %given = @_;
    my ( $login, $token, $repository, $description );

    ( $repository, $description ) = @given{qw/ repository description /};
    defined $_ && length $_ or die "Missing repository" for $repository;
    defined $_ && length $_ or die "Missing description" for $description;

    ( $login, $token ) = @given{qw/ login token /};
    unless( defined $token && length $token ) {
        my %identity = Config::Identity::GitHub->load;
        ( $login, $token ) = @identity{qw/ login token /};
    }

    my $uri = "https://github.com/api/v2/json/repos/show/$login/$repository";
    my $response = $agent->post( $uri,
        [ login => $login, token => $token, 'values[description]' => $description ] );

    unless ( $response->is_success ) {
        die $response->status_line, "\n",
            $response->decoded_content;
    }

    return $response;
}

sub after_build {
    my ( $self ) = @_;
    
    my $repository = $self->zilla->name;
    my $description = $self->zilla->abstract;

    eval {
        my $response = $self->update( repository => $repository,
            description => $description );
        $self->log( "Updated github description:", $response->decoded_content );
    };
    $self->log( "Unable to update github description: $@" ) if $@;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
