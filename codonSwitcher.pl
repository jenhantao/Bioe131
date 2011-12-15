#! /usr/bin/perl -w

%codonHash = (ttt => "f", ttc => "f", tta => "l", ttg => "l",
	      tct => "s", tcc => "s", tca => "s", tcg => "s",
	      tat => "y", tac => "y", taa => "!", tag => "!",
	      tgt => "c", tgc => "c", tga => "!", tgg => "w",
	      ctt => "l", ctc => "l", cta => "l", ctg => "l",
	      cct => "p", ccc => "p", cca => "p", ccg => "p",
	      cat => "h", cac => "h", caa => "q", cag => "q",
	      cgt => "r", cgc => "r", cga => "r", cgg => "r",
	      att => "i", atc => "i", ata => "i", atg => "m",
	      act => "t", acc => "t", aca => "t", acg => "t",
	      aat => "n", aac => "n", aaa => "k", aag => "k",
	      agt => "s", agc => "s", aga => "r", agg => "r",
	      gtt => "v", gtc => "v", gta => "v", gtg => "v",
	      gct => "a", gcc => "a", gca => "a", gcg => "a",
	      gat => "d", gac => "d", gaa => "e", gag => "e",
	      ggt => "g", ggc => "g", gga => "g", ggg => "g",
	      );


#this subroutine takes one argument, a DNA sequence given as a string
#returns one string representing a DNA sequence which should code for the same polypeptide, but distances between identical codons should be maximized
sub optimizeCodonDistance {
if (@_>1) {
	die "error: too many arguments given to optimizeCodonDistance subroutine\n";
}
my $seq = $_[0];
if(length($seq) % 3 != 0) {
	die "error: input dna sequence must be composed of complete 3 base codons\n";
}
my @seqArray = ();
my %aaLocations = (); #gives the positions at which a particular amino is located, the codon is the hash, returned value is a string of locations; 1 letter code is used; position is given as 0 indexed codon positions
my %codonLocations =(); #gives the positions at which a particular codon is located, the codon is the hash, returned value is a string of locations; position is given as 0 indexed codon positions
for (my $i=0; $i<length($seq); $i+=3) {
	my $codon = substr($seq, $i, 3);
	my $aa = $codonHash{$codon};
	if (defined($codonLocations{$codon})) {
		$codonLocations{$codon} = $codonLocations{$codon}.",".int($i/3);
	} else {
		$codonLocations{$codon} = int($i/3);
	}
	if (defined($aaLocations{$aa})) {
		$aaLocations{$aa} = $aaLocations{$aa}.",".int($i/3);
	} else {
		$aaLocations{$aa} = int($i/3);
	}
	push (@seqArray, substr($seq, $i, 3));
}
#optimize distances here

foreach my $key (keys %codonLocations) {
	my @codonIndices = split(/,/, $codonLocations{$key}); #locations of a particular codon
	my @aaIndices = split(/,/, $aaLocations{$codonHash{$key}});
	my $swapIncrement = int (@aaIndices/@codonIndices);
	for (my $i=0; $i<@aaIndices; $i+=$swapIncrement) {
		my $a = shift(@codonIndices); #the codon at position A will be substituted for another
		my $temp = $seqArray[$a];
		$seqArray[$a] = $seqArray[$aaIndices[$i]];
		$seqArray[$aaIndices[$i]] = $temp;
	} 
}
return join("",@seqArray);
}
