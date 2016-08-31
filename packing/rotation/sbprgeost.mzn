int: n; % number of blocks
set of int: BLOCK = 1..n;
int: m; % number of rectangle/offsets
set of int: ROFF = 1..m;
array[ROFF,1..4] of int: d; % defns
array[int] of set of ROFF: shape;
int: h; % width of river
int: maxl; % maximum length of river

array[BLOCK] of var 0..maxl: x;
array[BLOCK] of var 0..h: y;

var 0..maxl: l; % length of river used

solve minimize l;

% extract the offsets and sizes
array[ROFF,1..2] of int: rsize =
   array2d(ROFF, 1..2,
      [d[i,j] | i in ROFF, j in 3..4]);
array[ROFF,1..2] of int: roff =
   array2d(ROFF, 1..2,
      [d[i,j] | i in ROFF, j in 1..2]);

% pack the x and y coordinates
array[BLOCK,1..2] of var int: coord;
constraint forall(i in BLOCK)
   (coord[i,1] = x[i] /\ coord[i,2] = y[i]);

% set up the "kind" constraints
array[BLOCK] of var int: kind;
array[BLOCK] of set of int: shapeind;
constraint forall(i in BLOCK)(kind[i] in shapeind[i]);

include "geost.mzn";
constraint geost_bb(2,
         rsize,
         roff,
         shape,
         coord,
         kind,
         [ 0,0 ],
         [ l,h ]);


output ["l = \(l);\nx = \(x);\ny = \(y);\nkind = \(kind);\n"];