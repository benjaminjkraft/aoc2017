#!/bin/bash
# Part 1
cat $1 | \
    # put first character at end too (for wrap-around)
    sed -E 's/^(.)(.*)$/\1\2\1/g' | \
    # Replace each character with two copies of itself, newline separated
    sed 's/./&\n&/g' | \
    # Find lines with the same number twice
    grep -E '(.)\1' | \
    # Add one copy of each number
    sed 's/.$/+/' | tr -d '\n' | sed 's/$/0\n/' | bc

# Part 2
cat $1 | \
    # Split characters onto lines
    sed 's/./&\n/g' | \
    # Wrap to two columns, but remove the tabs
    column -c 16 | tr -d '\t' | \
    # Find lines with the same number twice
    grep -E '(.)\1' | \
    # Add both copies of each number
    sed 's/.$/+&+/' | tr -d '\n' | sed 's/$/0\n/' | bc
