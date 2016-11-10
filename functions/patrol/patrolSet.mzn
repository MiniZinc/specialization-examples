% Patrol Scheduling

enum SOLDIER;
enum SHIFT = {OFF, EVE, NIGHT};

int: nDays; % length of the period
set of int: DAY = 1..nDays;

int: o;
int: l;
int: u;

array[SHIFT, DAY] of var set of SOLDIER: roster;

constraint forall(d in DAY)(card(roster[NIGHT,d]) = o);
constraint forall(d in DAY)(card(roster[EVE,d]) >= l);
constraint forall(d in DAY)(card(roster[EVE,d]) <= u);

% every soldier has a shift everyday
constraint forall(d in DAY)(roster[OFF,d] union roster[EVE,d] union roster[NIGHT,d] = SOLDIER);
% no soldiers can be in more than one shift
constraint forall(d in DAY)(roster[OFF,d] intersect roster[EVE,d] = {});
constraint forall(d in DAY)(roster[OFF,d] intersect roster[NIGHT,d] = {});
constraint forall(d in DAY)(roster[EVE,d] intersect roster[NIGHT,d] = {});

% temporal implications
constraint forall (d in 1..(nDays-1), s in SOLDIER) ((s in roster[EVE, d]) -> (not(s in roster[NIGHT, d+1])));
constraint forall (d in 1..(nDays-2), s in SOLDIER) 
   ((s in roster[NIGHT, d]) /\ (s in roster[NIGHT, d+1]) -> (not(s in roster[NIGHT, d+2])));

var int: tOnEve = sum(d in DAY)(card(roster[EVE,d]));
solve maximize (tOnEve);
% solve satisfy;

% output[show(roster)];
output ["Shift "++show(s)++" on Day "++show(d)++" takes soldiers "++show(roster[s,d])++"\n" ++ if s == max(SHIFT) then "\n" else "" endif | d in DAY, s in SHIFT]++[show(tOnEve)];