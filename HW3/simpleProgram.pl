e(a, a).
e(a, b).
e(b, c).
e(c, d).
p(X, Y) :- e(X, Y).
p(X, Y) :- e(X, Z), p(Z, Y).