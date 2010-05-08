package Dist::Zilla::Plugin::SurgicalPkgVersion;
# ABSTRACT: Surgically apply PkgVersion

=head1 SYNOPSIS

In your L<Dist::Zilla> C<dist.ini>:

    [SurgicalPkgVersion]

In your L<Dist::Dzpl> C<dzpl>:

    plugin 'SurgicalPkgVersion'

To hint that you want to apply PkgVersion:

    package Xyzzy;
    # Dist::Zilla: +PkgVersion

    ...

=head1 DESCRIPTION

Dist::Zilla::Plugin::SurgicalPkgVersion will only PkgVersion a .pm if:

    1. There exists an # ABSTRACT: ...
    2. The +PkgVersion hint is present

You can forcefully disable PkgVersion on a .pm by using the C<-PkgVersion> hint

=cut

use Moose;
extends qw/ Dist::Zilla::Plugin::PkgVersion /;

require Dist::Zilla::PluginBundle::ROKR;

around munge_perl => sub {
    my $inner = shift;
    my ( $self, $file ) = @_;

    my $content = $file->content;

    my $yes = 0;
    if ( my $hint = Dist::Zilla::PluginBundle::ROKR->parse_hint( $content ) ) {
        if ( exists $hint->{PkgVersion} ) {
            return unless $hint->{PkgVersion};
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
