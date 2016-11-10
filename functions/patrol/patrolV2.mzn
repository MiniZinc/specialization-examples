% Patrol Scheduling
include "globals.mzn";

enum SOLDIER;
enum SHIFT = { OFF, EVE, NIGHT };

int: nDays; % length of the period 
set of int: DAY = 1..nDays;

int: o;
int: l;
int: u;

array[SOLDIER, DAY] of var SHIFT: roster;

constraint forall (d in 1..(nDays-1), s in SOLDIER) ((roster[s, d] = EVE) -> (roster[s, d+1] != NIGHT));
constraint forall (d in 1..(nDays-2), s in SOLDIER) ((roster[s, d] = NIGHT) /\ (roster[s, d+1] = NIGHT) -> (roster[s, d+2] != NIGHT));

constraint forall (d in DAY) (sum (s in SOLDIER) ((roster[s, d] = NIGHT)) = o);
array[DAY] of var l..u: onEve;
constraint onEve = [sum (s in SOLDIER) (roster[s,d]=EVE) | d in DAY];

solve maximize sum(onEve);

output ["Soldier "++show(s)++" on Day "++show(d)++" takes the "++show(roster[s,d])++" shift\n" ++ if s == max(SOLDIER) then show(onEve[d])++"\n" else "" endif | d in DAY, s in SOLDIER]++[show(sum(onEve))];