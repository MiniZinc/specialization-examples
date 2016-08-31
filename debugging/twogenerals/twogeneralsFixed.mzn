enum HERO;
enum SPOT;
set of SPOT: LO = {TIANSHU,YONGQUAN};
set of SPOT: HI = SPOT diff LO;
array[HERO,SPOT] of int: damage;

array[HERO] of var SPOT: pos1;
array[HERO] of var SPOT: pos2;

solve maximize sum(h in HERO)(damage[h,pos1[h]] + damage[h,pos2[h]]);

include "alldifferent.mzn";
constraint alldifferent(pos1);
constraint alldifferent(pos2);
constraint forall(h in HERO)
      (pos1[h] != BAIHUI /\
       (pos1[h] in LO -> pos2[h] in HI));


HERO = { GUANYU, ZHANGLIAO, XUHUANG } ;
SPOT = { BAIHUI, DANZHONG, QUCHI, TIANSHU, YONGQUAN };
damage = [| 9,7,6,5,8
          | 8,2,5,1,4
          | 4,3,7,2,5 |];
