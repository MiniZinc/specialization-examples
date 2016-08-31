% Three heroes combating Lü Bu
include "alldifferent.mzn";

enum HERO;
enum SPOT;

array[HERO,SPOT] of int: damage;
array[HERO] of var SPOT: pos;

constraint alldifferent(pos);

var int: tDamages = sum(h in HERO)(damage[h,pos[h]]);
solve maximize tDamages;

output ["\(h): \(pos[h])\n" | h in HERO] ++ ["Total Damages: \(tDamages)"];
