set of int: DIGIT = 1..9;
array[DIGIT] of int: rods = [1,2,3,4,5,2,3,4,5];  

var DIGIT: M1; % first messed up digit
var DIGIT: M2; % second messed up digit
var DIGIT: M3; % third messed up digit
var DIGIT: M4; % fourth messed up digit
var DIGIT: M5; % fifth messed up digit


constraint rods[M1] + rods[M2] + rods[M3] +  
           rods[M4] + rods[M5] = 12;

constraint 2303 + M1 * 10 + 980 + M2 * 1000 + M3 
           = 301 + M4 * 1000 + M5 * 10; 

% alldifferent messed up digits
include "alldifferent.mzn";

constraint alldifferent([M1,M2,M3,M4,M5]);

solve satisfy;