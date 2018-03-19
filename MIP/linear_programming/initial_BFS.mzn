var float: x;
var float: y;
var float: z;

constraint x >= 0;
constraint y >= 0;
constraint z >= 0;

solve maximize 1.0*x - 1.0*y + 1.0*z;
constraint  2.0*x - 1.0*y + 2.0*z <=  4.0;
constraint  2.0*x - 3.0*y + 1.0*z <= -5.0;
constraint -1.0*x + 1.0*y - 2.0*z <= -1.0;
