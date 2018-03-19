var {1,2,3}:     X;
var {2,3}:       Y;
var {2,3}:       Z;
var {1,2,3,4,5}: T;
var {3,4,5,6}:   U;
include "alldifferent.mzn";
constraint alldifferent([X,Y,Z,T,U]);
solve satisfy;
