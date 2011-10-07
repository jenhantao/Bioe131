#! /usr/bin/perl -w
$length = @ARGV;
print "$length arguments entered\n";

#No argument run of this program should give sequence of uniform composition with length of 1 kbp
if ($length ==0) {
print generateSequence(50,25,25,0,161,"sequence")."\n";
print calc("AAaaaaaAAATTTT\n");
}


#This subroutine returns statistics related to an input sequence in the following manner
sub calc {
my $length = @_;
#if block below does basic error checking
if ($length != 1) {
die "too many arguments";
} elsif (!$_[0] =~ /[agct]/i) {
die "subroutine calc detected an illegal character in input DNA sequence";
}
my $seq = $_[0];
$seq = tr/a/a/i;
my $numA = @-;
$seq = tr/t/t/i;
$numT = @-;
return ("found $numA A's, $numT T's\n");
}

#This subroutine requires 4 arguments, which should be given in the following order: %A, %T, %C, %G, length, name
#percentage of A, T, C, G should be given as integers
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
for (my $i =1; $i <= $length; $i++) {
$nucAdded = 0;
	#every line should only have 80 characters
	if (length($toReturn)%80 ==0 ) {
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
