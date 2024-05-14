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
    $_[0] =~ /^([PE]\d+)_/ ? $1 : $_[0];
}

# get reachable classes for each class
for my $start ( keys %graph ) {
    my %exp;
    my @queue;

    my $short = id($start);
    $exp{$short} = 1 if $short ne $start;

    # TODO: also include mappings to CRM from other ontologies
    push @queue, $graph{$start} if $graph{$start} ne $start;

    while ( my $name = pop @queue ) {
        my $c = id($name);
        if ( !$exp{$c} || $c == id($start) ) {
            $exp{$c} = 1;
            push @queue, $graph{$name}
              if $graph{$name} and $graph{$name} ne $name;
        }
    }

    say join( " ", $start, sort keys %exp ) if keys %exp;
}
