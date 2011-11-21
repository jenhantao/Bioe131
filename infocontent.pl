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
			push(@lines,$line);		
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

		}
		
	}
}
}

readStockholm($ARGV[0]);
