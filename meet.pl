#!/bin/gprolog --consult-file

:- include('data.pl').
:- include('uniq.pl').
:- include('meetone.pl')

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

%minstotime(Total, time(Hours,Minutes,Meridiem)):-

%logic for am
minstotime(Total, time(Hours,Minutes,Meridiem)):-
	Total < 60,
	Hours is 12,
	Minutes is Total,
	Meridiem is am.
minstotime(Total, time(Hours,Minutes,Meridiem)):-
	Total < 720,
	Hours is Total // 60,
	Minutes is Total % 60,
	Meridiem is am.
%logic for pm
minstotime()


%overlap(slot(time(SH1,SM1,SMD1),time(EH1,EM1,EMD1)),slot(time(SH2,SM2,SMD2),time(EH2,EM2,EMD2)),Overlap)

%slots are the same
overlap(slot(time(SH1,SM1,SMD1),time(EH1,EM1,EMD1)),slot(time(SH2,SM2,SMD2),time(EH2,EM2,EMD2)),Overlap):-
	timetomins(time(SH1,SM1,SMD1), Start1),
	timetomins(time(EH1,EM1,SMD1), End1),
	timetomins(time(SH2,SM2,SMD2), Start2),
	timetomins(time(EH2,EM2,EMD2), End2),
	Start1 =:= Start2,
	End1 =:= End2,
	Overlap is slot(time(SH1,SM1,SMD1),time(EH1,EM1,EMD1))
%slot engulfs another
overlap(slot(time(SH1,SM1,SMD1),time(EH1,EM1,EMD1)),slot(time(SH2,SM2,SMD2),time(EH2,EM2,EMD2)),Overlap):-
	timetomins(time(SH1,SM1,SMD1), Start1),
	timetomins(time(EH1,EM1,SMD1), End1),
	timetomins(time(SH2,SM2,SMD2), Start2),
	timetomins(time(EH2,EM2,EMD2), End2),
	(Start2 < Start1 , End1 < End2 ; Start1 < Star2, End2 < End1),
	((Start2 < Start1 , End1 < End2) -> Overlap is 
	; Overlap is )
	
	

	





main :- findall(Slot, meet(Slot), Slots),
        uniq(Slots, Uniq),
        write(Uniq), nl, halt.

:- initialization(main).