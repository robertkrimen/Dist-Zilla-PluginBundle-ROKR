package Dist::Zilla::Plugin::SurgicalPodWeaver;

use Moose;
extends qw/ Dist::Zilla::Plugin::PodWeaver /;

require Dist::Zilla::PluginBundle::ROKR;

around munge_pod => sub {
    my $inner = shift;
    my ( $self, $file ) = @_;

    my $content = $file->content;

    my $yes = 0;
    if ( my $hint = Dist::Zilla::PluginBundle::ROKR->parse_hint( $content ) ) {
        if ( exists $hint->{PodWeaver} ) {
            return unless $hint->{PodWeaver};
            $yes = 1;
        }
    }

    if ( $yes || $content =~ m/^\s*#+\s*(?:ABSTRACT):\s*(.+)$/m ) { }
    else { return }

    return $inner->( @_ )
};

__PACKAGE__->meta->make_immutable;
no Moose;
1;

