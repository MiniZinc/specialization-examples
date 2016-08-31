include "globals.mzn";

int: n;
set of int: DIG = 1..n;
int: m;
set of int: COPY = 1..m;
int: l = m*n;
set of int: POS = 1..l;
array[DIG,COPY] of var POS: p;

constraint forall(d in DIG, c in 1..m-1)
      (p[d,c+1] = p[d,c] + d + 1);
constraint alldifferent([ p[d,c] 
             | d in DIG, c in COPY]);

solve satisfy;

output["\(p)"];

