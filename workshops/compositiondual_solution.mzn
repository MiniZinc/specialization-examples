% composition problem
int: n;
set of int: NOTE = 1..n;
set of int: POSN = 1..n;
set of int: DIFF = 1..n-1;
set of int: PDIFF = 1..n-1;

array[NOTE] of var POSN: posn;
array[POSN] of var NOTE: order;
array[PDIFF] of var DIFF: diffs;
array[DIFF] of var PDIFF: dposn;

include "inverse.mzn";
constraint inverse(posn,order);

constraint forall(i in DIFF)(diffs[i] = abs(order[i] - order[i+1]));

constraint inverse(diffs,dposn);

constraint abs(posn[1] - posn[n]) = 1;
constraint dposn[n-1] = min(posn[1],posn[n]);

solve satisfy;

output ["order = ",show(order),";\n"]
++ ["diffs = ",show(diffs),";\n"]
++ ["posn  = ",show(posn),";\n"]
++ ["dposn = ",show(dposn),";\n"];

