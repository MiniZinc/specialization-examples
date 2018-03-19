int: v;
set of int: ROW = 1..v;
int: b;
set of int: COL = 1..b;
int: r;
int: k;
int: lambda;

array[ROW,COL] of var bool: m;
%solve :: int_search([m[r,c] | r in ROW, c in COL], input_order, indomain_min, complete) satisfy;
solve satisfy;

constraint forall(i in ROW)(sum(j in COL)(m[i,j]) = r);
constraint forall(j in COL)(sum(i in ROW)(m[i,j]) = k);
constraint forall(i1, i2 in ROW where i1 < i2)
                 (sum(j in COL)
                     (m[i1,j] /\ m[i2,j]) = lambda);


output [ if fix(m[i,j]) then "1" else "0" endif ++
         if j = b then "\n" else "" endif
       | i in ROW, j in COL ];


%110111 <= 011111