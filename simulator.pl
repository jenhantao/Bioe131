#! /usr/bin/perl -w
$length = @ARGV;
print "$length arguments entered\n";

#No argument run of this program should give sequence of uniform composition with length of 1 kbp
if ($length ==0 ) {
open(OUTPUT, ">simulatedSequence.fasta");
print OUTPUT generateSequence(25, 25, 25, 25, 1000,"Simulated Sequence");
close OUTPUT;
} elsif($length > 0) {
@default = {"25", "25", "25", "25", "1000"};
@params=undef;
	foreach(@ARGV){
	print "command $_\n";
		if($_ =~/^-calc/) {
		print "I should calc something\n";
		} elsif($_ =~/^-load/) {
		print "I should load something\n";
		} elsif($_ =~/^-save/) {
		print "I should save something\n";
			if (!defined(@params)) {
			print "moo\n";
			}

		}
	}
}

#this subroutine saves the statistics for one sequence into a file
#inputs required are an array containing the output of subroutine calcStats and a file to save into
sub save{
print "opening $_[1]\n";
open(PARAM, ">$_[1]");
my @stats = $_[0];
print PARAM "Composition: $stats[0] $stats[1] $stats[2] $stats[3] \n";
print PARAM "Length: $stats[4]";
close(PARAM);
}




#This subroutine returns statistics related to an input sequence in the following order: percentage of A, T, C, and G, and then length. The statistic are returned in an array that whose indices correspond to the order described above.
sub calcStats {
my $length = @_;
#if block below does basic error checking
if ($length != 1) {
die "too many arguments";
} elsif (!$_[0] =~ /[agct]/i) {
die "subroutine calc detected an illegal character in input DNA sequence";
}
my $seq = $_[0];
$seq = (uc ($seq));
chomp($seq);
$length = length ($seq);
my $numA = ($seq =~ tr/A/A/)/$length;
my $numT = ($seq =~ tr/T/T/)/$length;
my $numC = ($seq =~ tr/C/C/)/$length;
my $numG = ($seq =~ tr/G/G/)/$length;
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
} elsif (($_[0] + $_[1] + $_[2] + $_[3]) != 100) {
die "improper composition given to generateSequene subroutine";
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
return $description.$toReturn.$stop;
}
