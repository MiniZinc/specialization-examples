array[1..15] of var 0..1: b;
array[1..4] of var 1..100: x;
array[1..19] of var int: vlist = 
    [b[i] | i in 1..15] ++ [x[i]| i in 1..4];

include "alldifferent.mzn";
constraint sum(b) >= 1;
constraint alldifferent(x) /\ x[1] = x[2];

ann: search1 = int_search(vlist, first_fail, indomain_min, complete);
ann: search2 = int_search(vlist, dom_w_deg, indomain_min, complete);
                            
solve::search1 satisfy;