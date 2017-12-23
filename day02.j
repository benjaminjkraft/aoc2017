input =: ...
NB. sum of (max - min) of each row
+/(>./-<./)"1 input
NB. sum of the following: max of the 2x2 array consisting of (row[i] mod row[j] == 0) * (row[j] / row[i]) over each row.
+/]>./^:2@((0=|/)*%~/)~"1 input
