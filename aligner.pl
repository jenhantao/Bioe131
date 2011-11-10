#! /usr/bin/perl -w
sub readMatrix {
if (!-e $_[0]) {
die "error: specify a valid matrix file";
} else {
my @matrix;
my @letters;
my @lines;
open (INPUT, $_[0]);
	while (<INPUT>) {
	chomp;
	push(@lines,$_);
	}
close INPUT;
@letters = split("//",shift(@lines));
foreach(@lines) {
print($_."\n");
}
}
}

#This block validates the input argument
if (@ARGV != 2) {
die "error: improper number of arguments given\nPlease specify a matrix file and a sequence file only.\n";
}



#initialize a 2D array
@scores = ();
readMatrix ("matrix");



