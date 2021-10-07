include "globals.mzn";

enum SCHOLAR;
array[SCHOLAR] of int: reputation;
int: maxreputation = max(reputation);

int: T; % number of tables
set of int: TABLE = 1..T;
int: S; % common table size
array[int,1..2] of SCHOLAR: enemies;
array[int,1..2] of SCHOLAR: friends;

array[TABLE] of var set of SCHOLAR: table;
array[SCHOLAR] of var TABLE: seat;

predicate not_same_table(SCHOLAR: p1, SCHOLAR: p2) =
                        seat[p1] != seat[p2];

% The scholar->table "seat" mapping is dual to the table->{scholar} "table" subsetting
constraint forall(t in TABLE, p in SCHOLAR)(p in table[t] <-> seat[p] = t);

% No table occupied by a a scholar all by his lonesome
constraint forall(t in TABLE)(card(table[t]) != 1);

% Each table seats between 0 and 5 scholars
% (p.292 of the handbook)
constraint global_cardinality_low_up(seat, [t|t in TABLE], [0|t in TABLE], [S|t in TABLE]);

% Enemies not on same table
constraint forall(c in index_set_1of2(enemies))
                 (not_same_table(enemies[c,1],enemies[c,2]));

% Friends on same table
constraint forall(c in index_set_1of2(friends))
                 (not(not_same_table(friends[c,1],friends[c,2])));

% Important persons (reputation 10) not on same table
constraint forall(p1,p2 in SCHOLAR where p1 < p2 /\ reputation[p1] = 10 /\ reputation[p2] = 10)
   (not_same_table(p1,p2));

% Value symmetry breaking.
% (p.298 of the handbook)
% If seat[scholar_high] = t[i+1] then
% there is at least one scholar_low < scholar_high such that
% seat[scholar_low] = t[i]
constraint value_precede_chain([t | t in 1..T], seat);

% Primary objective: use as few tables as possible
var int: obj1;
constraint obj1 = sum(t in TABLE)(card(table[t]) != 0);

% Secondary objective: minimize the difference in reputation over all tables
var int: obj2;
constraint obj2 = sum(t in TABLE)
   (let {var int: minRep = min([reputation[p]*(seat[p] = t) +  maxreputation*(seat[p] != t) | p in SCHOLAR]); 
         var int: maxRep = max([reputation[p]*(seat[p] = t) | p in SCHOLAR]); } in
    if minRep = maxreputation then 0 else maxRep - minRep endif);

% Hierarchy of objectives: 
% obj1(sol1) < obj1(sol2) -> obj(sol1) < obj(sol2)
% obj1(sol1) = obj1(sol2) -> obj2(sol1) < obj2(sol2) -> obj(sol1) < obj(sol2)

% var obj = (obj1*(obj2_range+1) + obj2);
% int: obj2_range = S * (maxreputation - minreputation) = 5 * 9 = 45; % choose 100

solve minimize (obj1*100 + obj2);

output ["Table \(t): \(table[t])\n" | t in TABLE] ++ ["Obj1: \(obj1) and Obj2: \(obj2)\n"];

