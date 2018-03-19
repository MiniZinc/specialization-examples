int: n = 20;

enum ELEMENTS = {Gold, Wood, Water, Fire, Earth};
enum SEASONS = {Spring, Summer, Autumn, Winter};

var ELEMENTS: x;
var SEASONS: y;

array[1..n div 2] of var ELEMENTS: oHerbs;
array[1..n div 2] of var SEASONS: eHerbs;

array[int,1..2] of ELEMENTS: eCompat = 
  [| Water, Wood | Water, Fire | Wood, Fire | Wood, Earth | Earth, Gold  |
     Fire, Earth | Fire, Gold  | Gold, Water| Gold, Wood  | Earth, Water |];
     
array[int,1..2] of (ELEMENTS union SEASONS): esCompat = 
  [| Summer, Wood | Autumn, Wood | Winter, Wood |
     Wood, Summer | Wood, Autumn | Wood, Winter |
     Spring, Fire | Autumn, Fire | Winter, Fire |
     Fire, Spring | Fire, Autumn | Fire, Winter |
     Spring, Gold | Summer, Gold | Winter, Gold |
     Gold, Spring | Gold, Summer | Gold, Winter |
     Spring, Water| Summer, Water| Autumn, Water|
     Water, Spring| Water, Summer| Water, Autumn|
     Spring, Earth| Summer, Earth| Autumn, Earth| Winter, Earth|
     Earth, Spring| Earth, Summer| Earth, Autumn| Earth, Winter|]; 
     
include "table.mzn";
constraint forall(i in 1..(n div 2 - 1))(table([oHerbs[i],oHerbs[i+1]], eCompat));
constraint forall(i in 1..(n div 2 - 1))(
%     trace("table([oHerbs[\(i)],eHerbs[\(i)]], esCompat) and table([eHerbs[\(i)],oHerbs[\(i+1)]], esCompat)\n",
     table([oHerbs[i],eHerbs[i]], esCompat) /\ table([eHerbs[i],oHerbs[i+1]], esCompat) );


constraint if n mod 2 = 0 then table([oHerbs[n div 2],eHerbs[n div 2]], esCompat) else true endif;

solve satisfy;

output[if i mod 2 = 1 then show(oHerbs[i div 2 + 1]) else show(eHerbs[i div 2]) endif++" " | i in 1..n];