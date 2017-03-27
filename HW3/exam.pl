p(f(f(f(a)))).
p(X) :- p(f(X)).
p(g(X)) :- p(f(X)).
p(h(X)) :- p(g(f(X))).