int: len;

int: nS; % number of ships
set of int: SHIP = 1..nS; 
array[SHIP] of int: speed;   % 100m time 
array[SHIP] of int: desired; % desired time
int: enter = 1; int: leave = 2; 
array[SHIP] of enter..leave: dirn; 

int: leeway;  % leeway between 2 ships
int: maxt;        % maximum time
set of int: TIME = 0..maxt;

set of int: SHIPE = 1..nS+1; % add dummies
int: dummy = 3;
array[SHIPE] of enter..dummy: kind 
           = dirn ++ [ dummy ];
array[SHIPE] of int: speede = speed++[0];
array[SHIPE] of var TIME: start; 
array[SHIPE] of var TIME: end; 

array[SHIP] of var SHIPE: next; % next ship

constraint start[nS+1] = maxt;
constraint end[nS+1] = maxt;

constraint forall(s in SHIP)(end[s] = start[s] +    
                  len*speed[s]);

include "globals.mzn";
constraint alldifferent(next);

constraint forall(s in SHIP)
          % ships of opposite dirn
      (if kind[s] + kind[next[s]] = 3 then
          end[s] <= start[next[s]]
       else % same dirn
start[s]+speed[s]*leeway <= start[next[s]] /\
  end[s]+speede[next[s]]*leeway <= end[next[s]]
       endif); 

constraint forall(s in SHIP)(start[s] >= desired[s]);

solve minimize max(s in SHIP)(end[s]);
%solve minimize sum(s in SHIP)(start[s] - desired[s]);

output [ "start = ",show(start),
         ";\nend = ", show(end),
         ";\nnext = ", show(next),
         ";\n" ];