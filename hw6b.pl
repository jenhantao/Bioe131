#! /usr/bin/perl -w
#The following if statements validates the input
if(@ARGV != 3) {
	die "Error: 3 input arguments must be specified. Each of these arguments correspond to an input file.\n";
}
if (!-e $ARGV[0]) {
	die "Error: Specify a valid file for input 1";
}
if (!-e $ARGV[1]) {
	die "Error: Specify a valid file for input 2";
}
if (!-e $ARGV[2]) {
	die "Error: Specify a valid file for input 3";
}
$e = 2.71828182845904523536028747135266249775724709369995; #mathimatical constant e
#read in the input files
@times1 = readInput($ARGV[0]);
@times2 = readInput($ARGV[1]);
@times3 = readInput($ARGV[2]);
#print basic statistics given the input
$spikes1 = scalar(@times1) - 1;
$spikes2 = scalar(@times2) - 1;
$spikes3 = scalar(@times3) - 1;
print "For File 1: $spikes1 spikes over $times1[-1] seconds \n";
print "For File 2: $spikes2 spikes over $times2[-1] seconds \n";
print "For File 3: $spikes3 spikes over $times3[-1] seconds \n";


#Calculate probability, using Poisson distribution.
$k = $spikes3;
#p1 = P(E3|A=0) 
$lambda1 = $spikes1 / $times1[-1] * $times3[-1];
$prob1 = $lambda1**$k * exp(-$lambda1) / fac($k);
#p2 = P(E3 | A=1)
$lambda2 = $spikes2 / $times2[-1] * $times3[-1];
$prob2 = $lambda2**$k * exp(-$lambda2) / fac($k);
#p3 = P(A=1|E3) = P(A=1) P(E3|A=1) / P(E3)
$prob3 = 0.01 * $prob2 / (0.01*$prob2 + 0.99*$prob1);

print "The posterior probability of E3 being activated is $prob3 \n";






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
#returns the average number of events per second given the input
sub computeEventRate {
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
 

