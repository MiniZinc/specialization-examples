include "globals.mzn";

enum FOOD;
enum WINE;

array[FOOD, WINE] of int: joy;

array[WINE] of var FOOD: eat;
constraint alldifferent(eat);

solve maximize sum(w in WINE)(joy[eat[w], w]);
output["Pair Food \(eat[w]) with Wine \(w)\n" | w in WINE] ++ ["\nJoy: \(sum(w in WINE)(joy[eat[w], w]))"];