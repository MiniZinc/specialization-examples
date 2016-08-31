int: nC; % number of channels
array[1..nC] of int: len;

int: nS; % number of ships
set of int: SHIP = 1..nS; 
array[SHIP] of int: speed;   % 100m time 
array[SHIP] of int: desired; % desired time
int: enter = 1; int: leave = 2; 
array[SHIP] of enter..leave: dirn; 

int: leeway;  % leeway between 2 ships
int: maxt;        % maximum time
set of int: TIME = 0..maxt;

set of int: SHIPE = 1..nS+nC; % add dummies
int: dummy = 3;
array[SHIPE] of enter..dummy: kind 
           = dirn ++ [ dummy | i in 1..nC];
array[SHIPE] of int: speede = speed++[0|i in 1..nC];
array[SHIPE] of var TIME: start; 
array[SHIPE] of var TIME: end; 
array[SHIPE] of var 1..nC: channel;

array[SHIP] of var SHIPE: next; % next ship

constraint forall(s in nS + 1 .. nS + nC)
      (start[s] = maxt /\ end[s] = maxt);
constraint forall(s in nS + 1 .. nS + nC)
      (channel[s] = s - nS);

constraint forall(s in SHIP)(end[s] = start[s] +    
                  len[channel[s]]*speed[s]);

include "alldifferent.mzn";
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

constraint forall(s in SHIP)
      (channel[next[s]] = channel[s]);

solve minimize max(s in SHIP)(end[s]);
%solve minimize sum(s in SHIP)(start[s] - desired[s]);
%solve minimize sum(s in SHIP)(end[s] - desired[s]);

output [ "start = ",show(start),
         ";\nend = ", show(end),
         ";\nchannel = ", show(channel),
         ";\nnext = ", show(next),
         ";\n" ];
