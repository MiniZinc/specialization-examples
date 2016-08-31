% Attack on walls
int: nSpots;
set of int: SPOT = 1..nSpots;
array[SPOT] of int: damage;

enum SYMB;   
array[SYMB] of set of SPOT: group;

var set of SPOT: attacks; % decision variable (set variable)

constraint forall(s in SYMB)(card(attacks intersect group[s]) <= 1);

var int: totalDamages = sum(p in attacks)(damage[p]);
solve maximize (totalDamages); % Goal: maximize attack reward

output["Attacks: ", show(attacks), " and damages: ", show(totalDamages)]