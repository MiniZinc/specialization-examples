int: n = 7;
array[1..n] of int: x = [3,2,0,5,4,3,4];

int: len = sum(i in 1..n)(x[i]);
array[1..len] of var int: y;

constraint y = [ max(j in 1..n)(j*(i > base[j])) | i in 1..len];

%include "globals.mzn";

%constraint global_cardinality(y, [i|i in 1..n], x);
%constraint forall(i in 1..len-1)(y[i] <= y[i+1]);

array[1..n] of int: base = 
%   [sum(j in 1..i)(x[j]) | i in 1..n];
   [if i = 1 then 0 else sum(j in 1..i-1)(x[j]) endif | i in 1..n];

solve satisfy;

output["base = \(base)\ny = \(y)\n"];