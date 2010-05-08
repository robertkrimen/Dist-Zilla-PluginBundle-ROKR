package Dist::Zilla::Plugin::CopyReadmeFromBuild;
# ABSTRACT: Doy

use Moose;
with qw/ Dist::Zilla::Role::AfterBuild /;

use File::Copy qw/ copy /;

sub after_build {
    my $self = shift;
    my $data = shift;

    my $build_root = $data->{build_root};
    my $src;
    for(qw/ README README.md README.txt README.markdown /) {
        my $file = $build_root->file( $_ );
        $src = $file and last if -e $file;
    }

    die "Missing README file in ", $build_root unless $src;

    my $dest = $self->zilla->root->file( $src->basename );

    copy "$src", "$dest" or die "Unable to copy $src to $dest: $!";
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
