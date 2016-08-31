set of int: PATH = 1..10;
set of int: POST = 1..4;

array[PATH] of int: time;
array[POST] of int: guard;

var 0..2: weather; 
  % 0 = storm, 1 = rain, 2 = sun
var PATH: path;

var int: t = time[path] div weather +   
             extra * weather;
var int: extra;
constraint path in POST -> extra = guard[path];
constraint not(path in POST) -> extra = 0;

solve minimize t;

time  = [ 2, 4, 4, 4, 14, 10, 8, 14, 12, 10];
guard = [10, 8, 2, 4];