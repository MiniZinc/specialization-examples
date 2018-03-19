enum BAGUA = {Heaven, Marsh, Fire, Thunder, Wind, Water, Mountain, Earth};

var {Earth, Mountain, Water, Wind, Thunder, Fire, Marsh}: FloodDragon;
var {Earth, Water, Wind, Thunder, Marsh, Heaven}: GoldDragon;
var {Earth, Mountain, Water, Wind, Thunder, Fire, Marsh, Heaven}: Raccoon;
var {Earth, Mountain, Water, Wind, Thunder, Fire, Marsh, Heaven}: Hare;
var {Earth, Mountain, Water, Wind, Fire, Marsh, Heaven}: Fox;
var {Earth, Mountain, Water, Wind, Thunder, Fire, Marsh, Heaven}: Tiger;
var {Earth, Water, Wind, Thunder, Marsh, Heaven}: Leopard;
     

var {Earth, Mountain, Water, Fire, Marsh, Heaven}: WildDog ;
var {Earth, Mountain, Water, Wind, Thunder, Fire, Marsh, Heaven}: Sheep;
var {Earth, Mountain, Water, Wind, Thunder, Fire, Marsh, Heaven}: RoeDeer;
var {Earth, Mountain, Water, Wind, Thunder, Fire, Marsh, Heaven}: Horse;
var {Mountain, Thunder, Fire, Marsh, Heaven}: Deer;
var {Earth, Mountain, Water, Wind, Fire, Marsh, Heaven}: Snake;
var {Earth, Thunder, Fire, Marsh, Heaven}: EarthWorm;
   

var {Earth, Mountain, Wind, Thunder, Fire, Marsh, Heaven}: Wolf;
var {Mountain, Water, Thunder, Fire, Marsh, Heaven}: Dog;
var {Earth, Mountain, Water, Wind, Thunder, Marsh}: Pheasant;
var {Earth, Mountain, Heaven}: Chicken;
var {Earth, Mountain, Water}: Bird; 
var {Earth, Mountain, Wind, Fire, Marsh, Heaven}: Monkey;  
var {Earth, Mountain, Water, Wind, Thunder, Marsh, Heaven}: Ape;
    

var {Mountain, Wind, Thunder, Fire, Marsh, Heaven}: ChineseUnicorn;
var {Earth, Water, Wind, Thunder, Fire, Marsh, Heaven}: Cow;
var {Earth, Mountain, Water, Wind, Fire, Marsh, Heaven}: Bat;
var {Water, Wind, Thunder, Fire, Marsh, Heaven}: Rat;
var {Earth, Wind, Thunder, Fire, Marsh, Heaven}: Sparrow;
var {Earth, Water, Wind, Thunder, Marsh}: Pig;
var {Earth, Wind, Fire, Marsh, Heaven}: Devil;

array[1..15,1..2] of BAGUA: BookOfChanges =
[| Heaven, Heaven
 | Earth, Earth
 | Earth, Wind
 | Water, Earth
 | Water, Wind
 | Water, Marsh
 | Fire, Heaven
 | Fire, Thunder
 | Thunder, Fire
 | Wind, Thunder
 | Wind, Mountain
 | Mountain, Thunder
 | Marsh, Heaven
 | Marsh, Fire
 | Marsh, Marsh
 |];

include "table.mzn";
predicate healthy(var BAGUA: a, var BAGUA: b) =
          table([a,b], BookOfChanges);

constraint healthy(FloodDragon, Leopard);
constraint healthy(GoldDragon, Wolf);
constraint healthy(Raccoon, Horse);
constraint healthy(Hare, Cow);
constraint healthy(Fox, Wolf);
constraint healthy(Tiger, Rat);
constraint healthy(Leopard, ChineseUnicorn);
constraint healthy(Leopard, Sheep);
constraint healthy(WildDog, Bird);
constraint healthy(Horse, Tiger);
constraint healthy(Deer, Pig);
constraint healthy(Snake, WildDog);
constraint healthy(Snake, Fox);
constraint healthy(EarthWorm, Raccoon);
constraint healthy(EarthWorm, Rat);
constraint healthy(Wolf, Cow);
constraint healthy(Dog, RoeDeer);
constraint healthy(Pheasant, Deer);
constraint healthy(Pheasant, Bat);
constraint healthy(Chicken, Sheep);
constraint healthy(Bird, GoldDragon);
constraint healthy(Ape, Pig);
constraint healthy(Sparrow, RoeDeer);
constraint healthy(Devil, Monkey);
constraint healthy(Devil, Dog);

constraint FloodDragon != ChineseUnicorn;
constraint Hare != Rat;
constraint Fox != Bird;
constraint Tiger != Monkey;
constraint WildDog != Wolf;
constraint Sheep != Dog;
constraint RoeDeer != Pheasant;
constraint Deer != Sparrow;
constraint Wolf != WildDog;
constraint Ape != Devil;

solve satisfy;