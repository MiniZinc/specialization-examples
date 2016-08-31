include "globals.mzn";

enum PIVOT;
PIVOT: first;

set of int: POS = 1..card(PIVOT);
array[PIVOT] of int: coord;

int: m;
set of int: PREC = 1..m;
array[PREC] of int: prev;
array[PREC] of int: post;

array[PIVOT] of var POS: order; % records visting order of cities
array[POS] of var PIVOT: route; % records the city visited at each step

constraint route[1] = first;
constraint alldifferent(order);
constraint inverse(order, route);
constraint forall (i in 1..m) (order[prev[i]] < order[post[i]]);

solve minimize sum(j in 1..card(PIVOT)-1)(abs(coord[route[j+1]] - coord[route[j]]));

output["Route: \(route), Total Distance: \(sum(j in 1..card(PIVOT)-1)(abs(coord[route[j+1]] - coord[route[j]])))"];