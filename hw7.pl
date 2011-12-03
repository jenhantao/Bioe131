#! /usr/bin/perl -w





generateUPGMATree(\%scoreHash,\@nodes, \@heights);
#This subroutine contains the implementation of the UPGMA algorithm
#This subroutine requires 3 inputs, a hashtable containing the distance matrix (formatted according to the subroutine that parses input), an array containing all of the starting node names, and an array containing the heights of starting nodes; indexing of the heights array should be done with respect to the array containing the node names
sub generateUPGMATree {
my %scoreHash = %{$_[0]};
my @nodes = @{$_[1]};
my @heights = @{$_[2]};
while(@nodes>1) {
	my $mini = 0;
	my $minj = 1;
	my $minScore = 1000000000;
	#this nested for loop finds the minimum score
	for (my $i=0; $i<@nodes; $i++) {
		for (my $j=0; $j<@nodes; $j++) {
			if ($i != $j) {
				my $key = $nodes[$i].$nodes[$j];	
				if($scoreHash{$key} < $minScore) {
					$mini = $i;
					$minj = $j;
					$minScore = $scoreHash{$key};
				}
			} 
		}	
	}
	push(@heights, 0.5*($heights{$mini} + $heights{$minj} + $minScore)); #add the height of k
	push(@nodes, "($nodes[$mini]:".($heights[-1]-$heights[$mini]).",$nodes[$minj]:".($heights[-1]-$heights[$mini]).")"); #add k to the list of nodes; k's name is given in newick format
	#remove nodes i and j
	for(my $z=0; $z<@nodes-1; $z++) {#the last element is k
		if ($z != $mini && $z != $minj) {
			$scoreHash{$nodes[$z].$nodes[-1]} = 0.5 * ($scoreHash{$nodes[$z].$nodes[$mini]} 
								+ $scoreHash{$nodes[$z].$nodes[$minj]});
		}
	}
	splice (@nodes,$mini,1);
	splice (@nodes,$minj,1);
}
print "Given the input file, the tree in newick format is:\n$nodes[0]\n"; #there should only be one node left
# Input: a “distance matrix”, Dij
#• Let N be the set of nodes to be joined
#• Let the “height” of node i be Hi
#– Initialize Hi=0 for all the leaf nodes in N
#• While N contains >1 node:
#– Find i & j, the two closest nodes in N
#– Create a new node, k, the parent of (i,j)
#– Set Hk = .5 * (Hi + Hj + Dij)
#• Branch length k→i is (Hk-Hi) and similarly for k→j (Hk-Hj)
#– For all nodes n in N (excluding i & j):
#• Set Dkn = .5 * (Din + Djn) set disttance to k
#– Add k to N; remove i & j
}
#Reads in the input file and creates a hash table of original distances
sub readinput {
	open (FILE, $ARGV[0]) || die "Error: File does not exist\n";
	$seqnum = 0;
	@nodes = ();
	@heights = ();

	while ($line = <FILE>) {

		$seqnum = $seqnum + 1;
		chomp $line;
		@temparray = split (/\s+/, $line);
		shift @temparray;
		$length = scalar @temparray;

		#Creates an array with the name of all the initial nodes
		push (@nodes, $temparray[0]);		

		#Creats an array wit the height of all the initial nodes
		push (@heights, 0);

		#Creates temporary hash files to later be used for the distance matrix
		for ($j=0; $j<$length; $j++) {
			$tempHash{$seqnum.'_'.$j} = $temparray[$j];
		}
	}

	#Creates the hash table for the input distance matrix
	for ($i=1; $i<$seqnum; $i++) {
		for ($j=1; $j<$length; $j++) {
			$scoreHash{$tempHash{$i.'_'.0}.$tempHash{$j.'_'.0}} = $tempHash{$i.'_'.$j};
		}
	}

	print "@nodes\n";
	print "@heights\n";

	return @nodes;
	return @heights;
	return %scoreHash;
}
