include "globals.mzn";

enum ELITE;
set of ELITE: archer;
set of ELITE: cavalry;
set of ELITE: infantry;
array[ELITE] of int: liuValue;
array[ELITE] of int: guanValue;
array[ELITE] of int: zhangValue;
 
var set of ELITE: Liu;
var set of ELITE: Guan;
var set of ELITE: Zhang;

constraint all_disjoint([Liu, Guan, Zhang]);

predicate form(var set of ELITE: aTeam) =  
          card(aTeam intersect archer) >= 1 /\
          card(aTeam intersect cavalry) >= 2 /\
          card(aTeam intersect infantry) >= 2 /\
          card(aTeam) = 6;

constraint form(Liu);
constraint form(Guan);
constraint form(Zhang);

var int: obj = sum(e in Liu)(liuValue[e]) +
   sum(e in Guan)(guanValue[e]) +
   sum(e in Zhang)(zhangValue[e]);
solve maximize obj;

output ["Liu: \(Liu)\n"] ++
       ["Guan: \(Guan)\n"] ++
       ["Zhang: \(Zhang)\n"] ++
       ["\nobj = \(obj);\n"];
