parent(tom, sarah).
parent(anika, sarah).

parent(yue, tom).
parent(jaroslav, tom).

parent(jaroslav, tim).
parent(yue, tim).

parent(tom, viktor).
parent(anika, viktor).

sibling(X,Y) :-  parent(Z, X), parent(Z, Y), X \= Y, parent(ZZ, X), parent(ZZ, Y), Z \= ZZ.