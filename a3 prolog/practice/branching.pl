%square(X) :-    
%    (X = 0 -> write('I don\'t work with zero.');
%         X1 is X*X, write(X1)
%    ).

square(X) :-    
    X = 0, write('I don\'t work with zero.');
         X1 is X*X, write(X1).

go :- write('write the number'), nl,
        read(X), nl,
        square(X).