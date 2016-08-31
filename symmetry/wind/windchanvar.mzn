% matching problem

include "globals.mzn"; 

int: n;
set of int: VERTEX = 1..n;
set of int: RANK = 1..n;
int: m; 
set of int: POLYGON = 1..m;

enum TRIBUTE;
array[TRIBUTE] of RANK: rank = [(i-1) div m + 1 | i in 1..n*m];
 
array[POLYGON, VERTEX] of var TRIBUTE: tribute; 
array[1..m-1, VERTEX] of var 0..n-1: ncoins;
 

constraint all_different (array1d(tribute));

constraint forall (i in 1..m-1)(
   forall (j in VERTEX)(
      ncoins[i,j] = 
         abs(rank[tribute[i,j]] - 
             rank[tribute[i+1,j]])
   )
);

var int: tcoins = sum(i in 1..m-1, j in VERTEX)       
               (ncoins[i,j]); 
solve maximize tcoins;

output  [ "tributes: \n"] ++ [( if j > n then "\n" else show(tribute[i, j]) ++ "\t" endif )
        | i in 1..m, j in 1..(n + 1)
        ] ++ 
        [ "coins: \n"] ++ [( if j > n then "\n" else show(ncoins[i, j]) ++ "\t" endif )
        | i in 1..m-1, j in 1..(n + 1)
        ] ++
        ["matching: (m = ", show(m), ", n = ", show(n), ", tcoins = ", show(tcoins), ")\n"]; 

% variable symmetry breaking
%constraint forall(j in 1..n-1)( 
%  lex_lesseq([tribute[i,j] | i in POLYGON],
%             [tribute[i,j+1] | i in POLYGON]) 
%     );

%constraint lex_lesseq([tribute[i,j] | i in 1..round(m div 2), j in VERTEX], [tribute[m+1-i,j] | i in 1..round(m div 2), j in VERTEX]); 
constraint forall(j in 1..n-1)
     (tribute[1,j] < tribute[1,j+1]);
constraint tribute[1,1] < tribute[m,1];

% value symmetry breaking by breaking variable
% variable symmetry using channeling
set of int: PVERTEX = 1..n*m;

array[TRIBUTE] of var PVERTEX: position;


constraint inverse(array1d(tribute), position);

constraint forall (i in RANK) (
       forall (j in m*(i-1)+1..m*i-1) (
          position[j] < position[j+1]
       )
    );