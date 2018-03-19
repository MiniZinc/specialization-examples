int: n; % number of potions
set of int: POTIONS = 1..n;
int: w; % window size
int: p; % num of leaves in each window
int: capacity; % capacity of nutrients
int: m; % max number of grown segments
set of int: SEGMENTS = 1..m;

array[POTIONS,SEGMENTS] of int: nutrient;   % nutrient required
array[POTIONS,SEGMENTS] of int: leave; % num of leaves to grow

array[POTIONS] of var SEGMENTS: choice; %Choice of segment for each potion
array[POTIONS] of var int: nutrient_list = 
    [nutrient[i,choice[i]] | i in POTIONS];
array[POTIONS] of var int: leave_list = 
    [leave[i,choice[i]] | i in POTIONS];

var int: total_nutrient = sum(nutrient_list);
var int: total_leaves = sum(leave_list);

constraint assert(n>=w,"Window Size larger than # of steps");

%Capacity
constraint total_nutrient <= capacity;
%In each window, leave numbers should be larger than p
constraint forall(tail in w..n)
    (sum(i in tail-w+1..tail)(leave_list[i]) >= p);

solve :: ssearch2 maximize total_leaves;

ann: search1 = int_search(leave_list, input_order, indomain_min, complete);
ann: search2 = int_search(leave_list, input_order, indomain_max, complete);
ann: search3 = int_search(leave_list, largest, indomain_min, complete);
ann: search4 = int_search(leave_list, largest, indomain_max, complete);
ann: search5 = int_search(leave_list, smallest, indomain_min, complete);
ann: search6 = int_search(leave_list, smallest, indomain_max, complete);

ann: ssearch1 = seq_search([search1,
    int_search([total_leaves], input_order, indomain_max, complete) ]);
ann: ssearch2 = seq_search([
    int_search([total_leaves], input_order, indomain_max, complete),
    search1 ]);

output ["choice = ",show(choice),";\n","total_leaves = ",show(total_leaves),";\n","total_nutrient = ", show(total_nutrient)];