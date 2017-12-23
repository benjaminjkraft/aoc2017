#!/usr/bin/perl
use v5.10;
use List::Util qw[min max];

sub parsetree {
    my %tree;
    while (my $line = <STDIN>) {
        $line =~ s/^\s*//;
        $line =~ s/\s*$//;
        my @sp = split(/,? /, $line);
        if ($line =~ /->/) {
            @{$tree{$sp[0]}{"children"}} = @sp[3 .. $#sp];
        }
        $sp[1] =~ s/^\(//;
        $sp[1] =~ s/\)$//;
        $tree{$sp[0]}{"weight"} = $sp[1];
    }
    return \%tree;
}

sub findroot {
    my %tree = %{$_[0]};

    my %nodes;
    for $key (keys %tree) {
        $nodes{$key} = 1;
    }
    for $key (keys %tree) {
        if (@{$tree{$key}{"children"}}) {
            for my $child (@{$tree{$key}{"children"}}) {
                delete $nodes{$child};
            }
        }
    }
    for $key (keys %nodes) {
        return $key;
    }
}

sub assignweights {
    my %tree = %{$_[0]};
    my $root = $_[1];
    my @bad;
    $tree{$root}{"total"} = ${tree}{$root}{"weight"};
    if (@{$tree{$root}{"children"}}) {
        my @childweights;
        for my $child (@{$tree{$root}{"children"}}) {
            push(@bad, assignweights(\%tree, $child));
            push(@childweights, $tree{$child}{"total"});
            $tree{$root}{"total"} += $tree{$child}{"total"};
        }
        if (min(@childweights) != max(@childweights)) {
            push(@bad, $root);
        }
    }
    return @bad;
}

sub balancetree {
    my %tree = %{$_[0]};
    my @bad = assignweights(@_);
    # We assume the bad thing isn't the root, because if it is, and it has 2
    # children, the solution is not unique, and casework is annoying.
    my $thebad = $bad[0];
    my $parent = $bad[1];
    my @childweights;
    my @siblingweights;
    for my $child (@{$tree{$thebad}{"children"}}) {
        push(@childweights, $tree{$child}{"total"});
    }
    for my $child (@{$tree{$parent}{"children"}}) {
        push(@siblingweights, $tree{$child}{"total"});
    }
    my $childweighttofix;
    my $desiredchildweight;
    if (min(@siblingweights) == $tree{$thebad}{"total"}) {
        $childweighttofix = min(@childweights);
        $desiredchildweight = max(@childweights);
    } else {
        $childweighttofix = max(@childweights);
        $desiredchildweight = min(@childweights);
    }
    for my $child (@{$tree{$thebad}{"children"}}) {
        if ($tree{$child}{"total"} == $childweighttofix) {
            return ($tree{$child}{"weight"}
                    + $desiredchildweight - $childweighttofix);
        }
    }


}


my @tree = parsetree;
my $root = findroot(@tree);
say $root;
say balancetree(@tree, $root);
