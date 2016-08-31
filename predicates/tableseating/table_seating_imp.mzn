include "globals.mzn";

enum SCHOLAR;
array[SCHOLAR] of int: reputation;
int: maxreputation = max(reputation);

int: T; % number of tables
set of int: TABLE = 1..T;
int: S; % tables size
array[int,1..2] of SCHOLAR: enemies;
array[int,1..2] of SCHOLAR: friends;

array[TABLE] of var set of SCHOLAR: table;
array[SCHOLAR] of var TABLE: seat;

% No for lonely table
constraint forall(t in TABLE)(card(table[t]) != 1);

% value symmetry breaking
constraint value_precede_chain([t | t in 1..T], seat);

predicate not_same_table(SCHOLAR: p1, SCHOLAR: p2) =
                        seat[p1] != seat[p2];

constraint global_cardinality_low_up(seat, [t|t in TABLE], [0|t in TABLE], [S|t in TABLE]);

% enemies not on same table
constraint forall(c in index_set_1of2(enemies))
                 (not_same_table(enemies[c,1],enemies[c,2]));

% friends on same table
constraint forall(c in index_set_1of2(friends))
                 (not(not_same_table(friends[c,1],friends[c,2])));

% important persons (reputation 10) not on same table
constraint forall(p1,p2 in SCHOLAR where p1 < p2 /\ reputation[p1] = 10 /\ reputation[p2] = 10)
   (not_same_table(p1,p2));

% Use as few tables as possible
var int: obj1;
constraint obj1 = sum(t in TABLE)(card(table[t]) != 0);

% minimize the difference in reputation in each table
var int: obj2;
constraint obj2 = sum(t in TABLE)
   (let {var int: minRep = min([reputation[p]*(seat[p] = t) +  maxreputation*(seat[p] != t) | p in SCHOLAR]); 
         var int: maxRep = max([reputation[p]*(seat[p] = t) | p in SCHOLAR]); } in
    if minRep = maxreputation then 0 else maxRep - minRep endif);

constraint forall(t in TABLE, p in SCHOLAR)(p in table[t] <-> seat[p] = t);    

solve minimize (obj1*100 + obj2);

output ["Table \(t): \(table[t])\n" | t in TABLE] ++ ["Obj1: \(obj1) and Obj2: \(obj2)\n"];
