USE: kernel
USE: io
USE: math
USE: math.parser
USE: namespaces
USE: sequences
IN: day15

: main ( -- )
SYMBOL: fac1
SYMBOL: fac2
SYMBOL: modulus
16807 fac1 set
48271 fac2 set
2147483647 modulus set
readln string>number
readln string>number
2dup
40000000
[
[ fac1 get * ] [ fac2 get * ] bi*
[ modulus get mod ] bi@
2dup [ 65536 mod ] bi@ =
]
replicate
0 [ [ 1 + ] when ] reduce
number>string print
number>string drop
number>string drop
5000000
[
[ [ dup 4 mod 0 = ] [ fac1 get * modulus get mod ] do until ]
[ [ dup 8 mod 0 = ] [ fac2 get * modulus get mod ] do until ]
bi*
2dup [ 65536 mod ] bi@ =
]
replicate
0 [ [ 1 + ] when ] reduce
number>string print
number>string drop
number>string drop
;
