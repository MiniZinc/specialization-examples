include "globals.mzn";

enum TASK;

array[TASK] of int: duration;
int: p; % number of precedences
set of int: PREC = 1..p;
array[PREC,1..2] of TASK: pre;

int: t = sum(duration);
array[TASK] of var 0..t: start;

enum RESOURCE;
array[RESOURCE] of int: L; % resource limit
array[RESOURCE,TASK] of int: res;

constraint forall(i in PREC)
                 (start[pre[i,1]] + duration[pre[i,1]] <= start[pre[i,2]]);

constraint forall(r in RESOURCE)
   (cumulative(start, duration, [res[r,t] | t in TASK], L[r]));

var int: makespan = max(t in TASK)(start[t] + duration[t]);

solve minimize makespan;

output [show(makespan)," = ", show(start)];
