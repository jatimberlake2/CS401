chef(joe).
chef(anne).
chef(bob).
chef(gordon).
food(pizza).
food(steak).
food(burgers).
food(hotdog).
cooks(X,Y):- chef(X),
     food(Y).

/*
, is AND
; is OR
*/