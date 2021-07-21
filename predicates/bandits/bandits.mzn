include "globals.mzn";

int: size;
set of int: SIZE = 1..size;

int: nPts;
set of int: POINT = 1..nPts;

int: mDist;

array[SIZE,SIZE] of int: cost;

array[POINT] of var SIZE: ptR;
array[POINT] of var SIZE: ptC;

% all tunnel exits must be different
constraint let { array [POINT] of var 1..size*size: points = 
   [(ptR[i]-1)*size + ptC[i] | i in POINT] } in
      alldifferent(points);

% all tunnel exits must be diggable
%constraint forall(i in POINT)(not((ptR[i] mod 2) = 0 /\ (ptC[i] mod 2) = 0));
constraint forall(i in POINT)((ptR[i] mod 2) = 1 \/ (ptC[i] mod 2) = 1);

% a hut at (x,y) must be within mDist Manhattan Distance of some tunnel exit
predicate covered(var int: x, var int: y) = 
   let {var POINT: i, 
        var int: dist = abs(x-ptR[i]) + abs(y-ptC[i])} in
         dist <= mDist;

% huts is a 1-D array of hut coords along one axis
constraint let {array [1..(size div 2)] of 1..size-1: huts =
   [i*2|i in 1..(size div 2)]} in 
      forall(x,y in huts)(covered(x,y));

% Break symmetry by demanding that tunnel exit points have a canonical ordering
constraint forall(i in 1..nPts-1)(ptR[i]*size+ptC[i] < ptR[i+1]*size+ptC[i+1]);

var int: tCost = sum(i in POINT)(cost[ptR[i],ptC[i]]);
solve minimize tCost;

output["Row: \(ptR)\nCol: \(ptC)\nCost: \(tCost)"];
