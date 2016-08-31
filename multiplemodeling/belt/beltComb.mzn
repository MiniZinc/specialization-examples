include "globals.mzn";

int: n;
set of int: DIG = 1..n;
int: m;
set of int: COPY = 1..m;
int: l = m*n;
set of int: POS = 1..l;
array[DIG,COPY] of var POS: p;
set of int: DIGCOP = 1..l;
array[POS] of var DIGCOP: dc;

constraint forall(d in DIG, c in 1..m-1)
      (p[d,c+1] = p[d,c] + d + 1);
constraint inverse(dc, [p[d,c]|d in DIG, c in COPY]);

solve satisfy;

output["\((dc[p]-1) div m + 1) " | p in POS];
