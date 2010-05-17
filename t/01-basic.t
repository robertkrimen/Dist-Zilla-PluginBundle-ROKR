#!/usr/bin/env perl

use strict;
use warnings;

use Test::Most;
plan 'no_plan';

use Dist::Zilla::PluginBundle::ROKR;
use Dist::Zilla::PluginBundle::ROKR::Basic;
use Dist::Zilla::Plugin::CopyReadmeFromBuild;
use Dist::Zilla::Plugin::DynamicManifest;
use Dist::Zilla::Plugin::SurgicalPkgVersion;
use Dist::Zilla::Plugin::SurgicalPodWeaver;
use Dist::Zilla::Plugin::UpdateGitHub;

ok( 1 );
