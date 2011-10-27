#! /usr/bin/perl -w
use List::Util qw[min max];
#This block validates the input argument
if (@ARGV != 1) {
die "error: improper number of arguments given\n the only argument should be an RNA sequence (case insensitive).\n";
}
 elsif ($ARGV[0] =~ /[^augc]+/) {
die "error: invalid characters contained in input sequence";
} 
#initialize a 2D array
#for ($i=1; $i<=length($ARGV[0]); $i++) {
#$scores[$i] = ["0"];	
#}
@scores =();

#define which nucleotides match
%bases =(
A => "U",
U => "A",
C => "G",
G => "C"
);
print "final score: ".calcMaxMatches(uc($ARGV[0]))."\n";

sub calcMaxMatches {
my $seq =$_[0];
for ($i = length($seq)-1; $i>-1; $i--) {
	$scores[$i][$i]=0;
	for ($j=$i+1;$j<length($seq); $j++) {
	#assign N(i,j)
	#@scores[$i,$j]= max( N(i+1,j-1)+1 if there is a match at the end, N(i+1,j), N(i,j-1)
	
	if($bases{substr($seq,$i,1)} =~ substr($seq,$j,1)) {
	$bonus = 1;
	$lastBase = substr($seq, $j, 1);
	$firstBase = substr($seq, $i, 1);
	
	print "match between $firstBase and $lastBase \n";
	} else {
	$bonus = 0;
	}
	if (defined($scores[$i + 1][$j - 1])){
	$caseA = $scores[$i + 1][$j - 1] + $bonus;
	} else {
	$caseA = $bonus;
	}
	if (defined($scores[$i + 1][$j])) {
	$caseB = $scores[$i + 1][$j];
	} else {
	$caseB = 0;
	}
	if (defined($caseC = $scores[$i][$j + 1])){
	$caseC = $scores[$i][$j + 1];
	} else {
	$caseC=0;
	}


	$scores[$i][$j] = max($caseA, $caseB, $caseC);


	#$sub1 = substr($seq, $i+1, $j-1-($i+1));
	#$sub2 = substr($seq, $i+1, $j-($i+1));
	#$sub3 = substr($seq, $i, ($j-1)-$i);
	#print "first: $sub1\nsecond: $sub2\nthird: $sub3\n";
	#@scores[$i,$j]= max(calcMaxMatches(substr($seq, $i+1, $j-1-($i+1)))+$bonus, 
	#		    calcMaxMatches(substr($seq, $i+1, $j-($i+1))), 
	#		    calcMaxMatches(substr($seq, $i, ($j-1)-$i))
	#		);

		for ($k=$i+1;$k<=$j-1; $k++) {
		$scores[$i][$j] = max($scores[$i][$j], $scores[$i][$k] + $scores[$k + 1][$j]);

		#assign N(i,j)
		#@scores[$i][$j] = max ( N(i,j),  N(i,k) + N(k+1,j) 
	#@scores[$i,$j]= max($scores[$i][$j], 
	#		    calcMaxMatches(substr($seq, $i, $k-$i)), 
	#		    calcMaxMatches(substr($seq, $k+1, $j-($k+1)))
	#		);

		#print "i: $i j: $j k: $k\n";
		}	
	}
}
return $scores[1][length($seq)-1];
}


#sub max {
#my @sorted =sort { $a <=> $b } @_;
#return $sorted[@sorted-1];
#}


