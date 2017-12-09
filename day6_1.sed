#!/bin/sed -nf
# NOTE: this is way too slow!  It would take at least 12 hours to run
# on part 1, and thus I haven't checked if it's correct.
#
# There is only one line, which makes things easy.

# Convert numbers to tallies, and tabs to a space to save us \t messes, and put
# a space at the beginning for consistency (i.e. we will use space as the start
# of a number)
s/\t/ /g
s/^/ /

:starttally
s/\(^\| \)\(|*\)0/\1\2x/g
s/\(^\| \)\(|*\)1/\1\2x|/g
s/\(^\| \)\(|*\)2/\1\2x||/g
s/\(^\| \)\(|*\)3/\1\2x|||/g
s/\(^\| \)\(|*\)4/\1\2x||||/g
s/\(^\| \)\(|*\)5/\1\2x|||||/g
s/\(^\| \)\(|*\)6/\1\2x||||||/g
s/\(^\| \)\(|*\)7/\1\2x|||||||/g
s/\(^\| \)\(|*\)8/\1\2x||||||||/g
s/\(^\| \)\(|*\)9/\1\2x|||||||||/g
s/x//g
s/\(^\| \)\(|*\)\([0-9]\)/\1\2\2\2\2\2\2\2\2\2\2\3/g
/[0-9]/ b starttally

h

:mainloop
# Find the largest grouping
:startlargest
s/\([ a]\)|/\1A/g
s/A/a/g
# If there are multiple groups with tallies, and not all just one, keep going.
/||[^|]\+|/ b startlargest
/|[^|]\+||/ b startlargest
/|[^|]\+|/ {
    # If it's a tie, grab the first one and use that.
    s/|/+/
    s/|/a/g
    s/+/|/
}
:startconvert
s/a|/||/
t startconvert
s/|/+/g
s/a/|/g

# Redistribute those +s.
:distribute0
:distribute1
s/+ \(\(|*x \)*\)\(|*\)\( \|$\)/ \1\3x\4/
t distribute1
:distribute2
s/^\(\( |*x\)*\) \(|*\)\(\( |*\)*\) \(a*\)+/\1 \3x\4 \6/
t distribute2
s/x\( \|$\)/|\1/g
s/+/a/g
t distribute0
s/a/|/g

# There shouldn't be more +s.
/+/ {
    p
    s/^.*$/FAIL/
    p
    b
}

# Hold the new line, and check if there are dupes
H
x

# Store as a number to keep hold space smaller.
s/$/)/
:startcompress
s/||||||||||/+/g
s/|||||||||/9/
s/||||||||/8/
s/|||||||/7/
s/||||||/6/
s/|||||/5/
s/||||/4/
s/|||/3/
s/||/2/
s/|/1/
s/\(+\|^\))/\10)/
s/\([0-9]\))/)\1/
s/+/|/g
/|/ b startcompress
s/)//

/\(^\|\n\)\([^\n]*\)\n\(.*\n\)\?\2\($\|\n\)/ b end
x
p
b mainloop

:end
# Delete non-newlines, newlines to tallies, add 1 (for trailing newline)
s/[^\n]//g
s/\n/|/g

# Now convert to a number.
s/$/)/
:startprint
s/||||||||||/+/g
s/|||||||||/9/
s/||||||||/8/
s/|||||||/7/
s/||||||/6/
s/|||||/5/
s/||||/4/
s/|||/3/
s/||/2/
s/|/1/
s/\(+\|^\))/\10)/
s/\([0-9]\))/)\1/
s/+/|/g
/|/ b startprint
s/)//

# And print!
p
