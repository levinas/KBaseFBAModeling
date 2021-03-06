#
# This is a SAS Component
#

package ModelSEED::Client::FBAMODEL;

use strict;
use base qw(myRAST::ClientThing);

sub new {
    my($class, @options) = @_;
    my %options = myRAST::ClientThing::FixOptions(@options);
	if (!defined($options{url})) {
		#$options{url} = "http://bioseed.mcs.anl.gov/~chenry/FIG/CGI/FBAMODEL_server.cgi";
		$options{url} = "http://pubseed.theseed.org/model-prod/FBAMODEL_server.cgi";
	}
    return $class->SUPER::new("ModelSEED::ServerBackends::FBAMODEL" => %options);
}

1;
