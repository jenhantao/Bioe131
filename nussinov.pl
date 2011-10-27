#! /usr/bin/perl -w
#This block validates the input argument
if (@ARGV != 1) {
die "error: improper number of arguments given\n the only argument should be an RNA sequence (case insensitive).\n";
}
 elsif ($ARGV[0] =~ /[^augc]+/) {
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
	} else {
	$bonus = 0;
	}
	$scores[$i][$j] = max($scores[$i + 1][$j - 1] + $bonus,
                              $scores[$i + 1][$j],
                              $scores[$i][$j + 1]
                          );
		for ($k=$i+1;$k<=$j-1; $k++) {
		$scores[$i][$j] = max($scores[$i][$j], $scores[$i][$k] + $scores[$k + 1][$j]);
		}	
	}
}
return $scores[0][length($seq)-1];
}


sub max {
my $max = $_[0];
for (@_) {
if (defined($_)) {
	if ($_ > $max) {
	$max = $_;
	}
}
}
return $max
}


