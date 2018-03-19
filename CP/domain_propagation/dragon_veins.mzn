var {-20,-11,-5,-2,1,2,7,15}: X;
var {-13,-10,-7,-3,0,8,9}: Y;
constraint abs(X) + abs(Y) = 10;
solve satisfy;
