include "globals.mzn";

int: nSpot;
set of int: SPOT = 1..nSpot;

int: k;
set of int: CLUSTER = 1..k;

float: maxSep;
array[SPOT, SPOT] of float: dist;

array[SPOT] of var CLUSTER: shot;  % clustering decisions

constraint forall(i,j in SPOT where shot[i] = shot[j])(dist[i, j] <= maxSep); % intra-cluster

constraint value_precede_chain([i | i in CLUSTER], shot);

constraint global_cardinality_low_up_closed(shot,
  [i | i in CLUSTER], [1 | i in CLUSTER],
  [nSpot-k+1 | i in CLUSTER]);

float: maxdist = max([dist[i, j] | i, j in SPOT]); % auxiliary variable
var float :obj = min(i, j in SPOT where i < j)(if shot[i] = shot[j] then maxdist else dist[i, j] endif); % inter-cluster
solve maximize obj;

output[show(shot), ", obj = ", show(obj)];