% ===
% "The Strongest YaoCao"
% ===

% Grow (or explore) a tree.
%
% The root node has level 1.
% We need to reach level n (the number of potions) at which
% YaoCao grows. The best YaoCao is the one with the most
% leaves-on-segments over the branch (the "branch" is the path
% through the tree, consisting of "segments")
% The potions are used "in order" so "tree height" (or "tree level")
% and "potion number" are equivalent (the potion x is applied to
% each node at level x equally)
% The choice is the selection of the segment to follow from each node.
% At each node, the potion determines the "branching factor"
% (the number of outgoing segments) as well as the number of leaves
% on each segment and the nutrient requirements on each segment.
% Along a branch (path through the tree), the total nutrient
% requirements of each segment must stay below a maximum.
% Along a branch, the total number of leaves of on the segments
% belonging to any "window" (a continuous series of segments of
% the branch, with the number of segments fixed) must stay above
% a minimum.

% ---
% Given
% ---

int: n;        % Number of potions
int: w;        % Window size
int: p;        % Min number of leaves-on-segments required in a window (actual value must be >= p)
int: capacity; % Max capacity of nutrients available for any branch/path from root node to outermost node
int: m;        % Max number of segments grown at each node (max branching factor)

set of int: POTIONS  = 1..n;
set of int: SEGMENTS = 1..m;

% Nutrients required by segment x if the node
% was expanded with potion y
% (capacity+1 if segment does not exist)

array[POTIONS,SEGMENTS] of int: nutrient;

% Number of leaves that will to grow on
% segment x if the node was expanded with potion y
% (0 if segment does not exist)

array[POTIONS,SEGMENTS] of int: leaf;

% ---
% Sought
% ---

% The branch (i.e. the path through the tree): which segment to select at
% every height "x" (equivalent to potion "x") of the tree

array[POTIONS] of var SEGMENTS: choice;

% The list of nutrients needed over the branch/path implied by "choice"

array[POTIONS] of var int: nutrient_list =
    [nutrient[i,choice[i]] | i in POTIONS];

% The list of leaves-on-segments over the branch/path implied by "choice"

array[POTIONS] of var int: leave_list =
    [leaf[i,choice[i]] | i in POTIONS];

var int: total_nutrient = sum(nutrient_list);
var int: total_leaves = sum(leave_list);

constraint assert(w<=n,"Window size must be <= than number of potions");

% Nutrients required by the full branch/path may not exceed capacity

constraint total_nutrient <= capacity;

% Number of leaves-on-segments in any window on the branch/path must be >= p

constraint forall(tail in w..n)
    (sum(i in tail-w+1..tail)(leave_list[i]) >= p);

% ---
% Solving
% ---

solve :: ssearch2 maximize total_leaves;

% search4:  finds optimum (6443 for "100 potions") in least time (seconds)
% search6:  finds optimum, a bit slower than largest+max (seconds)
% search5:  finds optimum, rather slower than smallest+max (a few minutes)
% searchTL: fix a high leaf value, then see whether it can be realized,
%           finds optimum in a few minutes
% search2:  finds optimum, rather slower than smallest+min (multiple minutes)
% search1:  does not find optimum within 15 mins
% search3:  finds worst value within 15 mins
%
% ssearch1: redundant sequential search equivalent to search 1 alone
% ssearch2: optimistic search: set the total leaves to a high value, then
%           search for a branch/path that matches (finds optimum in about a minute)

ann: search1 = int_search(leave_list, input_order, indomain_min);
ann: search2 = int_search(leave_list, input_order, indomain_max);
ann: search3 = int_search(leave_list, largest, indomain_min);
ann: search4 = int_search(leave_list, largest, indomain_max);
ann: search5 = int_search(leave_list, smallest, indomain_min);
ann: search6 = int_search(leave_list, smallest, indomain_max);

ann: searchTL = int_search([total_leaves], input_order, indomain_max);

ann: ssearch1 = seq_search([search1,searchTL]);
ann: ssearch2 = seq_search([searchTL,search1]);

% ---
% Info output
% ---

function string: braced(SEGMENTS: s, SEGMENTS: chosen, int: val) =
   if s == chosen then
      if val<10      then "  [" ++ show(val) ++ "]"
      elseif val<100 then " [" ++ show(val) ++ "]"
      else                "[" ++ show(val) ++ "]"
      endif
   else
      if val<10      then "   " ++ show(val) ++ " "
      elseif val<100 then "  " ++ show(val) ++ " "
      else                " " ++ show(val) ++ " "
      endif
   endif;

output ["% Number of potions: \(n)\n" ];
output ["% Min leaves-on-segments required in a window of size \(w): \(p)\n" ];
output ["% Max capacity of nutrients available for any branch: \(capacity)\n" ];
output ["% Nutrients needed by each of the up to \(m) segments:\n"];
output ["%   Potion " ++ show_int(3,i) ++ ": " ++
   join(",", [ braced(s,fix(choice[i]),nutrient[i,s]) | s in SEGMENTS where nutrient[i,s]<=capacity ]) ++ "\n"
   | i in POTIONS ];
output ["% Leaves grown on each of the up to \(m) segments:\n"];
output ["%   Potion " ++ show_int(3,i) ++ ": " ++
   join(",", [ braced(s,fix(choice[i]),leaf[i,s]) | s in SEGMENTS where leaf[i,s]>0]) ++ "\n"
   | i in POTIONS ];
output ["\n"];

% ---
% Solution output
% ---

output ["choice = \(choice);\ntotal_leaves = \(total_leaves);\ntotal_nutrient = \(total_nutrient);\n"];
