#! @perl@ -w

use strict;

use lib "@targetDir@/lib/perl";
$ENV{GUS_HOME} = '@targetDir@';
$ENV{R_PROGRAM} = '@rProgram@';
$ENV{R_LIBS} = '@cgilibTargetDir@/R';


use constant DEBUG => 1;

use PlasmoDBWebsite::View::CgiApp::DataPlotter;


DEBUG && print STDERR "# $0 --------------------------------------------------------\n";

PlasmoDBWebsite::View::CgiApp::DataPlotter->new()->go();

