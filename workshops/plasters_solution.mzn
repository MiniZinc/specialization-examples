
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

include "lex_lesseq.mzn";
% symmetry
constraint forall(p in 1..total-1 where t[p] = t[p+1])
                 (lex_lesseq([ u[p], x[p], y[p] ], [u[p+1], x[p+1], y[p+1] ]));
% unused symmetry
constraint forall(p in PLASTER)(u[p] = Not -> x[p] = 1 /\ y[p] = 1);

% used variables
constraint forall(ty in TYPE)
                 (used[ty] = sum(p in PLASTER where t[p] = ty)(u[p] != Not));
constraint sum(ty in TYPE)(used[ty]*dim[ty,1]*dim[ty,2]) >= total_wounds;

% dont rotate square plasters
constraint forall(p in PLASTER)(if dim[t[p],1] = dim[t[p],2] then u[p] != Wide else true endif);

include "diffn.mzn";

array[PLASTER] of var 0..maxdim: len = [ [dim[t[p],1], dim[t[p],2], 0][u[p]] | p in PLASTER ];
array[PLASTER] of var 0..maxdim: wid = [ [dim[t[p],2], dim[t[p],1], 0][u[p]] | p in PLASTER ];

constraint diffn(x,y,len,wid);
constraint forall(p in PLASTER)(x[p] + len[p] -1 <= length /\ y[p] + wid[p] -1 <= width); 


% calculate which squares are covered
array[LENGTH,WIDTH] of var bool: covered;
constraint forall(p in PLASTER)
                 (u[p] != Not ->
                 (forall(i in LENGTH, j in WIDTH)
                         ((x[p] <= i /\ x[p]+len[p] > i /\
                          y[p] <= j /\ y[p]+wid[p] > j) ->
                          (covered[i, j]))));
constraint forall(i in LENGTH, j in WIDTH)
                 (covered[i,j] -> 
                  exists(p in PLASTER)
                        (x[p] <= i /\ x[p] + len[p] > i /\
                         y[p] <= j /\ y[p] + wid[p] > j));

constraint forall(i in LENGTH, j in WIDTH)(wound[i,j] -> covered[i,j]);

var int: cost = sum(t in TYPE)(used[t] * price[t]);

%constraint used[5] >= 1;
%constraint used[2] >= 1;

solve 
%       satisfy;
%      :: int_search(reverse(used), input_order, indomain_min, complete)
      minimize cost;

output ["x = \(x);\ny = \(y);\nu = \(u);\ncost = \(cost);\n"]
%       ++ [ if fix(covered[r,c]) then "#" 
%            else " " endif 
%%            ++ if c = width then "\n" else "" endif
%          | r in LENGTH, c in WIDTH ]
%       ++ ["------\n"]
%       ++ [ if fix(wound[r,c]) then "#" 
%            else " " endif 
%            ++ if c = width then "\n" else "" endif
%          | r in LENGTH, c in WIDTH ]
%       ++ ["------\n"]
       ++ [ if wound[r,c] /\ fix(covered[r,c]) then "#" 
            elseif fix(covered[r,c]) then "." 
            else " " endif
            ++ if c = width then "\n" else "" endif
          | r in LENGTH, c in WIDTH ]
       ;

%constraint used[6] >= 1 -> exists(t in TYPE where [0, 1, 1, 0, 0, 0][t] >= 1)(number[t] - used[t] < [0, 1, 1, 0, 0, 0][t]);
%constraint used[5] >= 1 -> exists(t in TYPE where [0, 1, 1, 1, 0, 0][t] >= 1)(number[t] - used[t] < [0, 1, 1, 1, 0, 0][t]);
