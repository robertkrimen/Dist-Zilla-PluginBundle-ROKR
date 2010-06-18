package Dist::Zilla::PluginBundle::ROKR;
# ABSTRACT: A nifty little plugin bundle for Dist::Zilla

=head1 DESCRIPTION

C<@ROKR::Basic> - L<Dist::Zilla::PluginBundle::ROKR::Basic>

This is an enhancement on the @Basic bundle (L<Dist::Zilla::PluginBundle::Basic>), specifically:

    @Basic (without Readme)
    CopyReadmeFromBuild
    DynamicManifest
    SurgicalPkgVersion
    SurgicalPodWeaver

C<CopyReadmeFromBuild> - L<Dist::Zilla::Plugin::CopyReadmeFromBuild>

C<DynamicManifest> - L<Dist::Zilla::Plugin::DynamicManifest>

C<SurgicalPkgVersion> - L<Dist::Zilla::Plugin::SurgicalPkgVersion>

C<SurgicalPodWeaver> - L<Dist::Zilla::Plugin::SurgicalPodWeaver>

C<UpdateGitHub> - L<Dist::Zilla::Plugin::UpdateGitHub>

=cut

use strict;
use warnings;

use Moose;
use Moose::Autobox;
with qw/ Dist::Zilla::Role::PluginBundle::Easy /;


sub configure {
    my $self = shift;

    $self->add_bundle('@ROKR::Basic');
    $self->add_plugins('UpdateGitHub');
    $self->add_plugins('Git::Tag');
}

sub parse_hint {
    my $self = shift;
    my $content = shift;

    my %hint;
    if ( $content =~ m/^\s*#+\s*(?:Dist::Zilla):\s*(.+)$/m ) { 
        %hint = map {
            m/^([\+\-])(.*)$/ ?
                ( $1 eq '+' ? ( $2 => 1 ) : ( $2 => 0 ) ) :
                ()
        } split m/\s+/, $1;
    }

    return \%hint;
}

1;
