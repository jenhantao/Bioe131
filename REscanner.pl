#! /usr/bin/perl -w
@mysites = @{readREfasta($ARGV[0])};

$returnedSequence = removeRESites("cccccccATAgggggggATA",\@mysites);
print "my optimized sequence is:\n$returnedSequence\n";


#this subroutine takes as its argument 1 DNA nucleotide sequence and a list of RE sites; the list of RE sites should be given as a reference
#this subroutine will return 1 DNA sequence that encodes for the same polypeptide, but does not contain any of the restriction sites given
#start and stop codons are not required; removal of RE sites is achieved through silent mutations
sub removeRESites {
if (@_>2) {
	die "Error: Too many inputs\n";
}
my $sequence = $_[0];
my @sites = @{$_[1]};
foreach(@sites) {
	my $i = index($sequence, $_);
	my @REindices = ();
	while ($i > 0) {
		push(@REindices, $i);
		$i = index($sequence, $_, $i+1);
	}
	if (@REindices > 0) {
		print "found this site: $_\nat:";
		foreach(@REindices) {
			print "$_, ";
		}
		print "\n";
	}
}

}

#this subroutine takes a fasta file name as input 
sub readREfasta {
#Checks that only one argument is specified
if (@_>1) {
	die "Error: Too many inputs, please specify 1 Fasta file only\n";
}

#Checks that file exists
if (!-e $_[0]) {
	die "Error: Specify a valid file";
}
open (INPUT , $_[0]);
my @toReturn = ();
while (<INPUT>) {
	chomp;
	if ($_ !~ /^[\n\s\t\r>]+/ && $_ =~ /.+/) {
		push(@toReturn, $_);
	}
}
close (INPUT);
return \@toReturn;
}

