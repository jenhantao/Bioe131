#! /usr/bin/perl -w
#This block validates the input argument
if (@ARGV != 1) {
die "error: improper number of arguments given\n the only argument should be an RNA sequence (case insensitive).\n";
} elsif ($ARGV[0] =~ /[^augc]+/) {
die "error: invalid characters contained in input sequence";
} 
#initialize a 2D array
for ($i=1; $i<=length($ARGV[0]); $i++) {
$scores[$i] = ["0"];	
}
calcMaxMatches($ARGV[0]);


#test block
#for ($i=1; $i<=length($ARGV[0]); $i++) {
#	for ($j=1; $j<=length($ARGV[0]); $j++) {
#	$arrayOfArrays[$i][$j] = $i*$j;	
#	}	
#}
foreach my $row(@scores){
   foreach my $val(@$row){
	if (defined($val)){      
	print "$val ";
	}
   }
   print "\n";
}

sub calcMaxMatches {
my $seq =$_[0];
for ($i = length($seq); $i>0; $i--) {
	$scores[$i][$i]=0;
	print "position ($i,$i) is 0\n";
	for ($j=$i+1;$j<=length($seq); $j++) {
		for ($k=$i+1;$k<=$j-1; $k++) {
		#assign N(i,j)
		#@scores[$i][$j] = max ( N(i,j),  N(i,k) + N(k+1,j) 
		print "i: $i j: $j k: $k\n";
		}	
	}
} 
}
