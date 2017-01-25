% workshop 2
% select a set of trade negotiation party
enum NEGOTIATOR;
NEGOTIATOR: dummy; 

int: l; % minimum party size
int: u; % maximum party size
int: m; % minimum joint ability

array[NEGOTIATOR] of int: honor;
array[NEGOTIATOR,NEGOTIATOR] of int: joint;

array[1..u] of var NEGOTIATOR: party;


constraint forall(i in 1..l)(party[i] > dummy);

constraint forall(i in 1..u-1)(party[i] >= party[i+1] + (party[i+1] != dummy));

constraint sum(i,j in 1..u where i < j)(joint[party[i],party[j]]) >= m;

solve maximize obj;

var int: obj;
constraint obj =  (min(j in 1..u)((party[j] = dummy)*max(honor) + honor[party[j]]));

output ["party = "] ++
       ["{"] ++ [ if fix(party[j]) != dummy then 
                     show(party[j]) ++ if j == u \/ fix(party[j+1]) = dummy then "" else ", " endif 
                  else "" endif | j in 1..u ] ++ ["};\n"] ++
       ["obj = \(obj);\n"];