% "Meta-Interpreter" for definite logic programs.
% Program to be interpreted is in a file, written in Prolog syntax.
% This progam is first loaded using load_pgm/1.
% Then a goal G is interpreted using interpret(G)
%    which computes answers for G
%    and prints out the derivations which result in the computed answer.

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

derive([], []).
derive([G|Gs], [d(I,NGs)|Ds]) :-
	pc(I, G, Bs),
	basics:append(Bs, Gs, NGs),
	derive(NGs, Ds).
	
print_derivation([]).
print_derivation([d(I,Gs)|Ds]) :-
	format('~~(~a)~~> ', I),
	writeln(Gs),
	print_derivation(Ds).

interpret(G) :-
	commalist_to_list(G, Gs),
	derive(Gs, Ds),
	writeln(Gs),
	print_derivation(Ds).