#!/bin/gprolog --consult-file

:- include('data.pl').
:- include('uniq.pl').

timeconversion(12,Minutes,am,Total) :- 
	Total is Minutes.
timeconversion(Hours, Minutes, am, Total) :- 
	Hours < 12,
	Total is (Hours * 60) + Minutes.
timeconversion(12,Minutes,pm,Total) :- 
	Total is (12 * 60) + Minutes.
timeconversion(Hours, Minutes, pm, Total) :-
	Hours < 12,
	Total is ((Hours + 12) * 60) + Minutes.
timetomins(time(Hours,Minutes,Meridiem), Total) :-
	timeconversion(Hours,Minutes,Meridiem, Total).
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
overlap(_, _, empty).

%test_predicate_name(Time1, Time2, TestName) :-
%    predicate_name(Time1, Time2),
%    format('~w: ~w something to ~w~n', [TestName, Time1, Time2]).

test_timetomins(time(Hour,Mins,Meridiem), Expected, Title) :-
	timetomins(time(Hour,Mins,Meridiem), Total),
	(Total =:= Expected -> format('Pass: ~w~n',[Title]) 
	; format('~w:~nExpected: ~w got ~w~n',[Title,Expected,Total])).

test_minstotime(Mins,time(ExpectedHours,ExpectedMinutes,ExpectedMeridiem),Title) :-
	minstotime(Mins,time(Hours,Minutes,Meridiem)),
	((ExpectedHours =:= Hours, ExpectedMinutes =:= Minutes, ExpectedMeridiem = Meridiem) -> format('Pass: ~w~n',[Title])
	; format('~w:~nExpected: ~w:~w:~w got ~w:~w:~w~n', [Title, ExpectedHours,ExpectedMinutes,ExpectedMeridiem,Hours,Minutes,Meridiem])).

test_overlap(slot(time(SH1,SM1,SMD1),time(EH1,EM1,EMD1)),slot(time(SH2,SM2,SMD2),time(EH2,EM2,EMD2)),Expected,Title):-
	overlap(slot(time(SH1,SM1,SMD1),time(EH1,EM1,EMD1)),slot(time(SH2,SM2,SMD2),time(EH2,EM2,EMD2)),Overlap),
	(Expected = Overlap -> format('Pass: ~w~n',[Title]) 
	; format('~w:~nExpected: ~w got ~w~n',[Title, Expected, Overlap])).

main :- 
	test_timetomins(time(12,30,am), 30, '12:30 am test'),
	test_timetomins(time(1,0,am), 60, '1:00 am test'),
	test_timetomins(time(12,30,pm), 750, '12:30 pm test'),
	test_timetomins(time(1,0,pm), 780, '1:00 pm test'),
	test_minstotime(30,time(12,30,am), '30 mins test'),
	test_minstotime(60,time(1,0,am), '60 mins test'),
	test_minstotime(750,time(12,30,pm), '750 mins test'),
	test_minstotime(780,time(1,0,pm), '780 mins test'),
	test_overlap(slot(time(1,0,am),time(2,0,am)),slot(time(1,0,am),time(2,0,am)), slot(time(1,0,am),time(2,0,am)),'Full Overlap'),
	test_overlap(slot(time(1,0,am),time(4,0,am)),slot(time(2,0,am),time(3,0,am)), slot(time(2,0,am),time(3,0,am)),'Engulfing Overlap'),
	test_overlap(slot(time(1,30,am),time(2,30,am)),slot(time(1,0,am),time(2,0,am)), slot(time(1,30,am),time(2,0,am)),'Partial Overlap'),
	test_overlap(slot(time(1,30,am),time(2,30,am)),slot(time(2,30,am),time(3,0,am)), _,'Endpoint Overlap'),
	test_overlap(slot(time(1,30,am),time(2,30,am)),slot(time(3,30,am),time(5,0,am)), _,'No Overlap'),
	nl, halt.

:- initialization(main).