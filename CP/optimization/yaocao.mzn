% ===
% "The Strongest YaoCao"
% ===

% Grow (or explore) a tree.
%
% The root node has level 1.
% We need to reach level n (the number of potions) at which
% YaoCao grows (the best YaoCao is the one with the most
% leaves-on-branches over the path)
% The potions are used "in order" so "tree level" and "potion
% number" are equivalent (the potion x is applied to each node at
% level x equally)
% The choice is the selection of the branch (segment) to
% follow from each node.
% At each node, the potion determines the branching factor
% as well as the number of leaves and the nutrient requirements
% on each branch/segment.
% Along a path through the tree, the total nutrient
% requirements of each branch over the path must stay below a
% maximum.
% Along a path through the tree, the total number of leaves of
% the branches belonging to any "window" of a given length
% (a continuous series of segments of the path) must stay above
% a minimum.

% ---
% Given
% ---

int: n;        % Number of potions
int: w;        % Window size
int: p;        % Min number of leaves-on-branches required in a window (actual value must be >= p)
int: capacity; % Max capacity of nutrients available for any path from root node to outermost node
int: m;        % Max number of segments grown at each node (max branching factor)

set of int: POTIONS  = 1..n;
set of int: SEGMENTS = 1..m;

% Nutrients required by segment/branch x if the node
% was expanded with potion y (capacity+1 if segment does not exist)

array[POTIONS,SEGMENTS] of int: nutrient;

% (Typo: Should be "leaf") Number of leaves that will to grow on
% segment/branch x if the node was expanded with potion y (0 if
% segment does not exist)

array[POTIONS,SEGMENTS] of int: leave;

% ---
% Sought
% ---

% The "path": which segment/branch to select at every level "x"
% (equivalent to potion "x") of the tree

array[POTIONS] of var SEGMENTS: choice;

% The list of nutrients needed over the path implied by "choice"

array[POTIONS] of var int: nutrient_list =
    [nutrient[i,choice[i]] | i in POTIONS];

% The list of leaves-on-branches over the path implied by "choice"

array[POTIONS] of var int: leave_list =
    [leave[i,choice[i]] | i in POTIONS];

var int: total_nutrient = sum(nutrient_list);
var int: total_leaves = sum(leave_list);

constraint assert(w<=n,"Window size must be <= than number of potions");

% Nutrients required by the full path may not exceed capacity

constraint total_nutrient <= capacity;

% Number of leaves-on-branches in any window on the path must be >= p

constraint forall(tail in w..n)
    (sum(i in tail-w+1..tail)(leave_list[i]) >= p);

% ---
% Solving
% ---

solve :: ssearch2 maximize total_leaves;

ann: search1 = int_search(leave_list, input_order, indomain_min, complete);
ann: search2 = int_search(leave_list, input_order, indomain_max, complete);
ann: search3 = int_search(leave_list, largest, indomain_min, complete);
ann: search4 = int_search(leave_list, largest, indomain_max, complete);
ann: search5 = int_search(leave_list, smallest, indomain_min, complete);
ann: search6 = int_search(leave_list, smallest, indomain_max, complete);

ann: ssearch1 = seq_search([search1,
    int_search([total_leaves], input_order, indomain_max, complete) ]);
ann: ssearch2 = seq_search([
    int_search([total_leaves], input_order, indomain_max, complete),
    search1 ]);

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
output ["% Min leaves-on-branches required in a window of size \(w): \(p)\n" ];
output ["% Max capacity of nutrients available for any path: \(capacity)\n" ];
output ["% Nutrients needed by each of the up to \(m) segments:\n"];
output ["%   Potion " ++ show_int(3,i) ++ ": " ++
   join(",", [ braced(s,fix(choice[i]),nutrient[i,s]) | s in SEGMENTS where nutrient[i,s]<=capacity ]) ++ "\n"
   | i in POTIONS ];
output ["% Leaves grown on each of the up to \(m) segments:\n"];
output ["%   Potion " ++ show_int(3,i) ++ ": " ++
   join(",", [ braced(s,fix(choice[i]),leave[i,s]) | s in SEGMENTS where leave[i,s]>0]) ++ "\n"
   | i in POTIONS ];
output ["\n"];

% ---
% Solution output
% ---

output ["choice = \(choice);\ntotal_leaves = \(total_leaves);\ntotal_nutrient = \(total_nutrient);\n"];
