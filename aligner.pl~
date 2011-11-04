#! /usr/bin/perl -w
#This block validates the input argument
if (@ARGV != 1) {
die "error: improper number of arguments given\n the only argument should be an RNA sequence (case insensitive).\n";
}
 elsif ($ARGV[0] =~ /[^augcAUGC]+/) {
die "error: invalid characters contained in input sequence";
} 
#initialize a 2D array
@scores = ();
$seqLength = length($ARGV[0])-1;
for ($i=0; $i<=$seqLength; $i++) {
	for ($j=0; $j<$seqLength; $j++) {
	$scores[$i][$j] = 0;
	}
}
