#!/bin/gprolog --consult-file

:- include('data.pl').

%timeconversion(Hours,Minutes,Meridiem,Total) :-

%logic for am
timeconversion(12,Minutes,am,Total) :- 
	Total is Minutes.
timeconversion(Hours, Minutes, am, Total) :- 
	Hours < 12,
	Total is (Hours * 60) + Minutes.

%logic for pm
timeconversion(12,Minutes,pm,Total) :- 
	Total is (12 * 60) + Minutes.
timeconversion(Hours, Minutes, pm, Total) :-
	Hours < 12,
	Total is ((Hours + 12) * 60) + Minutes.

timetomins(time(Hours,Minutes,Meridiem), Total) :-
	timeconversion(Hours,Minutes,Meridiem, Total).


meetone(Person,slot(MStart, MEnd)) :- 
	free(Person, slot(AStart, AEnd)),
	timetomins(AStart, AStartTotal),
	timetomins(AEnd, AEndTotal),
	timetomins(MStart, MStartTotal),
	timetomins(MEnd, MEndTotal),
	%meeting start is either the same as or greater than when the person is available
	AStartTotal =< MStartTotal,
	%meeting end is equal to or less than  when the person is available
	%whover decided => means something other than just comparison is evil
	MEndTotal =< AEndTotal.

main :- findall(Person,
		meetone(Person,slot(time(8,30,am),time(8,45,am))),
		People),
	write(People), nl, halt.

:- initialization(main).