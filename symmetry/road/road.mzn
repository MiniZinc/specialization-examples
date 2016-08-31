int: n;
set of int: GEN = 1..n;
set of int: ROAD = 1..n;
array[GEN,GEN] of int: coop;
array[ROAD] of var GEN: road;

include "alldifferent.mzn";
constraint alldifferent(road);

constraint road[1] < road[n];

var int: scoop = sum(i in 1..n-1) 
   (coop[road[i], road[i+1]]);
solve maximize scoop;

output["road = \(road)\nscoop = \(scoop)"];