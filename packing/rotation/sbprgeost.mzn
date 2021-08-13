% --- Parameters ---
  
int: n; % number of blocks (also called "shapes")
set of int: BLOCK = 1..n;
   
int: m; % number of rectangle/offsets into the 'd' array
set of int: ROFF = 1..m;
array[ROFF,1..4] of int: d; % geometries of rectangles that can be used to compose rotated shapes; 2nd dimension is one of (x,y,w,h)
  
array[int] of set of ROFF: shape; % array of set of index from ROFF: shapes and their rotations
  
int: h; % width of river
int: maxl; % maximum length of river
  
% --- Decision variables ---
  
array[BLOCK] of var 0..maxl: x;
array[BLOCK] of var 0..h: y;
  
var 0..maxl: l; % length of river used
  
solve minimize l;
  
% --------------------------
  
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
         rsize,     % given: 1st dimension: rectangle index (∈ ROFF), 2nd dimension: 1 (maps to width), 2 (maps to height)
         roff,      % given: 1st dimension: rectangle index (∈ ROFF), 2nd dimension: 1 (maps to x), 2 (maps to y)
         shape,     % given: array of set of index (∈ ROFF): shapes and their rotations (a bit less than 4 * card(BLOCK) in length)
         coord,     % sought: 1st dimension: shape index (∈ BLOCK), 2nd dimension: 1 (maps to x), 2 (maps to y)
         kind,      % sought: a mapping from shape index (∈ BLOCK) to one of the allowed (rotated) shape description for that index
         [ 0,0 ],
         [ l,h ]);
  
  
output ["l = \(l);\nx = \(x);\ny = \(y);\nkind = \(kind);\n"];
