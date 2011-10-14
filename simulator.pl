#! /usr/bin/perl -w
$length = @ARGV;
#No argument run of this program should give sequence of uniform composition with length of 1 kbp
open(OUTPUT, ">simulatedSequence.fasta");
if ($length ==0 ) {
print OUTPUT generateSequence(25, 25, 25, 25, 1000,"Simulated Sequence");
} elsif($length > 0) { #loop through the supplied arguments
@default = ("25", "25", "25", "25", "1000");
	for(my $i=0; $i<$length; $i++){
		if($ARGV[$i] =~/^-calc/) {
			if(defined($ARGV[$i+1])) {
			open(CALCINPUT,$ARGV[$i+1]);
			if (!-e CALCINPUT) {
			die "input file for calculation does not exist\n";
			} 
			#while loop below will add all nonblank lines to an array
				while ($line = <CALCINPUT>) {
				chomp($line);
				if ($line =~ /(.){1,}/) {
				push(@nonBlankLines, $line);
				}
			}		
			close(CALCINPUT);
			@nonBlankLines[scalar(@nonBlankLines)]=""; #while loop pulls an extra blank line, define this extra line or error occurrs
			#for loop below iterates through all non blank lines, operates on the lines and then prints into the file "output.fasta"
			for ($j= 0; $j< scalar(@nonBlankLines); $j++) {
				if ($nonBlankLines[$j] =~ /^(>){1}/) {
				$j++;
				$sequence = "";
					while ($nonBlankLines[$j] =~ /^([agctAGCT])+/ && $j< scalar(@nonBlankLines)) { 
					$sequence = $sequence.$nonBlankLines[$j];
					$j++;		
					}
				$j--;
				push(@params, calcStats($sequence));
				}
			}
			} else {
			die "error: please specify a file to calculate from";
			}
		} elsif($ARGV[$i] =~/^-load/) {
			if(defined($ARGV[$i+1])) {
			@params =load($ARGV[$i+1]);
			} else {
			die "error: please specify a file to load";
			}
		} elsif($ARGV[$i] =~/^-save/) { #loads default configurations if save is called before load or calc
			if (!defined($params[0])) {
			@params = @default;
			}
			if(defined($ARGV[$i+1])) {
			$saveParamTitle = $ARGV[$i+1];
			$i++;
			} else {
			$saveParamTitle = "savedParams";
			}
			save(@params);
		#display help
		} elsif($ARGV[$i] =~/^-h/) {
		print "The following options are available to this program: -load, -save, -calc, -h.  -load is invoked by supplying -load followed by a file name when the program is run. -calc and -save are invoked in a similar fasion. -save will automatically use the name savedParams if no file name is given.  Arguments can be called in order, but they are interpreted sequentially. And so calling -save before -calc will cause the default parameters (uniform composition) instead of the composition calculated with -calc\n";
		}
	}

}


$paramLength = @params;
$seqNumber = 1;
for ($i =0; $i < $paramLength; $i += 5) {
$sequence = generateSequence($params[$i], $params[$i+1], $params[$i+2], $params[$i+3], $params[$i+4], "sequence$seqNumber");
$seqNumber++;
print OUTPUT $sequence;
}
close OUTPUT;


#this subroutine reads in a parameter file, the only input is the filename
#return a list of parameter denoting parameters for sequence generation, pulls all integers
sub load{
if (!-e $_[0]) {
die "error: specify a valid file to load";
} else {
open (INPUT, $_[0]);
my @loaded;
	while (<INPUT>) {
	chomp($_);
		while ($_ =~ /([\d.]){1,}/g) {
		push (@loaded, $&);
		}
	}
close INPUT;
return @loaded;
}
}


#this subroutine saves the statistics for one sequence into a file
#inputs required are an array containing the output of subroutine calcStats and a file to save into
sub save{
my $saveLength = @_;
open(PARAM, ">$saveParamTitle");
my @stats = @_;
for ($i =0; $i < $saveLength-1; $i += 5) {
print PARAM "Composition: $stats[$i] $stats[$i+1] $stats[$i+2] $stats[$i+3] \n";
print PARAM "Length: $stats[$i+4]\n";
}
close(PARAM);
}




#This subroutine returns statistics related to an input sequence in the following order: percentage of A, T, C, and G, and then length. The statistic are returned in an array that whose indices correspond to the order described above.
sub calcStats {
my $length = @_;
#if block below does basic error checking
if ($length != 1) {
die "error: too many arguments";
} elsif (!$_[0] =~ /[agct]/i) {
die "error: subroutine calc detected an illegal character in input DNA sequence";
}
my $seq = $_[0];
$seq = (uc ($seq));
chomp($seq);
$length = length ($seq);
my $numA = sprintf("%.2f",($seq =~ tr/A/A/)/$length*100);
my $numT = sprintf("%.2f",($seq =~ tr/T/T/)/$length*100);
my $numC = sprintf("%.2f",($seq =~ tr/C/C/)/$length*100);
my $numG = sprintf("%.2f",($seq =~ tr/G/G/)/$length*100);
my @toReturn = ("$numA", "$numT", "$numC", "$numG", "$length");
return @toReturn;
}



#This subroutine requires 4 arguments, which should be given in the following order: %A, %T, %C, %G, length, name
#percentage of A, T, C, G should be given in percentage, not decimal notation
#This subroutine returns a string that corresponds to a FASTA 
sub generateSequence {
my $length = @_;
#if block below does basic error checking
if ($length != 6) {
die "insufficient arguments given to subroutine generateSequence";
} elsif ($_[4] < 0) {
die "must generate a sequence with positive length";
}
my $description =">$_[5] $_[0]% A $_[1]% T $_[2]% C $_[3]% G $_[4] bp\n"; #top line gives name, composition, and length
$length = $_[4] + $_[4] % 3 - 6; #ensure that length is a multiple of 3 and account for start and stop codon
my $numA = int($_[0]/100*$_[4] * $length)-1;
my $numT = int($_[1]/100*$_[4] * $length)-1;
my $numC = int($_[2]/100*$_[4] * $length);
my $numG = int($_[3]/100*$_[4] * $length)-1;
#randomly select a stop codon and modify the number of A, T, C, and G accordingly
my $rand = int(rand(3));
my $stop = "TAG";
if ($rand == 0){
$stop = "TAG";
$numT--;
$numA--;
$numG--;
} elsif ($rand == 1){
$stop = "TAA";
$numT--;
$numA-=2;
} else {
$stop = "TGA";
$numT--;
$numA--;
$numG--;
}
my $toReturn = "ATG"; #each sequence returned must start with a start codon
for (my $i =3; $i < $length+3; $i++) {
$nucAdded = 0;
	#every line should only have 80 characters
	if ($i%80 ==0) {
	$toReturn = $toReturn."\n";
	}
	while ($nucAdded == 0){
	$rand = int(rand(5));
		if($rand == 0 && $numA > 0) {
		$toReturn = $toReturn."A";
		$numA--;
		$nucAdded = 1;
		} elsif($rand == 1 && $numT > 0) {
		$toReturn = $toReturn."T";
		$numT--;
		$nucAdded = 1;
		} elsif($rand == 2 && $numC > 0) {
		$toReturn = $toReturn."C";		
		$numC--;
		$nucAdded = 1;
		} elsif($rand == 3 && $numG > 0) {
		$toReturn = $toReturn."G";		
		$numG--;
		$nucAdded = 1;
		}	
	}
	#this if block replaces the T at the start of a stop codon with another codon to remove a premature stopcodon
	if (length($toReturn)%3 == 0) {
		if (substr($toReturn, $i, 3) =~ /(TAG|TAA|TGA)/i) {
		$rand = int(rand (3));
			if ($rand == 0) {
			$numA--;
			substr($toReturn, $i, 1,"A");
			} elsif ($rand == 1) {
			$numC--;
			substr($toReturn, $i, 1,"C");
			} elsif ($rand == 2) {
			$numG--;
			substr($toReturn, $i, 1,"G");
			}	
		}
	}

	

}
return $description.$toReturn.$stop."\n";
}
