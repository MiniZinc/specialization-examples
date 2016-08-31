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

include "lex_lesseq.mzn";

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