enum SCHOLAR;
array[SCHOLAR] of int: reputation;
int: maxreputation = max(reputation);

int: T;
set of int: TABLE = 1..T;
int: S; % tables size
array[int,1..2] of SCHOLAR: enemies;
array[int,1..2] of SCHOLAR: friends;

array[TABLE] of var set of SCHOLAR: table;

predicate not_same_table(SCHOLAR: p1, SCHOLAR: p2) =
          forall(t in TABLE)(not ({p1,p2} subset table[t]));

% No table occupied by a a scholar all by his lonesome
% and no table occupied beyond its capacity
constraint forall(t in TABLE)(card(table[t]) != 1);
constraint forall(t in TABLE)(card(table[t]) <= S);

% Every scholar is sitting on at least 1 table
constraint forall(p in SCHOLAR)(exists(t in TABLE)(p in table[t]));

% A scholar can only sit at at most 1 table ("two different
% tables cannot seat the same scholar")
constraint forall(t1, t2 in TABLE where t1 < t2)
   (table[t1] intersect table[t2] = {});

% Enemies not on same table
constraint forall(c in index_set_1of2(enemies))
                 (not_same_table(enemies[c,1],enemies[c,2]));

% Friends on same table
constraint forall(c in index_set_1of2(friends))
                 (not(not_same_table(friends[c,1],friends[c,2])));

% Important persons (reputation 10) not on same table
constraint forall(p1,p2 in SCHOLAR where p1 < p2 /\ reputation[p1] = 10 /\ reputation[p2] = 10)
   (not_same_table(p1,p2));

% An arbitrary de-symmetrizer based on the integer label of a scholar
constraint forall(t1, t2 in TABLE where t1 < t2)
   (sum([p*(p in table[t1]) | p in SCHOLAR]) >= sum([p*(p in table[t2]) | p in SCHOLAR]));

% Primary objective: use as few tables as possible
var int: obj1;
constraint obj1 = sum(t in TABLE)(card(table[t]) != 0);

% Secondary objective: keep the sum of the reputation spread of each table small
var int: obj2;
constraint obj2 = sum(t in TABLE)
   (let {var int: minRep = min([reputation[p]*(p in table[t]) +  maxreputation*(1-(p in table[t])) | p in SCHOLAR]); 
         var int: maxRep = max([reputation[p]*(p in table[t]) | p in SCHOLAR]); } in
    if minRep = maxreputation then 0 else maxRep - minRep endif);

% Hierarchy of objectives: 
% obj1(sol1) < obj1(sol2) -> obj(sol1) < obj(sol2)
% obj1(sol1) = obj1(sol2) -> (obj2(sol1) < obj2(sol2) -> obj(sol1) < obj(sol2))

% var obj = (obj1*(obj2_range+1) + obj2);
% int: obj2_range = S * (maxreputation - minreputation) = 5 * 9 = 45; % choose 100

solve minimize (obj1*100 + obj2);

output ["Table \(t): \(table[t])\n" | t in TABLE] ++ ["Obj1: \(obj1) and Obj2: \(obj2)\n"];
