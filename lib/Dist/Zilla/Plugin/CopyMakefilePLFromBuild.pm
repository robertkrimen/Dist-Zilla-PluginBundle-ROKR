package Dist::Zilla::Plugin::CopyMakefilePLFromBuild;
# ABSTRACT: Copy Makefile.PL after building (for SCM inclusion, etc.)

=head1 SYNOPSIS

In your L<Dist::Zilla> C<dist.ini>:

    [CopyMakefilePLFromBuild]

=head1 DESCRIPTION

CopyMakefilePLFromBuild will automatically copy the Makefile.PL from the build directory into the distribution directory. This is so you can commit the Makefile.PL to version control. When building directly from GitHub (via cpanm, for example) you would need a Makefile.PL

Dist::Zilla will not like it if you already have a Makefile.PL, so you'll have to disable that plugin, an example of which is:

    [@Filter]
    bundle = @Basic
    remove = MakefilePL

=cut

use Moose;
with qw/ Dist::Zilla::Role::AfterBuild /;

use File::Copy qw/ copy /;

sub after_build {
    my $self = shift;
    my $data = shift;

    my $build_root = $data->{build_root};
    my $src;
    for(qw/ Makefile.PL /) {
        my $file = $build_root->file( $_ );
        $src = $file and last if -e $file;
    }

    die "Missing Makefile.PL file in ", $build_root unless $src;

    my $dest = $self->zilla->root->file( $src->basename );

    copy "$src", "$dest" or die "Unable to copy $src to $dest: $!";
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
