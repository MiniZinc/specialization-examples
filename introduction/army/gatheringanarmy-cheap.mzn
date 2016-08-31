solve maximize strength;

var int: strength = 6*A + 10*B + 8*C + 40*D;  

int: budget = 10000;
constraint 13*A + 21*B + 17*C + 90*D <= budget;

var 0..1000: A;
var 0..400: B;
var 0..500: C;
var 0..150: D;

B = 0; C = 0; D = 0;

output ["A = \(A), B = \(B), C = \(C), D = \(D)\n" ++
        "strength = \(6*A + 10*B + 8*C + 40*D)\n" ++
        "size = \(A + B + C + D)\n"];