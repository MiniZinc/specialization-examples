int: n;
set of int: NODE = 1..n;
array[NODE] of int: guard;
int: m; % number of edges
set of int: EDGE = 1..m;
array[EDGE,1..2] of NODE: edge;
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
       (
%      trace("table([\(path[i]),\(path[i+1])],edge)\n",
             table([path[i],path[i+1]],edge))
%      )
       ;
constraint sliding_sum(1,rest,rest,
            [guard[path[i]] = 0| i in STEP]); 

solve minimize sum(i in STEP)(guard[path[i]]);

% path = [1,10,6,11,14,15,9,9,9,9];
% step = 7;