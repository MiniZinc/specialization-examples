include "globals.mzn";

int: n;
set of int: DIG = 1..n;
int: m;
set of int: COPY = 1..m;
int: l = m*n;
set of int: POS = 1..l;
set of int: DIGCOP = 1..l;
array[POS] of var DIGCOP: dc;

constraint forall(d in DIG, c in 1..m-1, p in POS)
   (dc[p] = m*(d-1) + c <-> 
       dc[p+d+1] = m*(d-1) + c + 1);
constraint alldifferent([ dc[p] | p in POS]);

solve satisfy;

output["\((dc[p]-1) div m + 1) " | p in POS];

