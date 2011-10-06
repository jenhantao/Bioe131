#! /usr/bin/perl -w
$length = @ARGV;
print "$length arguments entered\n";

#No argument run of this program should give sequence of uniform composition with length of 1 kbp
if ($length ==0) {
	while(<>) {
	$rand = int(rand($_)); #if range is 100, max number that can be is 99
	print("$rand\n");	
	
	}
}


