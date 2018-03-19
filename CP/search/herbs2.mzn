int: n = 20;

enum ELEMENTS = {Gold, Wood, Water, Fire, Earth};

array[1..n] of var ELEMENTS: herb;

array[int,1..2] of ELEMENTS: eCompat = 
  [| Water, Wood | Water, Fire | Wood, Fire | Wood, Earth | Earth, Gold  |
     Fire, Earth | Fire, Gold  | Gold, Water| Gold, Wood  | Earth, Water |];
     
     
include "table.mzn";
constraint forall(i in 1..(n - 1))(table([herb[i],herb[i+1]], eCompat));

constraint forall(i in 1..n-3)(herb[i] != herb[i+3]);

include "globals.mzn";
int: k = 4;
constraint forall(i in 1..n-k+1)(
    global_cardinality_low_up([herb[i+j-1]|j in 1..k],[Gold,Earth],[1,1],[2,2])
);
constraint herb[1] != Gold;

% constraint forall(i in 1..n-4)(herb[i] != herb[i+4]);
% constraint global_cardinality_low_up(herb,[Gold],[0],[n div 4]);

% solve::int_search(herb, input_order, indomain_min, complete) satisfy;
solve::int_search(herb, first_fail, indomain_min, complete) satisfy;
% solve::int_search(herb, largest, indomain_min, complete) satisfy;

% solve satisfy;

output[show(herb)];