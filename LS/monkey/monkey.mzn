enum MONKEY;
array[MONKEY,MONKEY] of int: coop;
int: n = card(MONKEY);
set of int: POS = 1..n;
array[POS] of var MONKEY: monkey;
include "alldifferent.mzn";
constraint alldifferent(monkey);
solve maximize sum(i in 1..n-1)                      
         (coop[monkey[i],monkey[i+1]]);
