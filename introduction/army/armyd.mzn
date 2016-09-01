solve maximize 6*F + 10*L + 8*Z + 40*J;  

int: budget;
constraint 13*F + 21*L + 17*Z + 100*J <= budget;

var 0..1000: F;
var 0..400: L;
var 0..500: Z;
var 0..150: J;

output ["F = \(F), L = \(L), Z = \(Z), J = \(J)\n"];