% Beauty Trap
% Create the most magnificient feast 
enum DISH;
enum TASTE = {spicy, sour, salty, sweet, umame, bland};
enum TEMP = {hot, cold, warm};
%int: ndish;
%set of int: DISH = 1..ndish;
%set of int: TASTE = 1..6;
%int: spicy = 1; int: sour = 2; int: salty = 3; int: sweet = 4; int: umame = 5; int: bland = 6;
%set of int: TEMP = 1..3;
%int: hot = 1; int: cold = 2; int: warm = 3;


array[DISH] of TASTE: taste;
array[DISH] of TEMP: temp;
array[DISH] of bool: heavy;
array[DISH] of int: value;

int: len; % length of banquet
set of int: COURSE = 1..len;

array[COURSE] of var DISH: dish;

include "alldifferent.mzn";
constraint alldifferent(dish);

%constraint taste[dish[1]] = salty;
%constraint taste[dish[len]] = sweet;
%constraint forall(c in 1..len-1)
%                 ((taste[dish[c]] = spicy -> (taste[dish[c+1]] in {bland, sweet})) /\
%                  (taste[dish[c]] = sour -> (taste[dish[c+1]] in {bland, umame})) /\
%                  (taste[dish[c]] = sweet -> (taste[dish[c+1]] in {spicy, sour, bland})));
%constraint forall(c in 1..len-1)
%                 (taste[dish[c]] != taste[dish[c+1]]);

include "regular.mzn";
constraint regular([taste[dish[c]] | c in COURSE], 7, card(TASTE), d, 1, {5});
array[1..7,TASTE] of 0..7: d = 
     [| 0,0,4,0,0,0
      | 0,0,0,5,0,7
      | 0,0,0,0,6,7
      | 2,3,0,5,6,7
      | 0,3,4,0,0,7
      | 2,3,4,5,0,7 
      | 2,3,4,5,6,0 |];
 


% a warm dish between any hot dish and later cold dish
%constraint forall(c in 1..len-1)
%                 (temp[dish[c]] = hot -> 
%                  forall(c1 in c+1..len)
%                        (temp[dish[c1]] = cold -> 
%                         exists(c2 in c+1..c1-1)(temp[dish[c2]] = warm)));
constraint regular([temp[dish[c]] | c in COURSE], 3, card(TEMP), e, 2, 1..3);
array[1..3,TEMP] of 0..3: e =
     [| 1,0,3
      | 1,2,3
      | 1,2,3 |];


% no more than two heavy dishes in a rows 
constraint forall(c in 1..len-2)
                 (heavy[dish[c]] /\ heavy[dish[c+1]] -> not heavy[dish[c+2]]);
% include "sliding_sum.mzn";
% constraint sliding_sum([ heavy[dish[c]] | c in COURSE], 0, 2, 3);


var int: obj = sum(c in COURSE)(value[dish[c]]) + 
               (len - 1) + 
               sum(c in 1..len-1)(temp[dish[c]] != temp[dish[c+1]]) +
               sum(c in 1..len-1)(heavy[dish[c]] != heavy[dish[c+1]]);

solve maximize obj;

output ["dish = \(dish);\nobj = \(obj);\n"];

