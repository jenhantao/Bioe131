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

#define which nucleotides match
%bases =(
A => "U",
U => "A",
C => "G",
G => "C"
);
if("C"=~$bases{U}) {
print "moo\n";
}
calcMaxMatches(uc($ARGV[0]));

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
	for ($j=$i+1;$j<=length($seq); $j++) {
	#assign N(i,j)
	#@scores[$i,$j]= max( N(i+1,j-1)+1 if there is a match at the end, N(i+1,j), N(i,j-1)
	if($bases{substr($seq,$i,1)} =~ substr($seq,$j-1,1)) {
	@scores[$i,$j]= max(0);
	print "MATCH\n";
	} else {
	print "merh\n";
	}	

		for ($k=$i+1;$k<=$j-1; $k++) {
		#assign N(i,j)
		#@scores[$i][$j] = max ( N(i,j),  N(i,k) + N(k+1,j) 
		#print "i: $i j: $j k: $k\n";
		}	
	}
} 
}


sub max {
my @sorted =sort { $a <=> $b } @_;
return $sorted[@sorted-1];
}


