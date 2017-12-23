#!/bin/sed -nf

# HOLD SPACE:
# a||||| b------ c d| (meaning a=5, b=-6, c=0, d=1)

G
# Swap lines (hold first) because that's how my brain works, and add the
# special MAX register
s/^\([^\n]*\)\n\([^\n]*\)$/\2\n\1/
1 s/^/MAX /

# Convert dec to inc
s/dec -/inc /
s/dec /inc -/

# Create any new registers we need
/ \([a-z]*\)[^a-z].*\n\1 inc/ ! {
    s/\n\([a-z]*\) /\1 &/
}
/ \([a-z]*\)[^a-z].*if \1 / ! {
    s/\n.* if \([a-z]*\) /\1 &/
}

:starttally
s/\( -\?|*\)0/\1)/g
s/\( -\?|*\)1/\1)|/g
s/\( -\?|*\)2/\1)||/g
s/\( -\?|*\)3/\1)|||/g
s/\( -\?|*\)4/\1)||||/g
s/\( -\?|*\)5/\1)|||||/g
s/\( -\?|*\)6/\1)||||||/g
s/\( -\?|*\)7/\1)|||||||/g
s/\( -\?|*\)8/\1)||||||||/g
s/\( -\?|*\)9/\1)|||||||||/g
s/)//g
s/\( -\?\)\(|*\)\([0-9]\)/\1\2\2\2\2\2\2\2\2\2\2\3/g
/[0-9]/ b starttally
s/-|/-/g
:negatives
s/-|/--/g
t negatives

/==/ {
    / \([a-z]*\)\([-|]*\) .*if \1 == \2$/ b true
    b false
}
/!=/ {
    / \([a-z]*\)\([-|]*\) .*if \1 != \2$/ b false
    b true
}

/<=/ {
    # Register positive, compared to positive: if the latter has more
    / \([a-z]*\)\(|\+\) .*if \1 <= \2/ b true
    / \([a-z]*\)\(|\+\)|* .*if \1 <= \2$/ b false
    # Register negative, compared to negative: if the former has more
    / \([a-z]*\)\(-\+\)-* .*if \1 <= \2$/ b true
    / \([a-z]*\)\(-\+\) .*if \1 <= \2/ b false
    # Register positive, compared to nonpositive: false
    / \([a-z]*\)\(|\+\) .*if \1 <= -*$/ b false
    # Register negative, compared to nonnegative: true
    / \([a-z]*\)\(-\+\) .*if \1 <= |*$/ b true
    # Register zero, compared to nonnegative: true
    / \([a-z]*\) .*if \1 <= |*$/ b true
    # Register zero, compared to negative: false
    / \([a-z]*\) .*if \1 <= -\+$/ b false
    b fail
}
/</ {
    # Register positive, compared to positive: if the latter has more
    / \([a-z]*\)\(|\+\) .*if \1 < \2|/ b true
    / \([a-z]*\)\(|\+\)|* .*if \1 < \2$/ b false
    # Register negative, compared to negative: if the former has more
    / \([a-z]*\)\(-\+\)-\+ .*if \1 < \2$/ b true
    / \([a-z]*\)\(-\+\) .*if \1 < \2/ b false
    # Register positive, compared to nonpositive: false
    / \([a-z]*\)\(|\+\) .*if \1 < -*$/ b false
    # Register negative, compared to nonnegative: true
    / \([a-z]*\)\(-\+\) .*if \1 < |*$/ b true
    # Register zero, compared to positive: true
    / \([a-z]*\) .*if \1 < |\+$/ b true
    # Register zero, compared to nonpositive: false
    / \([a-z]*\) .*if \1 < -*$/ b false
    b fail
}

/>=/ {
    # Register negative, compared to negative: if the latter has more
    / \([a-z]*\)\(-\+\) .*if \1 >= \2/ b true
    / \([a-z]*\)\(-\+\)-* .*if \1 >= \2$/ b false
    # Register positive, compared to positive: if the former has more
    / \([a-z]*\)\(|\+\)|* .*if \1 >= \2$/ b true
    / \([a-z]*\)\(|\+\) .*if \1 >= \2/ b false
    # Register negative, compared to nonnegative: false
    / \([a-z]*\)\(-\+\) .*if \1 >= |*$/ b false
    # Register positive, compared to nonpositive: true
    / \([a-z]*\)\(|\+\) .*if \1 >= -*$/ b true
    # Register zero, compared to nonpositive: true
    / \([a-z]*\) .*if \1 >= -*$/ b true
    # Register zero, compared to positive: false
    / \([a-z]*\) .*if \1 >= |\+$/ b false
    b fail
}
/>/ {
    # Register negative, compared to negative: if the latter has more
    / \([a-z]*\)\(-\+\) .*if \1 > \2-/ b true
    / \([a-z]*\)\(-\+\)-* .*if \1 > \2$/ b false
    # Register positive, compared to positive: if the former has more
    / \([a-z]*\)\(|\+\)|\+ .*if \1 > \2$/ b true
    / \([a-z]*\)\(|\+\) .*if \1 > \2/ b false
    # Register negative, compared to nonnegative: false
    / \([a-z]*\)\(-\+\) .*if \1 > |*$/ b false
    # Register positive, compared to nonpositive: true
    / \([a-z]*\)\(|\+\) .*if \1 > -*$/ b true
    # Register zero, compared to negative: true
    / \([a-z]*\) .*if \1 > -\+$/ b true
    # Register zero, compared to nonnegative: false
    / \([a-z]*\) .*if \1 > |*$/ b false
    b fail
}

:fail
s/$/ ***FAIL/
p
q

:true
s/ \([a-z]*\)\([-+_| ]\+.*\)\n\1 inc \([-|]*\) if .*$/ \1\3\2/

# Update max; there can be at most one register larger than it
s/MAX\(|*\)\( .*[a-z]\)\(\1|\+\) /MAX\3\2\3 /

:false
s/\n.*$//
s/+/|/g
s/_/-/g

:cleanup
s/-|\||-//
t cleanup

l
h

# If at end, print.
$ {
    # Remove MAX; we'll deal with it later
    s/MAX|* / /
    s/[a-z]//g
    /|/ {
        # We have a positive number.
        s/-//g
        :posmax
        s/ \+/ /g
        s/ \(|\+\) \1|/ \1|/
        s/|\(|\+\) \1 /|\1 /
        s/ \(|\+\) \1 / \1 /
        /| |/ b posmax
    }

    /|/ ! {
        # We have a negative number.
        :negmax
        s/ \+/ /g
        s/ \(-*\) \1-* / \1 /
        s/ -*\(-*\) \1 / \1 /
        /- -/ b negmax
        s/-/|/g
        s/^/-/
    }

    s/ //g

    # Now convert to a number and print.
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
    p

    # Grab MAX and do the same with it.
    x
    # And print!
    s/ .*//
    s/MAX//
    s/$/)/
    :startprint2
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
    /|/ b startprint2
    s/)//
    p
}
