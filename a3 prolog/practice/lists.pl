member(X, [_|Y]) :- member(X, Y).
size([_|X], N) :- size(X, N1), N is N1 + 1.
