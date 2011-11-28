#! /usr/bin/perl -w
$e = 2.71828182845904523536028747135266249775724709369995; #mathimatical constant e

#returns the factorial given an input n
sub fac {
my $n = $_[0];
if ($n < 2) {
	return $n;
} else {
	return $n * fac($n-1);
}
}


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

#this subroutine takes as its only argument, an array of time values
#returns the lambda value given the input
sub computeLambda {
#$length = @_;
#print ("$length divided by $_[$length-1]\n");
my $toReturn = @_/$_[@_-1];
return $toReturn;
}

#this subroutine computes the probability that a number of events will occur given the expected number of events in a time interval. ie k and lambda
#returns the probability described above as a scalar
sub computePoissonDistribution {
my $k = $_[0];
my $lambda = $_[1];
#print "$lambda^$k\n";
#print "$e^(-$lambda)\n";
#print fac($k)."\n";
my $toReturn = (($lambda**($k))*$e**(-$lambda))/(fac($k));
return $toReturn;
}



@array = readInput($ARGV[0]);
computeLambda(@array);
print (computePoissonDistribution(2,2)."\n");
