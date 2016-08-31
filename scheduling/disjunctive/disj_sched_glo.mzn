include "globals.mzn";

enum TASK;

array[TASK] of int: duration;
int: p; % number of precedences
set of int: PREC = 1..p;
array[PREC,1..2] of TASK: pre;


int: t = sum(duration);
array[TASK] of var 0..t: start;

constraint forall(i in PREC)
                 (start[pre[i,1]] + duration[pre[i,1]] <= start[pre[i,2]]);

predicate exclusive(set of TASK: tasks) =
   let {array[int] of var int: ss = [start[t] | t in tasks];
        array[int] of int: dd = [duration[t] | t in tasks];}
      in disjunctive(ss,dd);

% Liu is in charge of quality assurance
set of TASK: LIU;
constraint exclusive(LIU);

% Zhang is in charge of military strategies
set of TASK: ZHANG;
constraint exclusive(ZHANG);

% Quan is in charge of combat training
set of TASK: GUAN;
constraint exclusive(GUAN);

var 0..t: makespan = max(t in TASK)(start[t] + duration[t]);
solve minimize makespan;

output [show(makespan)," = ", show(start)];
