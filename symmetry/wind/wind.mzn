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

% variable symmetry breaking; 

% Variable symmetry breaking 1: Impose arbitrary order on outgoing branches, 
% with the lex-min outgoing branch the one numbered 1:

% constraint forall(j in 1..n-1)( 
%  lex_lesseq([tribute[i,j] | i in POLYGON],
%             [tribute[i,j+1] | i in POLYGON]) 
%     );

% Simpler:

constraint forall(j in 1..n-1)
   (tribute[1,j] < tribute[1,j+1]);

% Variable symmetry breaking 2: Impose arbitrary order between innermost and outermost
% polygon tribute sequence, with the innermost sequence the lex-lesser of the two:

% constraint lex_lesseq([tribute[i,j] | i in 1..round(m div 2), j in VERTEX], 
%                       [tribute[m+1-i,j] | i in 1..round(m div 2), j in VERTEX]); 

% Simpler:

constraint tribute[1,1] < tribute[m,1];
