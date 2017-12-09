#!/bin/sed -nf
# NOTE: this is way too slow!  It would take at least 12 hours to run
# on part 1, and thus I haven't checked if it's correct.
#
# Read everything into the buffer.
:top
N
$!b top

# Convert numbers to tallies
:starttally
s/\(^\|\n\)\(-\?|*\)0/\1\2x/g
s/\(^\|\n\)\(-\?|*\)1/\1\2x|/g
s/\(^\|\n\)\(-\?|*\)2/\1\2x||/g
s/\(^\|\n\)\(-\?|*\)3/\1\2x|||/g
s/\(^\|\n\)\(-\?|*\)4/\1\2x||||/g
s/\(^\|\n\)\(-\?|*\)5/\1\2x|||||/g
s/\(^\|\n\)\(-\?|*\)6/\1\2x||||||/g
s/\(^\|\n\)\(-\?|*\)7/\1\2x|||||||/g
s/\(^\|\n\)\(-\?|*\)8/\1\2x||||||||/g
s/\(^\|\n\)\(-\?|*\)9/\1\2x|||||||||/g
s/x//g
s/\(^\|\n\)\(-\?\)\(|*\)\([0-9]\)/\1\2\3\3\3\3\3\3\3\3\3\3\4/g
/[0-9]/ b starttally

# Place pointer
s/^\(|*\)/\1</

b walkend


# for positive line, walk to the next line
:walkpos
# add walking marker (and extra (used) tally)
s/</+<>/
:startsteppos
/|[^\n]*</ !b endsteppos  # while |.*<
/>$/ b end
# convert a | before the < to a +
s/|\([^\n]*<\)/+\1/
# move > to the next line
s/>\(\n[^\n]*\)\($\|\n\)/\1>\2/
b startsteppos
:endsteppos
s/<//
s/>/</
s/+/|/g
b walkcoda


# for negative line, walk to the next line
:walkneg
# add walking marker (and tally)
s/</<>/
:startstepneg
/|[^\n]*</ !b endstepneg  # while |.*<
/^>/ b end
# convert a | before the < to a +
s/|\([^\n]*<\)/+\1/
# move > to the previous line
s/\(^\|\n\)\([^\n]*\)>/>\1\2/
b startstepneg
:endstepneg
s/+<//
s/>/</
s/+/|/g


:walkcoda
# If any lines are -0, flip to +0
s/\(^\|\n\)-\(<\?\)\($\|\n\)/\1\2\3/
# Add a tally to the hold buffer
x
s/^/|/
x

:walkend
/-[^\n]*</ b walkneg
b walkpos

:end
x
# Add one last tally (for the jump that got us off the end)
s/^/|/
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
