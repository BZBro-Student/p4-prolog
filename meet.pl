#!/bin/gprolog --consult-file

:- include('data.pl').
:- include('uniq.pl').



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

%This predicate is useless to me I programmed it before writing the overlap logic
%This took me an hour and it is useless :D
%minstotime(Total, time(Hours,Minutes,Meridiem)):-

%logic for am
minstotime(Total, time(Hours,Minutes,am)):-
	Total >= 0,
	Total < 60,
	Hours is 12,
	Minutes is Total.
minstotime(Total, time(Hours,Minutes,am)):-
	Total < 720,
	Hours is Total // 60,
	Minutes is Total mod 60.
%logic for pm
minstotime(Total, time(Hours,Minutes,pm)):-
	Total >= 720,
	Total < 780,
	Hours is 12,
	Minutes is Total mod 60.
minstotime(Total, time(Hours,Minutes,pm)):-
	Total >= 780,
	Total < 1440,
	Hours is (Total // 60) - 12,
	Minutes is Total mod 60.



%overlap(slot(time(SH1,SM1,SMD1),time(EH1,EM1,EMD1)),slot(time(SH2,SM2,SMD2),time(EH2,EM2,EMD2)),Overlap)

%slots are the same
overlap(slot(time(SH1,SM1,SMD1),time(EH1,EM1,EMD1)),slot(time(SH2,SM2,SMD2),time(EH2,EM2,EMD2)),Overlap):-
	timetomins(time(SH1,SM1,SMD1), Start1),
	timetomins(time(EH1,EM1,EMD1), End1),
	timetomins(time(SH2,SM2,SMD2), Start2),
	timetomins(time(EH2,EM2,EMD2), End2),
	Start1 =:= Start2,
	End1 =:= End2,
	Overlap = slot(time(SH1,SM1,SMD1),time(EH1,EM1,EMD1)).
%slot engulfs another
overlap(slot(time(SH1,SM1,SMD1),time(EH1,EM1,EMD1)),slot(time(SH2,SM2,SMD2),time(EH2,EM2,EMD2)),Overlap):-
	timetomins(time(SH1,SM1,SMD1), Start1),
	timetomins(time(EH1,EM1,EMD1), End1),
	timetomins(time(SH2,SM2,SMD2), Start2),
	timetomins(time(EH2,EM2,EMD2), End2),
	(Start2 < Start1 , End1 < End2 ; Start1 < Start2, End2 < End1),
	((Start2 < Start1 , End1 < End2) -> Overlap = slot(time(SH1,SM1,SMD1),time(EH1,EM1,EMD1))
	; Overlap = slot(time(SH2,SM2,SMD2),time(EH2,EM2,EMD2))).
 %slot overlaps either to the left or right of the other
overlap(slot(time(SH1,SM1,SMD1),time(EH1,EM1,EMD1)),slot(time(SH2,SM2,SMD2),time(EH2,EM2,EMD2)),Overlap):-
	timetomins(time(SH1,SM1,SMD1), Start1),
	timetomins(time(EH1,EM1,EMD1), End1),
	timetomins(time(SH2,SM2,SMD2), Start2),
	timetomins(time(EH2,EM2,EMD2), End2),
	((Start1 =< Start2,Start2 < End1, End1 < End2) ; (Start2 =< Start1, Start1 < End2,End2 < End1)),
	((Start1 =< Start2,Start2 < End1, End1 < End2) -> Overlap = slot(time(SH2, SM2, SMD2),time(EH1,EM1,EMD1))
	; Overlap = slot(time(SH1,SM1,SMD1),time(EH2,EM2,EMD2))).


people([ann,bob,carla]).
meet(Slot) :-	
	

	





main :- findall(Slot, meet(Slot), Slots),
        uniq(Slots, Uniq),
        write(Uniq), nl, halt.

:- initialization(main).