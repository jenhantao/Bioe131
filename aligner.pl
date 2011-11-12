#! /usr/bin/perl -w
#this subroutine reads in the matrix file and generates a hashtable corresponding to scores that will be used in the alignment
#the hash table is scored as the global variable scoreHash; subsequent calls to this method will update scoreHash with a new file
#the only argument should be the matrix's name
sub readMatrix {
if (!-e $_[0]) {
die "error: specify a valid matrix file";
} else {
my @lines;
open (INPUT, $_[0]);
	while (<INPUT>) {
	chomp;
	push(@lines,$_);
	}
close INPUT;
my @letters = split(' ',shift(@lines));
$gapPenalty = pop(@lines);
for (my $i=0; $i<@letters; $i++) {
	my @temp = split(' ', $lines[$i]);
	for (my $j=0; $j<@letters; $j++) {
		$scoreHash{$letters[$i].$letters[$j]} = $temp[$j];
		#print "$letters[$i].$letters[$j] gets a score of $temp[$j]\n"
	}
}
}
}

#this subroutine reads in a matrix file
sub readLines {

}

#This block validates the input argument
if (@ARGV != 2) {
die "error: improper number of arguments given\nPlease specify a matrix file and a sequence file only.\n";
}
#initialize a 2D array
@scores = ();
readMatrix ("matrix");
