% Tim Zhang
% CSE505 HW 1
% Written in an SWI Environment

%-------------------------------------
% Problem 1
%-------------------------------------
prefix(X, []).

prefix([X | Xs], [X | Ys]) :-
    prefix(Xs, Ys).
  
%-------------------------------------
% Problem 2
%-------------------------------------
increasing([]).
increasing([X]).

increasing([X | [Y | Ys]]) :-
    X < Y,
    increasing([Y | Ys]).

%-------------------------------------
% Problem 3
%------------------------------------- 
pick_odd([], []).
pick_odd([X], [X]).

pick_odd([X | [Y | Ys]], [X | Zs]) :-
    pick_odd(Ys, Zs).

%-------------------------------------
% Problem 4
%-------------------------------------
% Helper predicate subsequence(L1, L2)
% True if L2 is a subsequence of L1.
subsequence(L, []).

subsequence([X | Xs], [X | L]) :-
    subsequence(Xs, L).

subsequence([X | Xs], [Y | Ys]) :-
    subsequence(Xs, [Y | Ys]).

incsub(L1, L2) :-
    subsequence(L1, L2),
    increasing(L2).

%-------------------------------------
% Problem 5
%-------------------------------------
factor(N, X) :-
    between(1, N, X),
    0 is mod(N, X).

%-------------------------------------
% Problem 6
%-------------------------------------
valid(X) :-
    var(X), !.

valid(true).
valid(false).

valid(and(X, Y)) :-
    valid(X), 
    valid(Y).

valid(or(X, Y)) :-
    valid(X),
    valid(Y).

valid(not(X)) :-
    valid(X).

%-------------------------------------
% Problem 7
%-------------------------------------
nnf(X, X) :-
    var(X), !.

nnf(not(X), not(X)) :-
    var(X), !.

nnf(not(not(X)), Y) :-
    valid(X),
    nnf(X, Y).

nnf(not(and(A, B)), and(C, D)) :-
    valid(A), 
    valid(B),
    nnf(not(A), C),
    nnf(not(B), D).

nnf(not(or(A, B)), or(C, D)) :-
    valid(A), 
    valid(B),
    nnf(not(A), C),
    nnf(not(B), D).

nnf(and(A, B), and(C, D)) :-
    valid(A), 
    valid(B),
    nnf(A, C),
    nnf(B, D).

nnf(or(A, B), or(C, D)) :-
    valid(A), 
    valid(B),
    nnf(A, C),
    nnf(B, D).

%-------------------------------------
% Problem 8
%-------------------------------------
% Helper predicate addUniqueVar(L1, L2, L3), where L1 is a singleton
% True if L1 is either in L2 or can be added to L2, L3 is the result.
addUniqueVar([X], [], [X]).

addUniqueVar([X], [Y | Ys], [Y | L]) :-
    not(X == Y), !,
    addUniqueVar([X], Ys, L).

addUniqueVar([X], [X | Xs], [X | Xs]).

% Helper predicate appendUniqueVar(L1, L2, L3)
% True if L1 can be appened to L2 such that L3 has only unique variables.
appendUniqueVars([], X, X).

appendUniqueVars([X | Xs], [Y | Ys], L) :-
    not(X == Y), !,
    addUniqueVar([X], [Y | Ys], Z),
    appendUniqueVars(Xs, Z, L).

appendUniqueVars([X | L1], [X | L2], [X | L3]) :-
    appendUniqueVars(L1, L2, L3).

vars(X, [X]) :-
    var(X), !.

vars(true, []).
vars(false, []).

vars(not(X), Y) :-
    valid(X),
    vars(X, Y).

vars(and(A, B), E) :-
    valid(A),
    valid(B),
    vars(A, C),
    vars(B, D),
    appendUniqueVars(C, D, E).

vars(or(A, B), E) :-
    valid(A),
    valid(B),
    vars(A, C),
    vars(B, D),
    appendUniqueVars(C, D, E).

%-------------------------------------
% Problem 9
%-------------------------------------
% Helper predicate negate(F1, F2)
% True if F2 is F1 after negating the formula
negate(not(and(X, Y)), or(not(X), not(Y))).
negate(not(or(X, Y)), and(not(X), not(Y))).
negate(not(not(X)), X).

% Helper predicate instantiate(X)
% True if X is instantiated
instantiate(true).
instantiate(false) :- !.

instantiate(and(X, Y)) :-
    instantiate(X),
    instantiate(Y).

instantiate(or(X, Y)) :-
    instantiate(X),
    instantiate(Y).

instantiate(not(X)) :-
    instantiate(X).

sat(true) :- !.
sat(not(false)) :- !.

sat(not(X)) :-
    var(X),
    X = false, !.

sat(not(X)) :-
    negate(not(X), Y),
    sat(Y).

sat(and(X, Y)) :-
    valid(X),
    valid(Y),
    sat(X),
    sat(Y).

sat(or(X, Y)) :-
    valid(X),
    valid(Y),
    instantiate(Y),
    sat(X).

sat(or(X, Y)) :-
    valid(X),
    valid(Y),
    instantiate(X),
    sat(Y).

%-------------------------------------
% Problem 10
%-------------------------------------
tautology(X) :-
    \+ sat(not(X)).

%-------------------------------------
% Problem 11
%-------------------------------------
count(F, 0) :-
    \+ sat(F), !.
    
count(F, N) :-
    tautology(F),
    vars(F, L),
    length(L, K),
    N is 2**K, !.

count(F, N) :-
    setof(F, sat(F), S),
    length(S, N).