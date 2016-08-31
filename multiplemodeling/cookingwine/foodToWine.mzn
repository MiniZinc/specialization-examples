include "globals.mzn";

enum FOOD;
enum WINE;
array[FOOD, WINE] of int: joy;

array[FOOD] of var WINE: drink;

constraint alldifferent(drink);

solve maximize sum(f in FOOD)(joy[f, drink[f]]);
output["Pair Food \(f) with Wine \(drink[f])\n" | f in FOOD] ++ ["\nJoy: \(sum(f in FOOD)(joy[f, drink[f]]))"];