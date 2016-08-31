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
% calculate size of each square
include "global_cardinality.mzn";
constraint global_cardinality(size, [i | i in SQUARE], ncopy);
constraint forall(i in 1..nsq-1)(size[i] <= size[i+1]);

% squares fit in the rectangle
constraint forall(s in NSQ)(x[s] + size[s] <= width);
constraint forall(s in NSQ)(y[s] + size[s] <= height);

% non overlap
constraint forall(s1, s2 in NSQ where s1 < s2)
                 (x[s1] + size[s1] <= x[s2] \/
                  x[s2] + size[s2] <= x[s1] \/  
                  y[s1] + size[s1] <= y[s2] \/ 
                  y[s2] + size[s2] <= y[s1]);

solve minimize area;

output ["area = ",show(area), "\n"] ++
["height = ",show(height), "\n"] ++
["width = ",show(width), "\n"] ++
["x = ", show(x), "\n"] ++
["y = ", show(y), "\n"];
