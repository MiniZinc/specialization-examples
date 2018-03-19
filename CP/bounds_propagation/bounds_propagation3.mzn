var 0..9: W;
var 0..9: P;
var 0..9: C;
constraint 4*W + 3*P + 2*C <= 9;
solve satisfy;
