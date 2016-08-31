% Oath at the Peach Garden as a knapsack problem.

int: nMoves;
set of int: MOVES = 1..nMoves;
int: timeBound;
array[MOVES] of 1..20: power;
array[MOVES] of 1..10: duration;
var set of MOVES: occur;

constraint (sum(i in occur)(duration[i])) <= timeBound;

solve maximize sum(i in occur)(power[i]);

output [show(occur)];