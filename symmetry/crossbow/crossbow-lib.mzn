int: n;
set of int: N = 1..n;
array[N,N] of var bool: t; 
constraint sum(i,j in N)(t[i,j]) = n;
solve satisfy;

% no two traps on the same row
constraint forall(i in N)(sum(j in N)(t[i,j]) <= 1);
% no two traps on the same column
constraint forall(j in N)(sum(i in N)(t[i,j]) <= 1);
% no two traps on same diagonal
constraint forall(k in 1-n..n-1)
      (sum(i,j in N where i-j=k)(t[i,j])<= 1);
constraint forall(k in 2..2*n)
      (sum(i,j in N where i+j=k)(t[i,j])<= 1);

%include "rot_flip_sqr_sym.mzn";
include "symmetry.mzn";
include "lex_lesseq.mzn";

constraint rot_flip_sqr_sym(t);

output [ if fix(t[i,j]) then "T" else "." endif ++
         if j = n then "\n" else "" endif 
       | i,j in N];