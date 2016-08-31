% Parading the soldiers
int: nsoldier;
set of int: SOLDIER = 1..nsoldier;
set of int: SOLDIER0 = 0..nsoldier;
array[SOLDIER] of int: height;
int: strawheight;

int: maxr;
set of int: ROW = 1..maxr;
int: maxc;
set of int: COL = 1..maxc;

var ROW: nrow;  % size of rectangle of soldiers
var COL: ncol; 
array[ROW,COL] of var SOLDIER0: x;

% all real soldiers appear in the first nrow rows and ncol cols
%constraint forall(r in nrow+1..maxr, c in ncol+1..maxc)
%                 (x[r,c] = 0); 
 
constraint forall(r in ROW, c in COL)
                 (   (r > nrow -> x[r,c] = 0) 
                  /\ (c > ncol -> x[r,c] = 0));


% soldiers are different positions
%constraint forall(r1, r2 in ROW, c1, c2 in COL where r1 != r2 \/ c1 != c2)
%                 (x[r1,c1] = 0 \/ x[r1,c1] != x[r2,c2]);

%constraint forall(i in 1..maxr*maxc)
%                 (let {int: r1 = (i-1) div maxc + 1;
%                       int: c1 = (i-1) mod maxc + 1; } in   
%                       x[r1,c1] = 0 \/ 
%                       forall(j in i+1..maxr*maxc)
%                             (let {int: r2 = (j-1) div maxc + 1;
%                                   int: c2 = (j-1) mod maxc + 1; } in   
%                                   trace("x[\(r1),\(c1)] != x[\(r2),\(c2)]\n",
%                                   x[r1,c1] != x[r2,c2]
%                 )
%                 ));

include "alldifferent_except_0.mzn";
constraint alldifferent_except_0([x[r,c] | r in ROW, c in COL]);

% all soldiers get a position
%constraint forall(s in SOLDIER)(exists(r in ROW, c in COL)(r <= nrow /\ c <= ncol /\ x[r,c] = s));

%include "global_cardinality_low_up.mzn";
%constraint global_cardinality_low_up([x[r,c] | r in ROW, c in COL], 
%           [s | s in SOLDIER], [1 | s in SOLDIER], [1| s in SOLDIER]);

constraint sum(r in ROW, c in COL)(x[r,c] != 0) = nsoldier;

% no straw soldier has only soldiers of less or equal height in front of them
%constraint not exists(r1 in ROW, c in COL)
%                 (r1 in 1..nrow /\ c in 1..ncol /\ x[r1,c] = 0 /\ 
%                  forall(r2 in ROW)(r2 < r1 -> (x[r2,c] = 0 \/
%                                                height[x[r2,c]] <= strawheight)));


array[SOLDIER0] of int: heightx = array1d(SOLDIER0,[strawheight] ++ height);
%constraint not exists(r1 in ROW, c in COL)
%                (r1 in 1..nrow /\ c in 1..ncol /\ x[r1,c] = 0 /\ 
%                  forall(r2 in ROW)(r2 < r1 -> heightx[x[r2,c]] <= strawheight));

constraint forall(r1 in ROW, c in COL)
                 (r1 in 1..nrow /\ c in 1..ncol /\ x[r1,c] = 0 -> 
                  exists(r2 in ROW)(r2 < r1 /\ heightx[x[r2,c]] > strawheight));

% Each straw soldier has a real soldier adjacent
constraint forall(r in ROW, c in COL)
                 ((r <= nrow /\ c <= ncol /\ x[r,c] = 0) ->
                  (   if c < maxc then x[r,c+1] != 0 else false endif
                   \/ if c > 1 then x[r,c-1] != 0 else false endif
                   \/ if r < maxr then x[r+1,c] != 0 else false endif
                   \/ if r > 1 then x[r-1,c] != 0 else false endif));
                 
% Each soldier has enough strength to support the straw soldiers
%constraint forall(r in ROW, c in COL)
%                (x[r,c] > 0 -> sum(r1 in max(1,r-1)..min(maxr,r+1), c1 in max(1,c-1)..min(maxc,c+1))
%                                  (r <= nrow /\ c <= ncol /\ x[r,c] = 0) < strength[x[r,c]]);
                        
% minimize the sum of height differences in each row
%set of int: DIFF = 0..max(height);
%
%array[ROW,COL] of var DIFF: hd;
%constraint forall(r in ROW)
%                 (forall(c in 1..ncol-1)
%                        (if r > nrow \/ c > ncol then
%                            hd[r,c] = 0 
%                         else if x[r,c] = 0 then 
%                                 if x[r,c+1] = 0 then 
%                                    hd[r,c] = 0
%                                 else hd[r,c] = abs(strawheight - height[x[r,c+1]])
%                                 endif
%                              else if x[r,c+1] = 0 then
%                                      hd[r,c] = abs(height[x[r,c]] - strawheight)
%                                   else hd[r,c] = abs(height[x[r,c]] - height[x[r,c+1]])
%                                   endif
%                             endif
%                         endif)); 
%constraint forall(c in COL)(hd[nrow,c] = 0);


%array[ROW,1..maxc-1] of var DIFF: hd;
%constraint forall(r in ROW)
%                 (forall(c in 1..ncol-1)
%                        (if x[r,c] != 0 /\ x[r,c+1] != 0 
%                         then hd[r,c] = abs(height[x[r,c]] - height[x[r,c+1]]) 
%                         else hd[r,c] = 0
%                         endif));

%constraint forall(r in ROW)
%                 (forall(c in 1..ncol-1)
%                        (hd[r,c] = if x[r,c] != 0 /\ x[r,c+1] != 0 
%                                   then abs(height[x[r,c]] - height[x[r,c+1]])  
%                                   else 0
%                                   endif));

%constraint forall(r in ROW)
%                 (forall(c in 1..ncol-1)
%                        (hd[r,c] = (x[r,c] != 0 /\ x[r,c+1] != 0)*abs(heightx[x[r,c]] - heightx[x[r,c+1]])));  

%var int: obj = sum(r in ROW,c in 1..maxc-1)(hd[r,c]);
solve maximize nrow*ncol;

output [ if fix(x[r,c]) = 0 then " ." else show_int(2,height[x[r,c]]) endif ++
         if c = maxc then "\n" else " " endif | r in ROW, c in COL]
       ++ ["x = array2d(ROW,COL,\(x));\n"] 
       ++ ["nrow = \(nrow);\nncol = \(ncol);\n"]
%       ++ ["hd = \(hd);\n"] 
%       ++ ["obj = \(obj);\n"]
       ;   
         
