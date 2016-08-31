int: n; % number of blocks
set of int: BLOCK = 1..n;
int: m; % number of rectangle/offsets
set of int: ROFF = 1..m;
array[ROFF,1..4] of int: d; % defns
array[BLOCK] of set of ROFF: shape;
int: h; % width of river
int: maxl; % maximum length of river

array[BLOCK] of var 0..maxl: x;
array[BLOCK] of var 0..h: y;

var 0..maxl: l; % length of river used

solve minimize l;

constraint forall(i in BLOCK)(forall(r in ROFF)
  (r in shape[i] -> 
  (x[i] + d[r,1] + d[r,3] <= l /\
   y[i] + d[r,2] + d[r,4] <= h)));

constraint forall(i,j in BLOCK where i < j)
  (forall(r1,r2 in ROFF)
 (r1 in shape[i] /\ 
  r2 in shape[j] -> 
(x[i] + d[r1,1] + d[r1,3] <= x[j] + d[r2,1]
                   \/
 x[j] + d[r2,1] + d[r2,3] <= x[i] + d[r1,1]
                   \/
 y[i] + d[r1,2] + d[r1,4] <= y[j] + d[r2,2]
                   \/
y[j] + d[r2,2] + d[r2,4] <= y[i] + d[r1,2])
   ));

output ["l = \(l);\nx = \(x);\ny = \(y)\n"];