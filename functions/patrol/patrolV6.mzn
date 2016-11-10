% Patrol Scheduling
include "globals.mzn";

enum SOLDIER;
enum SHIFT = {OFF, EVE, NIGHT};

int: nDays; % length of the period
set of int: DAY = 1..nDays;

int: o;
int: l;
int: u;

array[SOLDIER, DAY] of var SHIFT: roster;

constraint forall (d in 1..(nDays-1), s in SOLDIER) ((roster[s, d] = EVE) -> (roster[s, d+1] != NIGHT));
constraint forall (d in 1..(nDays-2), s in SOLDIER) 
   ((roster[s, d] = NIGHT) /\ (roster[s, d+1] = NIGHT) -> (roster[s, d+2] != NIGHT));

constraint forall(d in DAY)(global_cardinality_low_up([roster[s,d] | s in SOLDIER], [NIGHT, EVE], [o,l], [o,u]));
array[DAY] of var l..u: onEve;
constraint onEve = [sum (s in SOLDIER) (roster[s,d]=EVE) | d in DAY];

var int: tOnEve;
constraint tOnEve = sum(d in DAY)(onEve[d]);
solve maximize (tOnEve);

output ["Soldier "++show(s)++" on Day "++show(d)++" takes the "++show(roster[s,d])++" shift\n" ++ if s == max(SOLDIER) then "\n" else "" endif | d in DAY, s in SOLDIER]++[show(tOnEve)];