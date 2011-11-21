#! /usr/bin/perl -w
#this subroutine reads a stockholm file given the assumptions specified in the assignment description
#the relevant information is stored in 2 arrays called @names and @matrix
#@names hold the names of the sequences
#@matrix stores the sequences in a 2 dimensional array
sub readStockholm {
if (!-e $_[0]) {
die "error: specify a valid Stockholm file";
} else {
	my @lines;
	open (INPUT, $_[0]);
	while (<INPUT>) {
		chomp;
		if ($_ !~ /^([#\/])+/) {
			my $line = $_;
			$line =~ s/^\s+//;
			push(@lines,uc($line));		
		}	
	}
	close (INPUT);
	@matrix = ();
	@names = ();
	for(my $i=0; $i<@lines; $i++) {
		#print substr($lines[$i],0,50)."\n";
		my @temp = split (' ', $lines[$i]);
		push (@names, $temp[0]);
		for (my $j=0; $j<length($temp[1]); $j++) {
			$matrix[$i][$j] = substr($temp[1], $j, 1);
			#print("i:$i, j:$j\n");	
		}
		
	}
	$height = scalar(@lines);
	$width = $#{$matrix[0]};
}
}

#this subroutine finds the probability distribution of a character x appearing in any column i
#results are stored in the hashtable @probDist
#the keys are given in the format 1U <= where the number indicates the column and the letter indicates the character; we check for both gap characters but use only '-' to define the key
sub findProbDist {
for (my $j=0; $j<$width+1; $j++) {
	my $A =0;
	my $U =0;
	my $C =0;	
	my $G =0;
	my $gaps =0;
	for (my $i=0; $i<$height; $i++) {
		if ($matrix[$i][$j] =~ /A/) {
			$A++;
		}elsif ($matrix[$i][$j] =~ /U/) {
			$U++;
		}elsif ($matrix[$i][$j] =~ /C/) {
			$C++;
		}elsif ($matrix[$i][$j] =~ /G/) {
			$G++;
		}elsif ($matrix[$i][$j] =~ /[\.-]/) {
			$gaps++;
		}
	}
#print "I found $A A, $U U, $G G, $C C, $gaps gaps at column $j\n";
$probDist{$j."A"} = $A/$height; 
$probDist{$j."U"} = $U/$height; 
$probDist{$j."C"} = $C/$height; 
$probDist{$j."G"} = $G/$height; 
$probDist{$j."-"} = $gaps/$height; 
}
}

#calculates the entropy of each column from the probability distributions
#stores the entropy in an array where array index indicates the column
sub findEntropy {
for (my$j=0; $j<$width+1; $j++) {
my $AS = 0;
my $US = 0;
my $CS = 0;
my $GS = 0;
my $gapS = 0;
if ($probDist{$j."A"}>0) {
	$AS = $probDist{$j."A"}*(log($probDist{$j."A"})/log(2));
}
if ($probDist{$j."U"}>0) {
	$US = $probDist{$j."U"}*(log($probDist{$j."U"})/log(2));
}
if ($probDist{$j."C"}>0) {
	$CS = $probDist{$j."C"}*(log($probDist{$j."C"})/log(2));
}
if ($probDist{$j."G"}>0) {
	$GS = $probDist{$j."G"}*(log($probDist{$j."G"})/log(2));
}
if ($probDist{$j."-"}>0) {
	$gapS = $probDist{$j."-"}*(log($probDist{$j."-"})/log(2));

}
	push(@entropies,-($AS+$US+$CS+$GS+$gapS));
}
#for($k=0;$k<@entropies;$k++) {
#print "k: $entropies[$k]\n";
#}
}


if (@ARGV>1) {
die "error: too many inputs given, please specify the name of 1 stockholm file only\n";
}
readStockholm($ARGV[0]);
findProbDist();
findEntropy();










