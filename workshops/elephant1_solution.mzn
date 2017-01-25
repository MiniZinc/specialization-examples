



   % Given G guards where each guard can carry one bowl
   % The elephant is currently on the bank with W bowls of water and F bowls of food. 
   % The elephant will move to the boat or bank if it has equal numbers of bowls of food and water
   % and more bowls of food and water than on the bank
   % the elephant will eat if there is only food left where it is and it doesnt move, similarly
   % it will drink if there is only water left where it is and it doest move
   % Find a plan of moving the food and water to get the elephant onto the boat
   % with no food and water in minimum steps

int: T; % maximum time allowed;
set of int: TIME = 1..T;
set of int: TIME0 = 0..T;

int: G; % number of guards
set of int: GUARD = 1..G;
set of int: GUARD0 = 0..G;
int: F; 
set of int: FOOD = 0..F;
int: W;
set of int: WATER = 0..W;

enum POS = { bank, boat }; 

array[POS] of POS: opposite = [boat,bank];

array[TIME0] of var POS: pos;              % elephant at time t
array[TIME0] of var FOOD: food;            % food on bank at time t
array[TIME0] of var WATER: water;          % water on bank at time t

array[TIME] of var -F..F: move_food;      % move food +ve bank to boat, -ve boat to bank
array[TIME] of var -W..W: move_water;     % move water +ve bank to boat, -ve boat to bank
var TIME: end;                            % end time;

predicate elephant_moves(var FOOD: food_here, var WATER: water_here) = 
                         let { var FOOD: food_there = F - food_here; 
                               var WATER: water_there = W - water_here; } in
                         food_there = water_there /\ 
                         food_there > food_here /\ water_there > water_here
                         ;

%predicate elephant(var POS: pos, var FOOD: food_here, var WATER: water_here, var POS: new_pos) = 
%                   if elephant_moves(food_here, water_here) then new_pos = opposite[pos] else
%                   new_pos = pos /\ (food_here = 0 <-> water_here = 0)
%                   endif;
predicate elephant(var POS: pos, var FOOD: food_here, var WATER: water_here, var POS: new_pos) = 
                   let { var bool: b = elephant_moves(food_here, water_here); } in 
                   new_pos = [pos,opposite[pos]][b+1] /\
                   (b \/ (food_here = 0 <-> water_here = 0));
                   



constraint pos[0] = bank /\ food[0] = F /\ water[0] = W;

constraint forall(t in TIME)(food[t] = food[t-1] - move_food[t]); 
constraint forall(t in TIME)(water[t] = water[t-1] - move_water[t]); 

constraint forall(t in TIME)(abs(move_food[t] + move_water[t]) <= G);
constraint forall(t in TIME)(move_food[t] * move_water[t] >= 0);
constraint forall(t in TIME)(t > end -> (move_food[t] = 0 /\ move_water[t] = 0));

constraint forall(t in TIME)
                 (if pos[t-1] = bank then 
                     elephant(bank,food[t-1],water[t-1],pos[t])
                  else
                     elephant(boat,F-food[t-1],W-water[t-1],pos[t])
                  endif);

constraint pos[end] = boat /\ food[end] = F /\ water[end] = W; 



solve % :: int_search([end], input_order, indomain_min, complete)
   %  :: seq_search([ int_search([end], input_order, indomain_min, complete),
   %                  int_search([ if i mod 2 = 1 then move_food[i div 2 +1] 
   %                               else move_water[i div 2] endif | i  in 1..T*2 ], 
   %                               input_order, indomain_max, complete) ])
         minimize end; 

output [ if t <= fix(end) then show(pos[t]) else "." endif 
         ++ if t = T then "\n" else " " endif | t in TIME0 ] ++
       [ "\n" ] ++
       [ show_int(2,food[t]) ++ if t = T then "\n" else " " endif | t in TIME0 ] ++
       [ "\n  " ] ++
       [ show_int(2,move_food[t]) ++ if t = T then "\n" else " " endif | t in TIME ] ++
       [ "\n" ] ++
       [ show_int(2,water[t]) ++ if t = T then "\n" else " " endif | t in TIME0 ] ++
       [ "\n  " ] ++
       [ show_int(2,move_water[t]) ++ if t = T then "\n" else " " endif | t in TIME ] ++
       [ "\n" ] ++
       ["move_food = \(move_food);\nmove_water = \(move_water);\nend = \(end);\n"] ++
       [ "\n" ] ;
