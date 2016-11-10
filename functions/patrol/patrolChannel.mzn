% Patrol Scheduling
include "globals.mzn";

enum SOLDIER;
enum SHIFT = {OFF, EVE, NIGHT};

int: nDays; % length of the period
set of int: DAY = 1..nDays;

int: o;
int: l;
int: u;

array[SHIFT, DAY] of var set of SOLDIER: rosterShift;

constraint forall(d in DAY)(card(rosterShift[NIGHT,d]) = o);
constraint forall(d in DAY)(card(rosterShift[EVE,d]) >= l);
constraint forall(d in DAY)(card(rosterShift[EVE,d]) <= u);

% every soldier has a shift everyday
constraint forall(d in DAY)(rosterShift[OFF,d] union rosterShift[EVE,d] union rosterShift[NIGHT,d] = SOLDIER);
% no soldiers can be in more than one shift
constraint forall(d in DAY)(rosterShift[OFF,d] intersect rosterShift[EVE,d] = {});
constraint forall(d in DAY)(rosterShift[OFF,d] intersect rosterShift[NIGHT,d] = {});
constraint forall(d in DAY)(rosterShift[EVE,d] intersect rosterShift[NIGHT,d] = {});

% temporal implications
constraint forall (d in 1..(nDays-1), s in SOLDIER) ((s in rosterShift[EVE, d]) -> (not(s in rosterShift[NIGHT, d+1])));
constraint forall (d in 1..(nDays-2), s in SOLDIER) 
   ((s in rosterShift[NIGHT, d]) /\ (s in rosterShift[NIGHT, d+1]) -> (not(s in rosterShift[NIGHT, d+2])));

%var int: tOnEve = sum(d in DAY)(card(rosterShift[EVE,d]));
%solve maximize (tOnEve);
% solve satisfy;

% output[show(roster)];
output ["Shift "++show(s)++" on Day "++show(d)++" takes soldiers "++show(rosterShift[s,d])++"\n" ++ if s == max(SHIFT) then "\n" else "" endif | d in DAY, s in SHIFT]++[show(tOnEve)];

array[SOLDIER, DAY] of var SHIFT: rosterSoldier;

array[DAY] of var l..u: onEve;
constraint forall(d in DAY)(global_cardinality([rosterSoldier[s,d] | s in SOLDIER], [NIGHT, EVE], [o, onEve[d]]));


% temporal implications
constraint forall (d in 1..(nDays-1), s in SOLDIER) ((rosterSoldier[s, d] = EVE) -> (rosterSoldier[s, d+1] != NIGHT));
constraint forall (d in 1..(nDays-2), s in SOLDIER) 
   ((rosterSoldier[s, d] = NIGHT) /\ (rosterSoldier[s, d+1] = NIGHT) -> (rosterSoldier[s, d+2] != NIGHT));


% constraint forall(d in DAY, so in SOLDIER, sh in SHIFT)(rosterSoldier[so,d] = sh <-> so in rosterShift[sh,d]);
constraint forall(d in DAY)
  (int_set_channel([ rosterSoldier[so,d] | so in SOLDIER ],
                   [ rosterShift[sh,d] | sh in SHIFT ])); 

var int: tOnEve = sum(d in DAY)(onEve[d]);
solve maximize (tOnEve);

% output[show(roster)];
output ["Soldier "++show(s)++" on Day "++show(d)++" takes the "++show(rosterSoldier[s,d])++" shift\n" ++ if s == max(SOLDIER) then show(onEve[d])++"\n" else "" endif | d in DAY, s in SOLDIER]++[show(tOnEve)];