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
#this subroutine will find the joint probabilities and store it in a hash
#key is given in the format ixjy
sub findJointProb {
for(my $i=0; $i<$width+1; $i++) {
		my @iArows = ();
		my @iUrows = ();
		my @iCrows = ();
		my @iGrows = ();
		my @igaprows = ();
		for (my $k=0; $k<$height; $k++) {
			if ($matrix[$k][$i] =~ /A/) {
			push(@iArows,$k);
			} elsif ($matrix[$k][$i] =~ /U/) {
			push(@iUrows,$k);
			} elsif ($matrix[$k][$i] =~ /G/) {
			push(@iGrows,$k);
			} elsif ($matrix[$k][$i] =~ /C/) {
			push(@iCrows,$k);
			} elsif ($matrix[$k][$i] =~ /[\.-]/) {
			push(@igaprows,$k);
			}
		}
	for(my $j=$i+1; $j<$width+1; $j++) {
		my $numA =0;
		my $numU =0;
		my $numG =0;
		my $numC =0;
		my $numgaps =0;
		for(my $l=0; $l<@iArows; $l++) {
			if($matrix[$l][$j] =~ /A/) {
				$numA++;
			} elsif ($matrix[$l][$i] =~ /U/) {
				$numU++;
			} elsif ($matrix[$l][$i] =~ /G/) {
				$numG++;
			} elsif ($matrix[$l][$i] =~ /C/) {
				$numC++;
			} elsif ($matrix[$l][$i] =~ /[\.-]/) {
				$numgaps++;
			}
		}
		$jointProbDist{$i."A".$j."A"} = $numA/$height;
		$jointProbDist{$i."A".$j."U"} = $numU/$height;
		$jointProbDist{$i."A".$j."G"} = $numG/$height;
		$jointProbDist{$i."A".$j."C"} = $numC/$height;
		$jointProbDist{$i."A".$j."-"} = $numgaps/$height;


		$numA =0;
		$numU =0;
		$numG =0;
		$numC =0;
		$numgaps =0;
		for(my $l=0; $l<@iUrows; $l++) {
			if($matrix[$l][$j] =~ /A/) {
				$numA++;
			} elsif ($matrix[$l][$i] =~ /U/) {
				$numU++;
			} elsif ($matrix[$l][$i] =~ /G/) {
				$numG++;
			} elsif ($matrix[$l][$i] =~ /C/) {
				$numC++;
			} elsif ($matrix[$l][$i] =~ /[\.-]/) {
				$numgaps++;
			}
		}
		$jointProbDist{$i."U".$j."A"} = $numA/$height;
		$jointProbDist{$i."U".$j."U"} = $numU/$height;
		$jointProbDist{$i."U".$j."G"} = $numG/$height;
		$jointProbDist{$i."U".$j."C"} = $numC/$height;
		$jointProbDist{$i."U".$j."-"} = $numgaps/$height;



		$numA =0;
		$numU =0;
		$numG =0;
		$numC =0;
		$numgaps =0;
		for(my $l=0; $l<@iGrows; $l++) {
			if($matrix[$l][$j] =~ /A/) {
				$numA++;
			} elsif ($matrix[$l][$i] =~ /U/) {
				$numU++;
			} elsif ($matrix[$l][$i] =~ /G/) {
				$numG++;
			} elsif ($matrix[$l][$i] =~ /C/) {
				$numC++;
			} elsif ($matrix[$l][$i] =~ /[\.-]/) {
				$numgaps++;
			}
		}
		$jointProbDist{$i."G".$j."A"} = $numA/$height;
		$jointProbDist{$i."G".$j."U"} = $numU/$height;
		$jointProbDist{$i."G".$j."G"} = $numG/$height;
		$jointProbDist{$i."G".$j."C"} = $numC/$height;
		$jointProbDist{$i."G".$j."-"} = $numgaps/$height;
	



		$numA =0;
		$numU =0;
		$numG =0;
		$numC =0;
		$numgaps =0;
		for(my $l=0; $l<@iCrows; $l++) {
			if($matrix[$l][$j] =~ /A/) {
				$numA++;
			} elsif ($matrix[$l][$i] =~ /U/) {
				$numU++;
			} elsif ($matrix[$l][$i] =~ /G/) {
				$numG++;
			} elsif ($matrix[$l][$i] =~ /C/) {
				$numC++;
			} elsif ($matrix[$l][$i] =~ /[\.-]/) {
				$numgaps++;
			}
		}
		$jointProbDist{$i."C".$j."A"} = $numA/$height;
		$jointProbDist{$i."C".$j."U"} = $numU/$height;
		$jointProbDist{$i."C".$j."G"} = $numG/$height;
		$jointProbDist{$i."C".$j."C"} = $numC/$height;
		$jointProbDist{$i."C".$j."-"} = $numgaps/$height;

		$numA =0;
		$numU =0;
		$numG =0;
		$numC =0;
		$numgaps =0;
		for(my $l=0; $l<@igaprows; $l++) {
			if($matrix[$l][$j] =~ /A/) {
				$numA++;
			} elsif ($matrix[$l][$i] =~ /U/) {
				$numU++;
			} elsif ($matrix[$l][$i] =~ /G/) {
				$numG++;
			} elsif ($matrix[$l][$i] =~ /C/) {
				$numC++;
			} elsif ($matrix[$l][$i] =~ /[\.-]/) {
				$numgaps++;
			}
		}
		$jointProbDist{$i."-".$j."A"} = $numA/$height;
		$jointProbDist{$i."-".$j."U"} = $numU/$height;
		$jointProbDist{$i."-".$j."G"} = $numG/$height;
		$jointProbDist{$i."-".$j."C"} = $numC/$height;
		$jointProbDist{$i."-".$j."-"} = $numgaps/$height;
	}
}
}


if (@ARGV>1) {
die "error: too many inputs given, please specify the name of 1 stockholm file only\n";
}
readStockholm($ARGV[0]);
findProbDist();
findEntropy();
findJointProb();
$test=$jointProbDist{'1A2-'};

print "$test\n";









