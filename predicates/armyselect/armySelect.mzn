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

constraint card(Liu intersect archer) >= 1;
constraint card(Liu intersect cavalry) >= 2;
constraint card(Liu intersect infantry) >= 2;
constraint card(Liu) = 6;

constraint card(Guan intersect archer) >= 1;
constraint card(Guan intersect cavalry) >= 2;
constraint card(Guan intersect infantry) >= 2;
constraint card(Guan) = 6;

constraint card(Zhang intersect archer) >= 1;
constraint card(Zhang intersect cavalry) >= 2;
constraint card(Zhang intersect infantry) >= 2;
constraint card(Zhang) = 6;

var int: obj = sum(e in Liu)(liuValue[e]) +
   sum(e in Guan)(guanValue[e]) +
   sum(e in Zhang)(zhangValue[e]);
solve maximize obj;

output ["Liu: \(Liu)\n"] ++
       ["Guan: \(Guan)\n"] ++
       ["Zhang: \(Zhang)\n"] ++
       ["\nobj = \(obj);\n"];
