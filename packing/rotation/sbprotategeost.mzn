% This model uses the geost global constraint but 
% runs on the orginal 'sbprotate.dzn' data. 

int: n; % number of blocks
set of int: BLOCK = 1..n;
int: m; % number of rectangle/offsets
set of int: ROFF = 1..m;
array[ROFF,1..4] of int: d; % defns
set of int: ROT = 1..4;
array[BLOCK,ROT] of set of ROFF: shape;
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
 
% extract the shape orientations into 1-d array 
array[1..n*4] of set of int: shapeorient =
   array1d([shape[i,j]| i in BLOCK, j in 1..4]);
% shape orientations without empty set
array[int] of set of int: neshapeorient =
   [shapeorient[i] | i in 1..n*4 where shapeorient[i] != {}];

% set up the "kind" constraints
array[BLOCK] of var int: kind;
array[BLOCK] of int: nemptycount =
   [ sum(j in 1..4*i)(shapeorient[j] != {}) | i in BLOCK];
array[BLOCK] of set of int: shapeind = 
   [ if i = 1 then { j | j in 1..nemptycount[i]}
        else {j | j in nemptycount[i-1]+1..nemptycount[i]}
     endif | i in BLOCK ];
constraint forall(i in BLOCK)(kind[i] in shapeind[i]);

include "geost.mzn";
constraint geost_bb(2,
         rsize,
         roff,
         neshapeorient,
         coord,
         kind,
         [ 0,0 ],
         [ l,h ]);


output ["l = \(l);\nx = \(x);\ny = \(y);\nkind = \(kind);\n"];
