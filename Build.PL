#!usr/bin/perl
use strict;
use warnings;

use Config;
use Module::Build;

my $requires = {
    'Time::JulianDay'                       => 0,
};

my $build =  Module::Build->new(
    module_name        => 'LINZ::Geodetic',
    license            => 'bsd',
    dist_author        => 'LINZ',
    dist_version_from  => 'lib/LINZ/Geodetic.pm',
    dist_abstract      => 'Modules for geodetic coordinate system conversion',
    requires           => $requires,
    create_makefile_pl => 'small',
);

$build->create_build_script;
