########################################################################
# Bio::KBase::ObjectAPI::KBaseGenomes::Genome - This is the moose object corresponding to the Genome object
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
# Date of module creation: 2012-03-26T23:22:35
########################################################################
use strict;
use Bio::KBase::ObjectAPI::KBaseGenomes::DB::Genome;
package Bio::KBase::ObjectAPI::KBaseGenomes::Genome;
use Moose;
use namespace::autoclean;
extends 'Bio::KBase::ObjectAPI::KBaseGenomes::DB::Genome';
#***********************************************************************************************************
# ADDITIONAL ATTRIBUTES:
#***********************************************************************************************************
has geneAliasHash => ( is => 'rw',printOrder => 2, isa => 'HashRef', type => 'msdata', metaclass => 'Typed', lazy => 1, builder => '_buildgeneAliasHash' );


#***********************************************************************************************************
# BUILDERS:
#***********************************************************************************************************
sub _buildgeneAliasHash {
	my ($self) = @_;
	my $geneAliases = {};
	my $ftrs = $self->features();
    foreach my $ftr (@{$ftrs}) {
    	$geneAliases->{$ftr->id()} = $ftr;
    	foreach my $alias (@{$ftr->aliases()}) {
    		$geneAliases->{$alias} = $ftr;
    	}
    }
    return $geneAliases;
}

#***********************************************************************************************************
# CONSTANTS:
#***********************************************************************************************************

#***********************************************************************************************************
# FUNCTIONS:
#***********************************************************************************************************
sub genome_typed_object {
    my ($self) = @_;
	my $output = $self->serializeToDB();
	my $contigset = $self->contigset();
	my $contigserial = $contigset->serializeToDB();
	$output->{contigs} = $contigserial->{contigs};
	for (my $i=0; $i < @{$output->{contigs}}; $i++) {
		$output->{contigs}->[$i]->{dna} = $output->{contigs}->[$i]->{sequence};
		delete $output->{contigs}->[$i]->{sequence};
	}
	return $output;
}

=head3 searchForFeature
Definition:
	Bio::KBase::ObjectAPI::KBaseGenomes::Feature = Bio::KBase::ObjectAPI::KBaseGenomes::Feature->searchForFeature(string);
Description:
	Searches for a gene by ID, name, or alias.

=cut

sub searchForFeature {
	my ($self,$id) = @_;
	return $self->geneAliasHash()->{$id};
}

__PACKAGE__->meta->make_immutable;
1;
