include "lex_lesseq.mzn";

predicate double_lex(array[int,int] of var int: x) =
          forall(i in index_set_1of2(x) where i != max(index_set_1of2(x)))
                (lex_lesseq([ x[i,j]   | j in index_set_2of2(x) ],
                            [ x[i+1,j] | j in index_set_2of2(x) ])) 
          /\
          forall(j in index_set_2of2(x) where j != max(index_set_2of2(x)))
                (lex_lesseq([ x[i,j]   | i in index_set_1of2(x) ],
                            [ x[i,j+1] | i in index_set_1of2(x) ])); 
