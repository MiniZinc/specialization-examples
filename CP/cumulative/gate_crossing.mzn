var 0..30: H;
var 0..30: Co;
var 0..30: Ca;
var 0..30: T;
constraint H + 15 <= Ca;
constraint H <= 15 /\ Co <= 18 /\ Ca <= 20 /\ T <= 22;
include "cumulative.mzn";
constraint cumulative([H,Co,Ca,T],[15,12,10,8],[3,1,2,2],4);
solve satisfy;
