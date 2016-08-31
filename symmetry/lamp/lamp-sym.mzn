int: v;
set of int: ROW = 1..v;
int: b;
set of int: COL = 1..b;
int: r;
int: k;
int: lambda;

array[ROW,COL] of var bool: m;
solve satisfy;

constraint forall(i in ROW)(sum(j in COL)(m[i,j]) = r);
constraint forall(j in COL)(sum(i in ROW)(m[i,j]) = k);
constraint forall(i1, i2 in ROW where i1 < i2)
                 (sum(j in COL)
                     (m[i1,j] /\ m[i2,j]) = lambda);

include "lex_lesseq.mzn";
constraint forall(i in 1..v-1)
   (lex_lesseq(row(m,i),row(m,i+1)));
%       (lex_lesseq([ m[i,j] | j in COL],
%                   [ m[i+1,j] | j in COL]));
constraint forall(j in 1..b-1)
   (lex_lesseq(col(m,j),col(m,j+1)));
%       (lex_lesseq([ m[i,j] | i in ROW],
%                   [ m[i,j+1] | i in ROW]));

output [ if fix(m[i,j]) then "1" else "0" endif ++
         if j = b then "\n" else "" endif
       | i in ROW, j in COL ];