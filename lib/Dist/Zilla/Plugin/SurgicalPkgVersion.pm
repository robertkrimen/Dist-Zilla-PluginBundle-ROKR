package Dist::Zilla::Plugin::SurgicalPkgVersion;

use Moose;
extends qw/ Dist::Zilla::Plugin::PkgVersion /;

around munge_perl => sub {
    my $inner = shift;
    my ( $self, $file ) = @_;

    my $content = $file->content;

    if ( $content =~ m/^\s*#+\s*(?:ABSTRACT|VERSION):\s*(.+)$/m ) { }
    else { return }

    return $inner->( @_ )
};

__PACKAGE__->meta->make_immutable;
no Moose;
1;
