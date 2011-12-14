#! /usr/bin/perl -w
@mysites = @{readREfasta($ARGV[0])};

$returnedSequence = removeRESites("cccgggaaaATAtttcccATA",\@mysites);
print "my optimized sequence is:\n$returnedSequence\n";
swapCodon("cccgggaaaATAtttcccATA", 9,\@mysites);


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

#this subroutine takes 2 inputs: a sequence and a list of RE sites to check for 
#returns 1 if a RE site is found and a 0 if no RE sites are found
sub checkRESites {
my $sequence = $_[0];
my @sites = @{$_[1]};
foreach(@sites) {
	if (index($sequence, $_) > 0) {
		return 1;
	}
}
return 0;
}

#this subroutine takes a fasta file name as input 

#this subroutine takes a sequence and an offending position within that sequence as well as a list of RE sites that should not appear in the returned sequence
#this subroutine will switch the codon containing the offending position with preceding codons such that no RE stes given in the argument will be found
sub swapCodon {
my $sequence = $_[0];
my $position = $_[1];
my @sites = @{$_[2]};
my $length = length($sequence);
$cp = int($position / 3);
print "offending position is in codon $cp\n";

#switch codon i with the offending codon
for (my $i=0; $i < $cp; $i++) {
	print "i: $i\n";
	print "before:$sequence\n";
	print "swithing ".substr($sequence, $cp*3, 3)." with ".substr($sequence, $i*3, 3)."\n";
	my $toReturn = substr($sequence,0,$i*3).substr($sequence, $cp*3, 3).substr($sequence, $i*3+3, $cp*3-($i*3+3)).substr($sequence, $i*3,3).substr($sequence,$cp*3+3, $length-($cp*3+3));  
	print "after: $toReturn\n";
}

}

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

