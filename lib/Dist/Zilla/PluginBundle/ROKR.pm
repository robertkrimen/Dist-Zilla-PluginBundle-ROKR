package Dist::Zilla::PluginBundle::ROKR;
# ABSTRACT: ROKR PluginBundle for Dist::Zilla

use strict;
use warnings;

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
