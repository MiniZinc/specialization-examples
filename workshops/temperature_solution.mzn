int: start;
array[int] of int: readings;
int: n = length(readings);
set of int: HOUR = 1..n;
set of int: HOUR0 = 0..n;

enum CHOICE = {heat, strongly_heat, cool, strongly_cool, do_nothing};
array[CHOICE] of int: cost = [1,5,3,9,0];
array[CHOICE] of int: effect = [1,4,-2,-5,0];

array[HOUR0] of var 25..30: temp;
array[HOUR] of var CHOICE: choice;

constraint temp[0] = start;

constraint forall(h in HOUR)
                 (temp[h] = (temp[h-1] + readings[h]) div 2 + effect[choice[h]]);

solve minimize obj;

var int: obj;
constraint obj = sum(h in HOUR)(cost[choice[h]]);

output ["temp = \(temp);\nchoice = \(choice);\ncost = \(obj);\n"];


