#! /usr/bin/perl -w

#this subroutine takes in one argument, which should specify a file containing spike times
#this subroutine will return an array containing the lines of the input file
sub readInput {
open(INPUT, $_[0]);
my @toReturn = ();
while(<INPUT>) {
	chomp;
	if($_ !~ /^(\s)+/) {
		push(@toReturn, $_);
	}
}
close(INPUT);
return @toReturn;
}


sub computeLambda {

}
