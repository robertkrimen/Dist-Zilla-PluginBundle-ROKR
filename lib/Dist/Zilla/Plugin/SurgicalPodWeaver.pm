package Dist::Zilla::Plugin::SurgicalPodWeaver;
# ABSTRACT: Surgically apply PodWeaver

=head1 SYNOPSIS

In your L<Dist::Zilla> C<dist.ini>:

    [SurgicalPodWeaver]

To hint that you want to apply PodWeaver:

    package Xyzzy;
    # Dist::Zilla: +PodWeaver

    ...

=head1 DESCRIPTION

Dist::Zilla::Plugin::SurgicalPodWeaver will only PodWeaver a .pm if:

    1. There exists an # ABSTRACT: ...
    2. The +PodWeaver hint is present

You can forcefully disable PodWeaver on a .pm by using the C<-PodWeaver> hint

=cut

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

