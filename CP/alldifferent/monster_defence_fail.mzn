var {1,2}:       X;
var {1,2}:       Y;
var {1,2}:       Z;
var {2,3,4,5}:   T;
var {3,4,5,6}:   U;
include "alldifferent.mzn";
constraint alldifferent([X,Y,Z,T,U]);
solve satisfy;
