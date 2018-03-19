include "alldifferent.mzn";

set of int: RANGE = 1..9;

array[RANGE, RANGE] of var RANGE: cell;

constraint cell[2,1] = 7 /\ cell[2,2] = 8 /\ cell[2,5] = 1 /\
           cell[3,5] = 2 /\ cell[3,8] = 3 /\ 
           cell[4,4] = 3 /\ cell[4,5] = 4 /\ 
           cell[5,2] = 6 /\ cell[5,5] = 5 /\ cell[5,8] = 1 /\
           cell[6,5] = 6 /\ 
           cell[7,5] = 7 /\ 
           cell[8,1] = 5 /\ cell[8,2] = 4 /\ cell[8,5] = 8 /\ 
           cell[8,6] = 6 /\ cell[8,7] = 9 /\ cell[8,8] = 7 /\
           cell[9,5] = 9;

constraint forall(i in RANGE)
    (alldifferent([cell[i,j] | j in RANGE])); 
constraint forall(j in RANGE)
    (alldifferent([cell[i,j] | i in RANGE])); 
constraint forall(s in 1..3, t in 1..3)(alldifferent(
    [cell[i+(s-1)*3,j+(t-1)*3] | i in 1..3, j in 1..3] )
);

solve satisfy;

output [show(cell[i,j]) ++ if j = 9 then "\n" else " " endif | i in RANGE, j in RANGE];