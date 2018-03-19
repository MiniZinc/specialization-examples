% Based on model given in Prob 067: Quasigroup Completion on CSPLib
% http://www.csplib.org/Problems/prob067/models/

include "alldifferent.mzn";

int: N;
int: digs = ceil(log(10.0,int2float(N))); % digits for output
set of int: COLOR = 1..N;

array[COLOR,COLOR] of 0..N: start; %% initial board 0 = empty
array[COLOR,COLOR] of var COLOR: cell;
array[1..N*N] of var COLOR: celllist = [cell[i,j] | i,j in COLOR];

% fill initial board
constraint forall(i,j in COLOR)(
  if start[i,j] > 0 then cell[i,j] = start[i,j] else true endif );

% All different in rows
constraint forall (i in COLOR) (
                   alldifferent( [ cell[i,j] | j in COLOR ] ) )::domain;

% All different in columns.
constraint forall (j in COLOR) (
                   alldifferent( [ cell[i,j] | i in COLOR ] ) )::domain;

ann: random = int_search(celllist, first_fail, indomain_random, complete);
ann: domwdeg_random = int_search(celllist, dom_w_deg, indomain_random, complete);

% solve::random satisfy;
% solve::domwdeg_random satisfy;

ann: search0 = int_search(celllist, input_order, indomain_min, complete);
ann: search1 = int_search(celllist, first_fail, indomain_min, complete);
ann: search2 = int_search(celllist, first_fail, indomain_max, complete);
ann: search3 = int_search(celllist, first_fail, indomain_median, complete);
solve::search0 satisfy;
% solve satisfy;



output [ show_int(digs, cell[i,j]) ++ " " ++
        if j == N /\ i != N then "\n" else "" endif
        | i,j in COLOR ] ++ ["\n"];
