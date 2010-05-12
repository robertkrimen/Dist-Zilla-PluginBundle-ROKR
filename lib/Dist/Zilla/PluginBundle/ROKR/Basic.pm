package Dist::Zilla::PluginBundle::ROKR::Basic;
# ABSTRACT: ROKR::Basic PluginBundle for Dist::Zilla

=head1 SYNOPSIS

In your L<Dist::Zilla> C<dist.ini>:

    [@ROKR::Basic]

=head1 DESCRIPTION

This is an enhancement on the @Basic bundle (L<Dist::Zilla::PluginBundle::Basic>) with the following:

    @Basic (without Readme)
    CopyReadmeFromBuild
    DynamicManifest
    SurgicalPkgVersion
    SurgicalPodWeaver

It is equivalent to:

    [@Filter]
    bundle = @Basic
    remove = Readme

    [CopyReadmeFromBuild]
    [DynamicManifest]
    [SurgicalPkgVersion]
    [SurgicalPodWeaver]

=head1 SEE ALSO

L<Dist::Zilla::PluginBundle::Basic>

L<Dist::Zilla::Plugin::CopyReadmeFromBuild>

L<Dist::Zilla::Plugin::DynamicManifest>

L<Dist::Zilla::Plugin::SurgicalPkgVersion>

L<Dist::Zilla::Plugin::SurgicalPodWeaver>

=cut

use Moose;

with qw/ Dist::Zilla::Role::PluginBundle /;

use Dist::Zilla::PluginBundle::Basic;
use Dist::Zilla::PluginBundle::Filter;

sub bundle_config {
    my ($self, $section) = @_;

    my @bundle = Dist::Zilla::PluginBundle::Filter->bundle_config({
        name    => $section->{name} . '/@Basic',
        payload => {
            bundle => '@Basic',
            remove => [
                # We'll generate README from ReadmeFromPod 
                'Readme',
            ],
        },
    });

    push @bundle, map {
        my ( $name, $payload ) = @$_;
        [ "$section->{name}/$name" => "Dist::Zilla::Plugin::$name" => $payload ];
    } (
        [ 'CopyReadmeFromBuild' ],
        [ 'DynamicManifest' ],
        [ 'ReadmeFromPod' ],
        [ 'SurgicalPkgVersion' ],
        [ 'SurgicalPodWeaver' ],
    );

    return @bundle;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
