% Oath at the Peach Garden as a knapsack problem.

int: nMoves;
set of int: MOVES = 1..nMoves;
int: timeBound;
array[MOVES] of 1..20: power;
array[MOVES] of 1..10: duration;
array[MOVES] of var bool: occur;

constraint (sum(i in MOVES)(duration[i] * bool2int(occur[i]))) <= timeBound;

solve maximize sum(i in MOVES)(power[i] * bool2int(occur[i]));

output [show(occur)];