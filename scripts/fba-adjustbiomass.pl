#!/usr/bin/env perl
########################################################################
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
########################################################################
use strict;
use warnings;
use Bio::KBase::workspace::ScriptHelpers qw(printObjectInfo get_ws_client workspace workspaceURL parseObjectMeta parseWorkspaceMeta printObjectMeta);
use Bio::KBase::fbaModelServices::ScriptHelpers qw(get_fba_client runFBACommand universalFBAScriptCode );
#Defining globals describing behavior
my $primaryArgs = ["Model ID","Compound ID","Coefficient"];
my $servercommand = "adjust_biomass_reaction";
my $script = "fba-adjustbiomass";
my $translation = {
	"Model ID" => "model",
	workspace => "workspace",
	biomass => "biomass",
	auth => "auth",
};
#Defining usage and options
my $specs = [
    [ 'biomass|b:s', 'ID of biomass to be modified', { "default" => "bio1" }  ],
    [ 'product|p', 'Product compound'],
    [ 'compartment|c:s', 'Compartment of target compound', { "default" => "c" } ],
    [ 'compindex|i:s', 'Index of compartment for target compound', { "default" => 0 } ],
    [ 'workspace|w:s', 'Workspace to save FBA results', { "default" => workspace() } ],
];
my ($opt,$params) = universalFBAScriptCode($specs,$script,$primaryArgs,$translation);
if (!defined($opt->{product})) {
	$opt->{Coefficient} = -1*$opt->{Coefficient};
}
my $trans = {
	"Compound ID" => "compounds",
	Coefficient => "coefficients",
	compartment => "compartments",
	compindex => "compartmentIndecies"
};
foreach my $param (keys(%{$trans})) {
	$params->{$trans->{$param}} = [$opt->{$param}];
}
#Calling the server
my $output = runFBACommand($params,$servercommand,$opt);
#Checking output and report results
if (!defined($output)) {
	print "Adjustment of biomass failed!\n";
} else {
	print "Adjustment of biomass successful:\n";
	printObjectInfo($output);
}