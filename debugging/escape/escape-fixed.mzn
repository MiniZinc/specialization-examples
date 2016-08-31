int: n;
set of int: NODE = 1..n;
array[NODE] of int: guard;
int: m; % number of edges
set of int: EDGE = 1..m;
array[EDGE,1..2] of NODE: edge;

array[1..2*m, 1..2] of NODE: uedge =
     array2d(1..2*m,1..2, [ edge[i,j]   | i in EDGE, j in 1..2 ] ++
                          [ edge[i,3-j] | i in EDGE, j in 1..2 ]);

NODE: start;
NODE: dest;
int: rest; % resting every rest junctions

int: maxstep;
set of int: STEP = 1..maxstep;
var STEP: step;
array[STEP] of var NODE: path;

include "table.mzn";
include "sliding_sum.mzn";
constraint path[1] = start;
constraint forall(i in STEP)(i >= step -> path[i] = dest);
constraint forall(i in 1..maxstep-1)
      (table([path[i],path[i+1]],uedge));
constraint sliding_sum(1,rest,rest,
            [guard[path[i]] = 0| i in STEP]); 

solve minimize sum(i in STEP)(guard[path[i]]);