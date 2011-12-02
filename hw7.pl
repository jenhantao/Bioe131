#! /usr/bin/perl -w




my %scoreHash = (one => "1", two => "2", 
                        three => "3");
my @nodes = qw(1 2 3); 
my @heights = qw(3 2 1);
splice (@nodes,2,1); #use spice to remove elements: array, index, offset (always 1 in this program)
foreach(@nodes) {
print "$_\n";
}
generateUPGMATree(\%scoreHash,\@nodes, \@heights);
#This subroutine contains the implementation of the UPGMA algorithm
#This subroutine requires 3 inputs, a hashtable containing the distance matrix (formatted according to the subroutine that parses input), an array containing all of the starting node names, and an array containing the heights of starting nodes; indexing of the heights array should be done with respect to the array containing the node names
sub generateUPGMATree {
my %scoreHash = %{$_[0]};
my @nodes = @{$_[1]};
my @heights = @{$_[2]};


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
