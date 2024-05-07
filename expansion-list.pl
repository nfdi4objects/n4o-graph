#!/usr/bin/env perl
use v5.20;

# read directed acyclic graph
my %graph;
while (<>) {
    chomp;
    my ( $from, $to ) = split /\t/;
    $graph{$from} = $to;
}

sub id {
    ( split "_", $_[0] )[0];
}

say "E1_CRM_Entity E1";

# get reachable classes for each class
for my $start ( keys %graph ) {
    my %exp;
    $exp{ id($start) } = 1;
    my @queue = $graph{$start};    # may have same ID (rename)
    while ( my $name = pop @queue ) {
        my $c = id($name);
        if ( !$exp{$c} || $c == id($start) ) {
            $exp{$c} = 1;
            push @queue, $graph{$name} if $graph{$name};
        }
    }
    say join( " ", $start, sort keys %exp );
}
