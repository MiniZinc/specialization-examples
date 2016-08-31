include "globals.mzn";

enum FOOD;
enum WINE;
array[FOOD, WINE] of int: joy;

array[FOOD] of var WINE: drink;
%constraint alldifferent(drink);

array[WINE] of var FOOD: eat;
%constraint alldifferent(eat);

constraint inverse(eat, drink);

% solve maximize sum (f in FOOD) (joy[f, drink[f]]);
solve maximize sum (w in WINE) (joy[eat[w], w]);
output["Pair Food \(f) with Wine \(drink[f])\n" | f in FOOD] ++ ["\nJoy: \(sum(f in FOOD)(joy[f, drink[f]]))"];