%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ben Trombley - The Proof Whisperer
%
% Can't make any promises for anything not in the test cases
%
% There is a catch in the FALSEHOOD-ellimination deduction
% to keep prolog from spinning infinitely
%
% A list of attempted moves can be seen by switching the
% comments for the try predicate.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

indent(N) :- N > 0, write('.'), indent(N-1).
indent(N) :- true.

try(S,X,N,Comment) :- 
	%indent(N), write('Trying: '), write(S), write(' :- '), write(X), writeln(Comment).
	true.

catch(S,X,N,Comment) :- 
	indent(N), write('Succeed: '), write(S), write(' :- '), write(X), writeln(Comment).

deduce(Ls,X,N) :- 
	try(Ls,X,N,' {Copy-rule}'),
	member(X,Ls),
	%catch(Ls,X,N,' {Copy-rule}').
	true.

deduce(Ls,and(X,Y),N) :-
	try(Ls,and(X,Y),N,' {AND-introduction}'),
	N1 is N+1,
	deduce(Ls,X,N1),
	deduce(Ls,Y,N1),
	catch(Ls,and(X,Y),N,' {AND-introduction}').
deduce(Ls,and(X,Y),N) :-
	try(Ls,and(X,Y),N,' {AND-introduction}'),
	N1 is N+1,
	deduce(Ls,X,N1),
	deduce(Ls,Y,N1),
	catch(Ls,and(X,Y),N,' {AND-introduction}').

deduce(Ls,X,N) :- 
	try(Ls,X,N,' {AND-elimination}'),
	member(and(X,_),Ls),
	catch(Ls,X,N,' {AND-elimination}').
deduce(Ls,X,N) :-
	try(Ls,X,N,' {AND-elimination}'),
	member(and(_,X),Ls),
	catch(Ls,X,N,' {AND-elimination}').
deduce(Ls,X,N) :-
	try(Ls,X,N,' {AND-elimination}'),
	member(and(_,Y),Ls),
	N1 is N+1,
	deduce([Y],X,N1),
	catch(Ls,X,N,' {AND-elimination}').
deduce(Ls,X,N) :-
	try(Ls,X,N,' {AND-elimination}'),
	member(and(Y,_),Ls),
	N1 is N+1,
	deduce([Y],X,N1),
	catch(Ls,X,N,' {AND-elimination}').

deduce(Ls,or(X,Y),N) :-
	try(Ls,or(X,Y),N,' {OR-introduction}'),
	N1 is N+1,
	deduce(Ls,X,N1),
	catch(Ls,or(X,Y),N,' {OR-introduction}').
deduce(Ls,or(X,Y),N) :-
	try(Ls,or(X,Y),N,' {OR-introduction}'),
	N1 is N+1,
	deduce(Ls,Y,N1),
	catch(Ls,or(X,Y),N,' {OR-introduction}').

deduce(Ls,X,N) :-
	try(Ls,X,N,' {MODUS-PONENS}'),
	member(imply(Y,X),Ls),
	N1 is N+1,
	deduce(Ls,Y,N1),
	catch(Ls,X,N,' {MODUS-PONENS}').

deduce(Ls,imply(X,Y),N) :-
	try(Ls,imply(X,Y),N,' {IMPLICATION-Introduction}'),
	\+ X = Y,
	append(Ls,[X],NewLs),
	N1 is N+1,
	deduce(NewLs,Y,N1),
	catch(NewLs,imply(X,Y),N,' {IMPLICATION-Introduction}').

deduce(Ls,X,N) :-
	try(Ls,X,N,' {OR-elimination}'),
	member(or(Y,Z),Ls),
	delete(Ls,or(Y,Z),NewLs),
	N1 is N+1,
	deduce(NewLs,imply(Y,X),N1),
	deduce(NewLs,imply(Z,X),N1),
	catch(Ls,X,N,' {OR-elimination}').

deduce(Ls,not(X),N) :-
   	try(Ls,not(X),N,' {NEG-introduction}'),
	N1 is N+1,
   	deduce(Ls,imply(X,false),N1),
   	catch(Ls,not(X),N,' {NEG-introduction}').

deduce(Ls,false,N) :-
  	try(Ls,false,N,' {FALSEHOOD-introduction}'),
  	N < 8,
  	member(not(A),Ls),
	N1 is N+1,
  	deduce(Ls,A,N1),
  	catch(Ls,false,N,' {FALSEHOOD-introduction}').

deduce(Ls,X,N) :-
	try(Ls,X,N,' {DOUBLE-NEG-elimination}'),
	member(not(not(X)),Ls),
	catch(Ls,X,N,' {DOUBLE-NEG-elimination}').

deduce(Ls,not(not(X)),N) :-
	try(Ls,not(not(X)),N,' {DOUBLE-NEG-introduction}'),
	N1 is N+1,
	deduce(Ls,N1),
	catch(Ls,not(not(X)),N,' {DOUBLE-NEG-introduction}').

deduce(Ls,X,N) :-
 	try(Ls,X,N,' {FALSEHOOD-ellimination}'),
 	\+ X = false,
	N1 is N+1,
 	deduce(Ls,false,N1),
 	catch(Ls,X,N,' {FALSEHOOD-ellimination}').

test_and_commutativity :- 
	writeln('Testing and commutativity: '),
	deduce([and(a,b)], and(b,a),0),
	writeln(' ').

test_or_commutativity :- 
	writeln('Testing or commutativity: '),
	deduce([or(a,b)], or(b,a),0),
	writeln(' ').

test_associativity :- 
	writeln('Testing associativity: '),
	deduce([and(a,and(b,c))], and(and(a,b),c),0),
	writeln(' ').

test_distributivity :- 
	writeln('Testing distributivity: '),
	deduce([or(a,and(b,c))], and(or(a,b),or(a,c)),0),
	writeln(' ').

test_contrapositive :- 
	writeln('Testing contrapositive: '),
	deduce([imply(a,b)], imply(not(b),not(a)),0),
	writeln(' ').

test_demorgan :- 
	writeln('Testing demorgan: '),
	deduce([not(or(a,b))], and(not(a),not(b)),0),
	writeln(' ').

test_modus_tollens :-
	writeln('Testing and commutativity: '),
	deduce([imply(a,b), not(b)], not(a),0),
	writeln(' ').

test_me :-
	test_contrapositive, 
	test_and_commutativity, 
	test_or_commutativity, 
	test_associativity, 
	test_distributivity, 
	test_demorgan,
	test_modus_tollens.
