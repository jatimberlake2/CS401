:- module(test1, [start/0]).
:- style_check(-singleton).

square(X) :- S is X * X, write(S).
start :- write('Starting program!'), loop.
loop :- write('\nHere!'),
read(X),
square(X).