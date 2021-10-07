% Arrange 'n' crossbow traps on an 'n' x 'n' discrete grid of squares
% so that they don't target each other. Find a solution that is
% "canonical", in this case, that is "lexicographically less or equal"
% than any other solution in the same "symmetry class".
 
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
 
% 't' is a solution if it is a least element in its symmetry class:
%
% 't' must be "lexicographically less or equal" than any 's' that can be
% obtained from 't' via one of eight (seven, if one does not consider the
% 'identical' transformation, as we do here) geometrical transformations.
% Any composition of two of those eight geometrical transformations
% is also one of those eight geometrical transformations (technically,
% the geometrical transformations form a 'transformation group'), so
% applying one a single transformation indeed generates all elements of
% the symmetry class (which is an equivalence class under the relation
% 'x can be obtained from y by one of eight geometrical transformations').
 
include "lex_lesseq.mzn"; % as provided by the library
 
% solution lex less than r90 version
constraint let { array[N,N] of var bool: s; } in
    forall(i,j in N)(s[i,j] = t[j,n+1-i]) /\
    lex_lesseq(array1d(t), array1d(s));
 
% solution lex less than r180 version
constraint let { array[N,N] of var bool: s; } in
    forall(i,j in N)(s[i,j] = t[n+1-i,n+1-j]) /\
    lex_lesseq(array1d(t), array1d(s));
 
% solution lex less than 270 version
constraint let { array[N,N] of var bool: s; } in
    forall(i,j in N)(s[i,j] = t[n+1-j,i]) /\
    lex_lesseq(array1d(t), array1d(s));
 
% solution lex less than x flip version
constraint let { array[N,N] of var bool: s; } in
    forall(i,j in N)(s[i,j] = t[n+1-i,j]) /\
    lex_lesseq(array1d(t), array1d(s));
 
% solution lex less than y flip version
constraint let { array[N,N] of var bool: s; } in
    forall(i,j in N)(s[i,j] = t[i,n+1-j]) /\
    lex_lesseq(array1d(t), array1d(s));
 
% solution lex less than d2 flip version
constraint let { array[N,N] of var bool: s; } in
    forall(i,j in N)(s[i,j] = t[n+1-j,n+1-i]) /\
    lex_lesseq(array1d(t), array1d(s));
 
% solution lex less than d1 flip version
constraint let { array[N,N] of var bool: s; } in
    forall(i,j in N)(s[i,j] = t[j,i]) /\
    lex_lesseq(array1d(t), array1d(s));
 
 
 
output [ if fix(t[i,j]) then "T" else "." endif ++
         if j = n then "\n" else "" endif
       | i,j in N];
