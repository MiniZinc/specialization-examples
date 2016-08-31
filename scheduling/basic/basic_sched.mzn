enum TASK;

array[TASK] of int: duration;
int: p; % number of precedences
set of int: PREC = 1..p;
array[PREC,1..2] of TASK: pre;

int: t = sum(duration);
array[TASK] of var 0..t: start;

constraint forall(i in PREC)
   (
%trace("start[\(pre[i,1])] + \(duration[pre[i,1]]) <= start[\(pre[i,2])]\n",
    start[pre[i,1]] + duration[pre[i,1]] <= start[pre[i,2]])
%)
;

var 0..t: makespan = max(t in TASK)(start[t] + duration[t]);
solve minimize makespan;

output [show(makespan)," = ", show(start)];
