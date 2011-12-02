#! /usr/bin/perl -w
use List::Util qw[min max];
#this subroutine reads in the matrix file and generates a hashtable corresponding to scores that will be used in the alignment
#the hash table is scored as the field scoreHash; subsequent calls to this method will update scoreHash with a new file
#the only argument should be the matrix's name

sub readMatrix {
	if (!-e $_[0]) {
		die "error: specify a valid matrix file";
	} 
	else {
		my @lines;
		open (INPUT, $_[0]);
		while (<INPUT>) {
			chomp;
			push(@lines,$_);
		}
		close INPUT;
		my @letters = split(' ',uc(shift(@lines)));
		$gapPenalty = pop(@lines);
		for (my $i=0; $i<@letters; $i++) {
			my @temp = split(' ', $lines[$i]);
			for (my $j=0; $j<@letters; $j++) {
				$scoreHash{$letters[$i].$letters[$j]} = $temp[$j];
			}#end for
		}#end for
	}#end else
} #end readMatrix

#this subroutine reads in the sequence file, updating the field sequences, which is an array containing all the sequences in the sequence file
sub readLines {
	if (!-e $_[0]) {
		die "error: specify a valid sequence file";
	} 
	else {
		my @lines;
		open (INPUT, $_[0]);
		while (<INPUT>) {
			chomp;
			push(@lines,$_);
		}
		close INPUT;
		for(my $i=0; $i<@lines-1; $i++) {
			if($lines[$i] =~ /^(>){1}/) {
				push(@names, substr($lines[$i],1));
				push(@sequences, uc($lines[$i+1]));
			}
		}
		if (@sequences<2) {
			die "error: at least 2 sequences must be specified in the sequence file";
		}#end if
	}#end else
} #end readLines

#this subroutine will generate the scoring matrix for the alignment, which is one of the 2 required outputs for this assignment
sub fillScoreMatrix {
	my $sequence1 = $sequences[0];
	my $sequence2 = $sequences[1];
	$N = length($sequence1);
	$M = length($sequence2);
	@scores = ();
	$scores[0][0] = 0;
	for($i = 1; $i < $N + 1; $i++) {
		$scores[$i][0] = $gapPenalty * $i;
	}
		
	for($j = 1; $j < $M + 1; $j++) {
		$scores[0][$j] = $gapPenalty * $j;
	}

	#the 3 different cases are described in the assignment description	
	for($i = 1; $i < $N + 1; $i++) {
		for($j = 1; $j < $M + 1; $j++) {
			# Case 1
			$char1 = substr($sequence1, $i - 1, 1);
			$char2 = substr($sequence2, $j - 1, 1);
			$case1 = $scores[$i - 1][$j - 1] + $scoreHash{"$char1$char2"};		
			# Case 2
			$case2 = $scores[$i - 1][$j] + $gapPenalty;		
			# Case 3
			$case3 = $scores[$i][$j - 1] + $gapPenalty;		
			$scores[$i][$j] = max($case1, $case2, $case3);
		}
	}
}#end fillScoreMatrix

#This subroutine fulfills one of the requirements for the assignment by printing out the score matrix
#this subroutine uses program fields and so no inputs are necessary
sub printScoreMatrix {
	my $sequence1 = $sequences[0];
	my $sequence2 = $sequences[1];
	for($k = 0; $k < $M +2; $k++) {
		print "\|\t";
		if($k == 0 or $k == 1) {
			print "* ";
		}
		else {
			print substr($sequence2, $k - 2, 1);
		}
	}
	
	print "\|\n";
	
	for($i = 1; $i < $N + 2; $i++) {
		if($i == 0 or $i == 1) {
			$current = "*";
		}
		else {
			$current = substr($sequence1, $i - 2, 1);
		}
		print "\|\t$current";
		for($j = 0; $j < $M + 1; $j++) {
			print "\|\t";
			print $scores[$i - 1][$j];
		}
		print "|\n";
	}
}#end printScoreMatrix

#this subroutine will return the alignment using the scoring matrix.  Every other subroutine needs to be called first to populate necessary program fields
#the implementation is described in the assignment description
sub performTraceback {
	my $i = $N;
	my $j = $M;

	$align1 = "";
	$align2 = "";

	my $sequence1 = $sequences[0];
	my $sequence2 = $sequences[1];

	while($i != 0 and $j != 0) {
		$currentScore = $scores[$i][$j];
		#Case 1
		if($currentScore == $scores[$i - 1][$j] + $gapPenalty) {
			$align1 .= "-";
			$align2 .= substr($sequence1, $i - 1, 1);
			$i--;
		}
		#Case 2
		elsif($currentScore == $scores[$i][$j - 1] + $gapPenalty) {
			$align1 .= substr($sequence2, $j - 1, 1);
			$align2 .= "-";
			$j--;
		}
		#case 3
		else {
			$align1 .= substr($sequence2, $j - 1, 1);
			$align2 .= substr($sequence1, $i - 1, 1);
			$i--;
			$j--;
		}
	}

	$align1 = reverse($align1);
	$align2 = reverse($align2);
	#accounts for the number of characters displayed per line
	$align1 =~ s/(\S{1,80})/$1\n/g;
	$align2 =~ s/(\S{1,80})/$1\n/g;

	@align1Lines = split(/\s/, $align1);
	@align2Lines = split(/\s/, $align2);

	print "\n$names[0] aligned to $names[1]\n";	
		
	for($i = 0; $i < max(@align1Lines + 0, @align2Lines + 0); $i++) {
		print $align2Lines[$i];
		print "\n";
		print $align1Lines[$i];
		print "\n\n";
	}
} #end performTraceback	

#This block validates the input argument
if (@ARGV != 2) {
	die "error: improper number of arguments given\nPlease specify a matrix file and a sequence 	file only.\n";
}
#initialize a 2D array
readMatrix ($ARGV[0]);
readLines($ARGV[1]);
fillScoreMatrix();
printScoreMatrix();
performTraceback();





