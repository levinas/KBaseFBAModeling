#!/usr/bin/env perl
########################################################################
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
########################################################################
use strict;
use warnings;
use Bio::KBase::workspace::ScriptHelpers qw( printObjectInfo get_ws_client workspace workspaceURL parseObjectMeta parseWorkspaceMeta printObjectMeta);
use Bio::KBase::fbaModelServices::ScriptHelpers qw(fbaws get_fba_client runFBACommand universalFBAScriptCode );
#Defining globals describing behavior
my $primaryArgs = ["Phenotype sensitivity analysis ID"];
my $servercommand = "queue_combine_wildtype_phenotype_reconciliation";
my $script = "fba-combinerecon";
my $translation = {
	"Phenotype sensitivity analysis ID" => "PhenoSensitivityAnalysis",
	modelout => "out_model",
	workspace => "workspace",
	auth => "auth",
	overwrite => "overwrite",
	nosubmit => "donot_submit_job",
	numsol => "numsolutions",
	intsol => "intsolution",
	timepersol => "timePerSolution",
	timelimit => "totalTimeLimit",
};
#Defining usage and options
my $specs = [
    [ 'modelout:s', 'ID for output model in workspace' ],
    [ 'intsol', 'Automatically integrate solution', { "default" => 0 } ],
    [ 'timepersol:s', 'Maximum time spent per solution' ],
    [ 'timelimit:s', 'Maximum toal time' ],
    [ 'numsol:i', 'Number of solutions desired', {"default" => 1} ],
    [ 'workspace|w:s', 'Workspace to save FBA results', { "default" => fbaws() } ],
];
my ($opt,$params) = universalFBAScriptCode($specs,$script,$primaryArgs,$translation);
#Calling the server
my $output = runFBACommand($params,$servercommand,$opt);
#Checking output and report results
if (!defined($output)) {
	print "Reconciliation combination queue failed!\n";
} else {
	print "Reconciliation combination queued:\n";
	printObjectInfo($output);
}
