% Arrange 'n' crossbow traps on an 'n' x 'n' discrete grid of squares
% so that they don't target each other. Find any acceptable solution.
% (This is exactly the n-queens problem.)
 
int: n;
 
set of int: N = 1..n;
array[N,N] of var bool: t;
constraint sum(i,j in N)(t[i,j]) = n;
solve satisfy;
 
% no two traps on the same row (constant i)
constraint forall(i in N)(sum(j in N)(t[i,j]) <= 1);
 
% no two traps on the same column (constant j)
constraint forall(j in N)(sum(i in N)(t[i,j]) <= 1);
 
% no two traps on same diagonal
% case of both i and j increasing, so i-j must be a constant k in 1-n..n-1
constraint forall(k in 1-n..n-1)
      (sum(i,j in N where i-j=k)(t[i,j])<= 1);
 
% no two traps on same diagonal
% case of i decreasing as j increases, so i+j must be a constant k in 2..2*n
constraint forall(k in 2..2*n)
      (sum(i,j in N where i+j=k)(t[i,j])<= 1);
 
output [ if fix(t[i,j]) then "T" else "." endif ++
         if j = n then "\n" else "" endif
       | i,j in N];
