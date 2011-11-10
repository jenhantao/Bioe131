#! /usr/bin/perl -w
#This block validates the input argument
if (@ARGV != 2) {
die "error: improper number of arguments given\nPlease specify a matrix file and a sequence file only.\n";
}



#initialize a 2D array
@scores = ();
readMatrix(matrix);


sub readMatrix() {
if (!-e $_[0]) {
die "error: specify a valid matrix file";
} else {
open (INPUT, $_[0]);
my @loaded;
	while (<INPUT>) {
	print $_;
	}
close INPUT;
return @loaded;
}
}
