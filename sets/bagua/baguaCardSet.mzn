% Attack on walls

int: nSpots;
set of int: SPOT = 1..nSpots; % spot set
array[SPOT] of int: damage;

enum SYMB; % property set
array[SYMB] of set of SPOT: group;

int: size;
var set of SPOT: attacks; % decision variable (set variable)

constraint forall(s in SYMB)(card(attacks intersect group[s]) <= 1);
constraint card(attacks) = size;

var int: totalDamages = sum(p in attacks)(damage[p]);
solve maximize (totalDamages); % Goal: maximize attack reward

output["Attacks: ", show(attacks), " and damages: ", show(totalDamages)]