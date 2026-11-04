#!/bin/gprolog --consult-file

:- include('data.pl').
:- include('uniq.pl').

people([ann,bob,carla]).

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

main :- findall(Slot, meet(Slot), Slots),
        uniq(Slots, Uniq),
        write(Uniq), nl, halt.

:- initialization(main).