package Dist::Zilla::PluginBundle::ROKR;
# ABSTRACT: ROKR PluginBundle for Dist::Zilla

=head1 SYNOPSIS

In your L<Dist::Zilla> C<dist.ini>:

    [@ROKR::Basic]

In your L<Dist::Dzpl> C<dzpl>:

    plugin '@ROKR::Basic'

=head1 DESCRIPTION

Does not actually bundle any Dist::Zilla::Plugin:: (for now)

Dist::Zilla::PluginBundle::ROKR is a bundling dist for:

C<@ROKR::Basic> - L<Dist::Zilla::PluginBundle::ROKR::Basic>

C<CopyReadmeFromBuild> - L<Dist::Zilla::Plugin::CopyReadmeFromBuild>

C<SurgicalPkgVersion> - L<Dist::Zilla::Plugin::SurgicalPkgVersion>

C<SurgicalPodWeaver> - L<Dist::Zilla::Plugin::SurgicalPodWeaver>

=cut

use strict;
use warnings;

sub bundle_config {

    die <<_END_
The \@ROKR bundle does not actually bundle anything (for now)

You probably want to use \@ROKR::Basic

_END_

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
