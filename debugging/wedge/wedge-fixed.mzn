% cavalry wedge
enum HORSE; % set of horses
enum RIDER; % set of riders
array[HORSE] of int: speed;
array[RIDER] of int: endur;
array[RIDER] of int: strength;

array[HORSE] of set of RIDER: compatible;

int: n;     % wedge size
set of int: POS = 1..n;

array[POS] of var HORSE: h; % horse at each position
array[POS] of var RIDER: r; % rider at each position

constraint forall(i in 1..n div 2)(trace("speed[h[\(i)]] < speed[h[\(i+1)]]\n" ++
                                   "endur[r[\(i)]] < endur[r[\(i+1)]]\n",
                                  speed[h[i]] < speed[h[i+1]] /\
                                  endur[r[i]] < endur[r[i+1]]
				  ));
constraint forall(i in n div 2+1..n-1)(trace("speed[h[\(i)]] > speed[h[\(i+1)]]\n" ++
                                   "endur[r[\(i)]] > endur[r[\(i+1)]]\n",
                                  speed[h[i]] > speed[h[i+1]] /\
                                  endur[r[i]] > endur[r[i+1]]
				  ));

include "alldifferent.mzn";
constraint alldifferent(r);
constraint alldifferent(h);

constraint forall(p in POS)(r[p] in compatible[h[p]]);

solve maximize sum(p in POS)(strength[r[p]]); 

output["h = \(h)\nr = \(r)\n"];