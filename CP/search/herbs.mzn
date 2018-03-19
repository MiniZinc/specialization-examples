int: r = 3;
int: c = 2;

%int: r = 10;
%int: c = 10;

enum ELEMENTS = {Metal, Wood, Water, Fire, Earth};

array[1..r,1..c] of var ELEMENTS: herb;

array[int,1..2] of ELEMENTS: compat = 
  [| Water, Wood | Water, Fire | Wood, Fire  | Wood, Earth | Earth, Metal |
     Fire, Earth | Fire, Metal | Metal, Water| Metal, Wood | Earth, Water |];
     
     
include "table.mzn";
constraint forall(i in 1..r,j in 1..c-1)(table([herb[i,j],herb[i,j+1]], compat));

include "global_cardinality_low_up.mzn";
constraint forall(j in 1..c)(
    global_cardinality_low_up([herb[i,j]|i in 1..r], [Metal,Earth], [1,1], [2,2])) :: domain;
    
constraint herb[1,1] != Metal;

% solve satisfy;

solve::int_search(array1d(herb), input_order, indomain_min, complete) satisfy;
% solve::int_search(array1d(herb), smallest, indomain_min, complete) satisfy;
% solve::int_search(array1d(herb), first_fail, indomain_min, complete) satisfy;
% solve::int_search(array1d(herb), largest, indomain_min, complete) satisfy;
% solve::int_search(array1d(herb), largest, indomain_max, complete) satisfy;

% solve::int_search(array1d(herb), input_order, indomain_min, complete) satisfy;
% solve::int_search(array1d(herb), input_order, indomain_max, complete) satisfy;
% solve::int_search(array1d(herb), input_order, indomain_median, complete) satisfy;
% solve::int_search(array1d(herb), input_order, indomain_random, complete) satisfy;


output[if j < c then 
          show(herb[i,j])++"\t" 
       else 
          show(herb[i,j])++"\n" endif 
      | i in 1..r, j in 1..c]; 