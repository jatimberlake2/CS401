[fact].

factorial(1,1).
factorial(N, _) :- N < 0, fail.
factorial(N, F) :- N > 1, N1 is N - 1, factorial(N1, F1), F is F1 * N.

factorialR(N,F) :- factorialR(N, 1, F).
factorialR(0, F, F) :- !.
factorialR(N, P, F) :- NexT is N - 1, ParT is N * P, factorialR(NexT, ParT, F).


square :- read(X), S is X * X, write(S).

func :- write('Here is something.').