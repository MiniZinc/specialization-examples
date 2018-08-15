enum PERSON; % set of people to be visited

array[PERSON] of int: duration;    % duration of visit
array[PERSON] of bool: on_weekend; % can the person be visited over weekends
array[PERSON] of int: rank;        % rank of person

array[int,1..2] of PERSON: prec;   % precedences between visits
set of int: PREC = index_set_1of2(prec); 

0..6: starting_day; % which day of the week is day 0 in the schedule
                    % 0 Monday, 1 Tuesday, ..., 5 Saturday, 6 Sunday

% upper bound on the amount of time needed: total duration plus 1 week
% per person who cant be visited on the weekend
int: total = sum(duration) + 7*sum(p in PERSON)(on_weekend[p] = false);
set of int: TIME = 0..total;

array[PERSON] of var TIME: start;
var TIME: end;

constraint forall(p in PREC)
                 (start[prec[p,1]] + duration[prec[p,1]] <= start[prec[p,2]]);

include "disjunctive.mzn";
constraint disjunctive(start, duration);

array[int] of var TIME: weekday = [ start[t] | t in PERSON where on_weekend[t] = false ];
array[int] of int: weekdur = [ duration[t] | t in PERSON where on_weekend[t] = false ];

array[int] of TIME: weekends =
	      if starting_day = 6 then [ 1 ] else [] endif ++
	      [ t | t in TIME where (t + starting_day) mod 7 = 5 ]; 
array[int] of int: weekend_dur =
              if starting_day = 6 then [ 1 ] else [] endif ++
	      [ 2 | t in TIME where (t + starting_day) mod 7 = 5 ];

constraint disjunctive(weekday ++ weekends, weekdur ++ weekend_dur );

constraint forall(p in PERSON)(start[p] + duration[p] <= end);

var int: rank_violation;
constraint rank_violation = sum(p1,p2 in PERSON where rank[p1] < rank[p2])(start[p1] > start[p2]);

solve minimize card(PERSON)*card(PERSON)*end + rank_violation;


set of int: PP = 0..card(PERSON);
array[TIME] of var PP: pp;

%constraint forall(t in TIME)(pp[t] > 0 -> start[pp[t]] <= t /\ start[pp[t]] + duration[pp[t]] > t);
constraint forall(p in PERSON, t in TIME)(start[p] <= t /\ start[p] + duration[p] > t <-> pp[t] = p);  



%output ["weekends = \(weekends);\n"];

%output [ show(p1) ++ " > " ++ show(p2) ++ "\n"  
%       | p1, p2 in PERSON where rank[p1] > rank[p2] /\ fix(start[p1]) < fix(start[p2]) ];


output
       ["Day:   "] ++ 
       [ ["M","T","W","T","F","S","S"][t mod 7 +1] ++ " " | t in 0..((fix(end) + starting_day) div 7 + 1) * 7 -1 ] 
       ++ ["\n"]
       ++
       ["Time:  "] ++ 
       [ if t div 10 >= 1 then show(t div 10) else " " endif ++ " " 
       | t in -starting_day .. ((fix(end) + starting_day) div 7 + 1) * 7 -1 - starting_day ]
       ++ ["\n"]
       ++
       ["       "] ++ 
       [ if t >= 0 then show(t mod 10) else " " endif ++ " " 
       | t in -starting_day .. ((fix(end) + starting_day) div 7 + 1) * 7 -1 - starting_day ]
       ++ ["\n"]
       ++
       ["Visit: "] ++ 
       [ if t < 0 then " "   
         elseif fix(pp[t]) > 0 then show(pp[t])
         else "." endif ++
         if t < 0 then " "
         elseif fix(pp[t]) != fix(pp[t+1]) then "|"
         elseif fix(pp[t]) > 0 then show(pp[t]) 
         else "." endif
       | t in -starting_day .. ((fix(end) + starting_day) div 7 + 1) * 7 -1 - starting_day ]
       ++ ["\n\n"]
       ++ ["start = \(start);\nend = \(end);\nrank_violation = \(rank_violation);\n"]
       ;