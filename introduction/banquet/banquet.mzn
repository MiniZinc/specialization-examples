enum DISH;
int: capacity;
array[DISH] of int: satisf;
array[DISH] of int: size;

array[DISH] of var int: amt; % how many of each dish

constraint forall(i in DISH)(amt[i] >= 0);
constraint sum(i in DISH)(size[i] * amt[i]) <= capacity;
solve maximize sum(i in DISH)(satisf[i] * amt[i]);

output ["Amount = ", show(amt), "\n"];