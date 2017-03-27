% Tim Zhang
% CSE505: HW3
% Written in an SWI environment
%----------------------------------------------------------------

%
% Loads program
%
load_pgm(F) :-
	seeing(OF),
	see(F),
	initialize,
	read_and_load(0),
	seen,
	see(OF).

initialize :-
	retractall(pc(_,_,_)).

read_and_load(I) :-
	read(T),
	(T= end_of_file
	->  true
	;   (T = (H :- B)
	    ->  commalist_to_list(B, BL), assert(pc(I, H, BL))
	    ;	assert(pc(I, T, []))
	    ),
	    J is I+1,
	    read_and_load(J)
	).

commalist_to_list(CL, L) :-
	phrase(commalist_to_list(CL), L).
	
commalist_to_list((C1,C2)) --> !, commalist_to_list(C1), commalist_to_list(C2).
commalist_to_list(C) --> [C].

%----------------------------------------------------------------
% Question 1: tpi/2
%----------------------------------------------------------------
% NOTE: Input C is assumed to be of the form p(x, y) 
%       with no encapsulating quotations.
tpi(0, []).

tpi(1, C) :-
    hii([], L),
    member(C, L).

tpi(I, C) :-
    I > 1,
    hii(I, 1, [], L),
    member(C, L).

%
% Helper predicate: hii(I, Counter, Old, New)
%
hii(I, J, L, L) :- 
    J is I + 1, !.

hii(I, Counter, Old, New) :-
    setof(L, hii(Old, L), ListOfLists),
    flatten(ListOfLists, Flatened),
    sort(Flatened, Sorted),
    Next is Counter + 1,
    hii(I, Next, Sorted, New).

%
% Helper predicate: hii(Old, New)
%
hii([], New) :-
    findall(H, pc(N, H, []), New).

hii(Old, New) :-
    pc(N, H, BL),
    member(C, Old),
    member(C, BL),
    select(C, BL, RBL),
    (RBL = [] 
    ->  ground(H),
    	append(Old, [H], New)
    ;   match(RBL, Old),
    	ground(H),
    	append(Old, [H], New)
    ).

%
% Helper predicate: match(RBL, L)
%
match([], L).

match([C | Cs], L) :-
	member(C, L),
	match(Cs, L).

%----------------------------------------------------------------
% Question 2: lm/1
%----------------------------------------------------------------
lm(X) :-
    lhm(M, 1, K),
    member(X, M).

%----------------------------------------------------------------
% Question 3: lmi/1
%----------------------------------------------------------------
lmi(N) :-
	lhm(M, 1, N), !.

%
% Helper predicate: lhm(M, I, K)
% Generates the LHM 
% Starting from iteration I and ending at iteration K
%
lhm(M, I, K) :-
	J is I + 1,
    hii(I, 1, [], L1),
    hii(J, 1, [], L2),
    (L1 = L2
    ->  M = L1,
    	K = I
    ;   lhm(M, J, K)
    ).

%----------------------------------------------------------------
% Question 4: bfe/2
%----------------------------------------------------------------
% NOTE: Input G is assumed to be of the form p(x, y) 
%       with no encapsulating quotations.
bfe(G, N) :-
	commalist_to_list(G, Gs),
	derive(Gs, 0, N).

%
% Helper predicate: derive(G, N, M)
%
derive([G], N, M) :-
	bagof(B, I^pc(I, G, B), Bs),
	resolve(Bs).

%
% Helper predicate: resolve(List)
%
resolve([B | Bs]) :-
	unify(B).

resolve([B | Bs]) :-
	\+ Bs = [],
	resolve(Bs).

resolve([B | Bs]) :-
	expand(B, E),
	append(Bs, E, New),
	resolve(New).

%
% Helper predicate: unify(Body)
%
unify(B) :- ground(B).

unify([B | Bs]) :-
	pc(_, B, L),
	ground(B),
	unify(Bs).

%
% Helper predicate: expand(List, Expanded)
%
expand([H | Hs], Es) :-
	bagof(B, I^pc(I, H, B), Bs),
	append(Hs, Bs, Es).

expand(G, Bs) :-
	bagof(B, I^pc(I, G, B), Bs).

%----------------------------------------------------------------
% Question 5:
% N will be >= i + 1.
% Depending on the structure of the program there can be any 
% number of arbitrary derivations to prove f but all of these
% proofs must be of length at least i + 1.
%----------------------------------------------------------------