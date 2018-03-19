int: n; % number of square sizes
set of int: SQUARE = 1..n;
array[SQUARE] of int: ncopy;
int: maxl = sum(i in SQUARE)(i*ncopy[i]);
int: mina = sum(i in SQUARE)(i*i*ncopy[i]);

var n..maxl: height;
var n..maxl: width;
var mina .. n*maxl: area = height * width;

int: nsq = sum(i in SQUARE)(ncopy[i]);
set of int: NSQ = 1..nsq;
array[NSQ] of var 0..maxl: x;
array[NSQ] of var 0..maxl: y;

array[NSQ] of var SQUARE: size;
include "global_cardinality.mzn";
constraint global_cardinality(size, [i | i in SQUARE], ncopy);
constraint forall(i in 1..nsq-1)(size[i] <= size[i+1]);
% calculate size of each square 
%array[NSQ] of SQUARE: size = [ max(j in SQUARE)(j*(i > base[j])) | i in NSQ];

% squares fit in the rectangle
constraint forall(s in NSQ)(x[s] + size[s] <= width);
constraint forall(s in NSQ)(y[s] + size[s] <= height);

% non overlap with global diffn
include "diffn.mzn";
constraint diffn(x,y,size,size);

% redundant cumulative constraints
include "cumulative.mzn";
constraint cumulative(x, size, size, height);
constraint cumulative(y, size, size, width);

% symmetry breaking
array[SQUARE] of int: base = 
   [if i = 1 then 0 else sum(j in 1..i-1)(ncopy[j]) endif | 
      i in SQUARE];
include "lex_greater.mzn";
constraint forall(i in SQUARE)
   (forall(j in 1..ncopy[i]-1)(
      lex_greater([x[base[i]+j],y[base[i]+j]],
         [x[base[i]+j+1],y[base[i]+j+1]])));


solve minimize area;

output ["area = ",show(area), "\n"] ++
["height = ",show(height), "\n"] ++
["width = ",show(width), "\n"] ++
%  ["base = ",show(base), "\n"] ++
%  ["size = ",show(size), "\n"] ++
["x = ", show(x), "\n"] ++
["y = ", show(y), "\n"];
