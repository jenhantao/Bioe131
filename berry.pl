use List::Util qw[min max];

sub getCharacters {
	$matrixFile = $_[0];
	@lines = <$matrixFile>;
	
	for($row = 0; $row < @lines + 0; $row++) {
		@line = split(/ /, uc $lines[$row]);
		@line = map { local $_ = $_; s/\s//; $_ } @line;

		if($row == 0) {
			@characters = @line;
		}
	}
	
	return(\@characters);
}

sub parseMatrix {
	$matrixFile = $_[0];
	@lines = <$matrixFile>;
	
	%scoreHash = ();
	
	for($row = 0; $row < @lines + 0; $row++) {
		@line = split(/ /, uc $lines[$row]);
		@line = map { local $_ = $_; s/\s//; $_ } @line;

		if($row == 0) {
			@characters = @line;
		}
		
		elsif($row != @lines - 1) {
			$rowCharacter = $characters[$row - 1];
			
			for($col = 0; $col < @line + 0; $col++) {
				$colCharacter = $characters[$col];
				$scoreHash{"$rowCharacter$colCharacter"} = int($line[$col]);
			}
		}
		
		# Get the gap score.
		else {
			$scoreHash{"gap_score"} = int($line[0]);
		}
	}
	
	return(%scoreHash);
}

sub parseString {
	$stringFile = $_[0];
	@lines = <$stringFile>;
	
	$numStrings = 0;
	
	for($i = 0; $i < @lines + 0; $i++) {
		$line = $lines[$i];
		
		if($line =~ /^>/ and $numStrings < 2) {
			$stringName = substr($line, 1);
			$stringName =~ s/\n//g;
			$numStrings++;
			$string = "";
			
			$j = $i + 1;
			
			while($j < @lines + 0 and not($lines[$j] =~ /^>/)) {
				$string .= uc $lines[$j];
				$j++;
			}
			
			$string =~ s/\s//g;
			
			if($numStrings == 1) {
				$name1 = $stringName;
				$string1 = $string;
			}
			
			else {
				$name2 = $stringName;
				$string2 = $string;
			}
		}
	}

	return($string1, $string2);
}

sub generateScoreMatrix {
	$string1 = $_[0];
	$string2 = $_[1];
	
	$N = length($string1);
	$M = length($string2);
	
	@score = ();
	$score[0][0] = 0;
	
	for($i = 1; $i < $N + 1; $i++) {
		$score[$i][0] = $gapScore * $i;
	}
	
	for($j = 1; $j < $M + 1; $j++) {
		$score[0][$j] = $gapScore * $j;
	}
	
	for($i = 1; $i < $N + 1; $i++) {
		for($j = 1; $j < $M + 1; $j++) {
			# Case 1
			$char1 = substr($string1, $i - 1, 1);
			$char2 = substr($string2, $j - 1, 1);
			$case1 = $score[$i - 1][$j - 1] + $scoreHash{"$char1$char2"};
			
			# Case 2
			$case2 = $score[$i - 1][$j] + $gapScore;
			
			# Case 3
			$case3 = $score[$i][$j - 1] + $gapScore;
			
			$score[$i][$j] = max($case1, $case2, $case3);
		}
	}
	return(\@score);
}

sub alignSequences {
	$i = $N;
	$j = $M;
	
	$align1 = "";
	$align2 = "";
	
	while($i != 0 and $j != 0) {
		$currentScore = $scoreMatrix[$i][$j];
		# Case 1
		if($currentScore == $scoreMatrix[$i - 1][$j] + $gapScore) {
			$align1 .= "-";
			$align2 .= substr($string1, $i - 1, 1);
			
			$i--;
			
		}
		
		elsif($currentScore == $scoreMatrix[$i][$j - 1] + $gapScore) {
			$align1 .= substr($string2, $j - 1, 1);
			$align2 .= "-";
			
			$j--;
			
		}
		
		else {
			$align1 .= substr($string2, $j - 1, 1);
			$align2 .= substr($string1, $i - 1, 1);
			
			$i--;
			$j--;
			
		}
	}
	
	$align1 = reverse($align1);
	$align2 = reverse($align2);
	
	$align1 =~ s/(\S{1,80})/$1\n/g;
	$align2 =~ s/(\S{1,80})/$1\n/g;
	
	@align1Lines = split(/\s/, $align1);
	@align2Lines = split(/\s/, $align2);
	
	print "\n$name1 aligned to $name2\n";	
		
	for($i = 0; $i < max(@align1Lines + 0, @align2Lines + 0); $i++) {
		print $align2Lines[$i];
		print "\n";
		print $align1Lines[$i];
		print "\n\n";
	}
}	

sub printMatrix {
	for($k = 0; $k < $M + 2; $k++) {
		print "\|\t";
		if($k == 0 or $k == 1) {
			print "* ";
		}
		
		else {
			print substr($string2, $k - 2, 1);
		}
	}
	
	print "\|\n";
	
	for($i = 1; $i < $N + 2; $i++) {
		if($i == 0 or $i == 1) {
			$chari = "*";
		}
		
		else {
			$chari = substr($string1, $i - 2, 1);
		}
		
		print "\|\t$chari";
		
		for($j = 0; $j < $M + 2; $j++) {
			print "\|\t";
			print $scoreMatrix[$i - 1][$j];
		}
		print "\n";
	}
}

if(!(open($matrix, $ARGV[0]))) {
	die "Please enter a valid matrix file.\n";
}

elsif(!(open($string, $ARGV[1]))) {
	die "Please enter a valid string file.\n";
}

%scoreHash = &parseMatrix($matrix);
$gapScore = $scoreHash{"gap_score"};
delete($scoreHash{"gap_score"});

$charactersRef = &getCharacters($matrix);
@characters = @$charactersRef;

($string1, $string2) = &parseString($string);

if($string1 =~ m/[^@characters]/g or $string2 =~ m/[^@characters]/g) {
	die("Error: invalid characters in string.\n");
}

$scoreRef = &generateScoreMatrix($string1, $string2);
@scoreMatrix = @$scoreRef;

&printMatrix();
&alignSequences($scoreRef);
