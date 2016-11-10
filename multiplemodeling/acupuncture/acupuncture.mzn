include "globals.mzn";

enum SPOT = {DAZHUI, TAODAOO, SHENZHU, LINGTAI, ZHIYANG, ZHONGSHU, JIZHONG, XUANSHU, YAOYANGGUAN, YAOYU};
%大椎 dazhui
%陶道 taodao
%身柱 shenzhu
%灵台 lingtai
%至阳 zhiyang
%中枢 zhongshu
%脊中 jizhong
%悬枢 xuanshu
%腰阳关 yaoyangguan
%腰俞 yaoyu

int: c;
int: m;

array[1..m, 1..c] of var SPOT: point;
array[1..m] of var set of SPOT: stage;

% points to jab in one stage
constraint forall(i in 1..m)(card(stage[i]) = c); 
% order within a stage
constraint forall(i in 1..m, j in 1..c-1) 
   (point[i, j] < point[i, j+1]); 
 
% no overlapping points among any three stages
constraint forall(i1, i2, i3 in 1..m where i1 < i2 /\ i2 < i3) 
   ((stage[i1] intersect stage [i2] intersect stage[i3]) = {});  
% order between stages
constraint forall(i in 1..m-1, j in 1..c) 
   (point[i, j] < point[i+1, j]); 

% ZHIYANG, ZHONGSHU can be jabbed only once
% constraint global_cardinality_low_up([point[i,j]|i in 1..m, j in 1..c],
%   [ZHIYANG, ZHONGSHU], [0,0], [1,1]);
constraint sum(i in 1..m)(ZHIYANG in stage[i]) <= 1;
constraint sum(i in 1..m)(ZHONGSHU in stage[i]) <= 1;


constraint forall(i in 1..m, s in SPOT)
   ((s in stage[i]) -> exists(j in 1..c)(point[i, j] = s)); % channeling
constraint forall(i in 1..m, j in 1..c)(point[i,j] in stage[i]); % channeling

solve satisfy;

output[show(array1d(point))];
% output[show(point)];