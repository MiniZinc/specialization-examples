int: n; % number of squares
set of int: SQUARE = 1..n;
array[1..n+1] of int: ncopy;
int: maxl = sum(i in SQUARE)(i*ncopy[i+1]);
int: mina = sum(i in SQUARE)(i*i*ncopy[i+1]);

var n..maxl: height;
var n..maxl: width;
var mina .. n*maxl: area = height * width;

int: nsq = sum(i in SQUARE)(ncopy[i+1]);
set of int: NSQ = 1..nsq;
array[NSQ] of var 0..maxl: x;
array[NSQ] of var 0..maxl: y;
array[NSQ] of var SQUARE: size;
constraint forall(i in NSQ)(exists(j in 0..n-1)
   (let {int: sumtoj = sum(k in 1..j)(ncopy[k+1])}
      in sumtoj < i /\ i <= sumtoj + ncopy[j+2] 
         /\ size[i] = j+1));

% squares fit in the rectangle
constraint forall(s in NSQ)(x[s] + size[s] <= width);
constraint forall(s in NSQ)(y[s] + size[s] <= height);

% non overlap
%constraint forall(s1, s2 in NSQ where s1 < s2)
%                 (x[s1] + size[s1] <= x[s2] \/
%                  x[s2] + size[s2] <= x[s1] \/  
%                  y[s1] + size[s1] <= y[s2] \/ 
%                  y[s2] + size[s2] <= y[s1]);

% non overlap with global diffn
include "diffn.mzn";
constraint diffn(x,y,size,size);

% redundant cumulative constraints
include "cumulative.mzn";
constraint cumulative(x,size,size,height);
constraint cumulative(y,size,size,width);

% symmetry breaking
include "lex_greater.mzn";
constraint forall(i in SQUARE)
   (forall(j in 1..ncopy[i+1]-1)(
      let {int: base = sum(k in 0..i-1)(ncopy[k+1])} 
         in lex_greater([x[base+j],y[base+j]],[x[base+j+1],y[base+j+1]])));

% variables ordered in reverse size x[n], y[n], x[n-1], y[n-1], ..., x[1], y[1]
%array[1..2*n] of var 0..maxl: vs = [ if i mod 2 = 0 then x[n+1 - i div 2] 
%                                     else y[n+1 - i div 2] endif | i in 2..2*n+1 ];

%solve :: seq_search([
%         int_search([area,height,width], input_order, indomain_min, complete) 
         %,int_search(vs, input_order, indomain_min, complete)
%         ])
solve
      minimize area;

output ["area = ",show(area), "\n"] ++
["height = ",show(height), "\n"] ++
["width = ",show(width), "\n"] ++
["x = ", show(x), "\n"] ++
["y = ", show(y), "\n"];

%area = 340
%height = 17
%width = 20
%x = [13, 12, 9, 14, 9, 17, 17, 17, 14, 6, 16, 16, 10, 6, 6, 5, 0, 11, 10, 0, 0]
%y = [10, 10, 9, 6, 10, 14, 11, 8, 8, 9, 4, 0, 6, 5, 12, 0, 0, 11, 0, 11, 5]