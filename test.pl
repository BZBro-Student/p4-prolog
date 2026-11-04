#!/bin/gprolog --consult-file

test_predicate_name(Time1, Time2, TestName) :-
    predicate_name(Time1, Time2),
    format('~w: ~w something to ~w~n', [TestName, Time1, Time2]).


main :- (foo,
	 write('foo is true');
	 write('foo is not true')),
	nl, halt.

:- initialization(main).