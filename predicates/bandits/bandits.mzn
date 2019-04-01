include "globals.mzn";

int: size;
int: nPts;
int: mDist;

array[1..size,1..size] of int: cost;

array[1..nPts] of var 1..size: ptR;
array[1..nPts] of var 1..size: ptC;

% all points different
constraint let {array [1..nPts] of var 1..size*size: points = 
   [(ptR[i]-1)*size + ptC[i] | i in 1..nPts]} in
      alldifferent(points);

% diggable spots
%constraint forall(i in 1..nPts)(not((ptR[i] mod 2) = 0 /\ (ptC[i] mod 2) = 0));
constraint forall(i in 1..nPts)((ptR[i] mod 2) = 1 \/ (ptC[i] mod 2) = 1);

% all cells covered
predicate covered(var int: x, var int: y) = 
   let {var 1..nPts: i, 
      var int: dist = abs(x-ptR[i]) + abs(y-ptC[i])} in
         dist <= mDist;
constraint let {array [1..(size div 2)] of 1..size-1: 
   huts = [i*2|i in 1..(size div 2)]} in 
      forall(i,j in huts)(covered(i,j));

var int: tCost = sum(i in 1..nPts)(cost[ptR[i],ptC[i]]);
solve minimize tCost;

output["Row: \(ptR)\nCol: \(ptC)\nCost: \(tCost)"];
