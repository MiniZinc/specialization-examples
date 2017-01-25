
int: length; % length of Huang Gai's back
set of int: LENGTH = 1..length;
int: width; % width of Huang Gai's back
set of int: WIDTH = 1..width;

array[LENGTH,WIDTH] of bool: wound; % wound positions
int: total_wounds = sum(array1d(wound));

int: ntypes;  % number of types of plaster
set of int: TYPE = 1..ntypes;
array[TYPE] of int: number;          % number of plaster available
array[TYPE,1..2] of int: dim;        % dimensions of plaster
int: maxdim = max(array1d(dim));
array[TYPE] of int: price;

int: total = sum(number);
set of int: PLASTER = 1..total;
array[TYPE] of int: psum = [ sum(i in 1..t-1)(number[i]) | t in TYPE ];
array[PLASTER] of TYPE: t = [max(t in TYPE)(t*(p > psum[t])) | p in PLASTER];
array[PLASTER] of var LENGTH:  x;
array[PLASTER] of var WIDTH:   y;
enum USAGE = { Long, Wide, Not };
array[PLASTER] of var USAGE:   u;
array[TYPE] of var 0..max(number): used;

var TYPE: dominated;

include "lex_lesseq.mzn";
% symmetry
constraint forall(p in 1..total-1 where t[p] = t[p+1])
                 (lex_lesseq([ u[p], x[p], y[p] ], [u[p+1], x[p+1], y[p+1] ]));
% unused symmetry
constraint forall(p in PLASTER)(u[p] = Not -> x[p] = 1 /\ y[p] = 1);

% used variables
constraint forall(ty in TYPE)
                 (used[ty] = sum(p in PLASTER where t[p] = ty)(u[p] != Not));

constraint sum(ty in TYPE)(used[ty]*dim[ty,1]*dim[ty,2]) = dim[dominated,1] * dim[dominated,2];

% dont rotate square plasters
constraint forall(p in PLASTER)(if dim[t[p],1] = dim[t[p],2] then u[p] != Wide else true endif);

include "diffn.mzn";

array[PLASTER] of var 0..maxdim: len = [ [dim[t[p],1], dim[t[p],2], 0][u[p]] | p in PLASTER ];
array[PLASTER] of var 0..maxdim: wid = [ [dim[t[p],2], dim[t[p],1], 0][u[p]] | p in PLASTER ];

constraint diffn(x,y,len,wid);

constraint forall(p in PLASTER)(x[p] + len[p] -1 <= dim[dominated,1] /\ y[p] + wid[p] -1 <= dim[dominated,2]); 

var int: cost = sum(t in TYPE)(used[t] * price[t]);

constraint cost < price[dominated];

solve satisfy;

output %["x = \(x);\ny = \(y);\nu = \(u);\ncost = \(cost);\nused = \(used);\ndominated = \(dominated);\n"]
       %++
       ["constraint used[\(dominated)] >= 1 -> " ++
        "exists(t in TYPE where \(used)[t] >= 1)(number[t] - used[t] < \(used)[t]);"]
       ;
