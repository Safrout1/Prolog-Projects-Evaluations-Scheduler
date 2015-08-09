day(sunday).
day(monday).
day(tuesday).
day(wednesday).
day(thursday).
day(friday).
day(saturday).

slot(first).
slot(second).
slot(third).
slot(fourth).
slot(fifth).

ta(nada_sharaf).
ta_busy(nada_sharaf,saturday,fourth).
ta_busy(nada_sharaf,saturday,fifth).
ta_busy(nada_sharaf,sunday,first).
ta_busy(nada_sharaf,sunday,fifth).
ta_busy(nada_sharaf,monday,second).
ta_busy(nada_sharaf,monday,fourth).
ta_busy(nada_sharaf,wednesday,first).
ta_busy(nada_sharaf,wednesday,third).
ta_day_off(nada_sharaf,thursday).
ta_day_off(nada_sharaf,friday).

jta(rami_khalil).
jta_busy(rami_khalil,sunday,first).
jta_busy(rami_khalil,sunday,second).
jta_busy(rami_khalil,sunday,third).
jta_busy(rami_khalil,sunday,fourth).
jta_busy(rami_khalil,sunday,fifth).
jta_day_off(rami_khalil,friday).
jta_day_off(rami_khalil,saturday).

student(rami_khalil).
student(arya).
student(sansa).
student(bran).
student(brienne).
student(jaime).
student(tyrion).
student(cersei).
student(joffrey).
student(tywin).
student(jon).
student(samwell).
student(gilly).
student(daenerys).
student(jorah).
student(drogo).
student(davos).
student(stannis).
student(melisandre).

in_tutorial(rami_khalil, t1337).
in_tutorial(arya, t3).
in_tutorial(sansa, t3).
in_tutorial(bran, t3).
in_tutorial(brienne, t2).
in_tutorial(jaime, t2).
in_tutorial(tyrion, t1).
in_tutorial(cersei, t1).
in_tutorial(joffrey, t2).
in_tutorial(tywin, t3).
in_tutorial(jon, t3).
in_tutorial(samwell, t2).
in_tutorial(gilly, t1).
in_tutorial(daenerys, t1).
in_tutorial(jorah, t1).
in_tutorial(drogo, t1).
in_tutorial(davos, t5).
in_tutorial(stannis, t5).
in_tutorial(melisandre, t5).

in_team(1,arya).
in_team(1,sansa).
in_team(1,bran).

in_team(2,brienne).
in_team(2,jaime).
in_team(2,tyrion).

in_team(3,cersei).
in_team(3,joffrey).
in_team(3,tywin).

in_team(4,jon).
in_team(4,samwell).
in_team(4,gilly).

in_team(5,daenerys).
in_team(5,jorah).
in_team(5,drogo).

in_team(6,davos).
in_team(6,stannis).
in_team(6,melisandre).

schedule(t1,sunday,first).
schedule(t1,monday,second).
schedule(t1,tuesday,third).
schedule(t1,wednesday,fourth).
schedule(t1,thursday,fifth).

schedule(t2,sunday,fifth).
schedule(t2,monday,fourth).
schedule(t2,tuesday,third).
schedule(t2,wednesday,second).
schedule(t2,thursday,first).

schedule(t3,sunday,second).
schedule(t3,monday,second).
schedule(t3,tuesday,second).
schedule(t3,wednesday,second).
schedule(t3,thursday,second).

schedule(t5,sunday,fourth).
schedule(t5,monday,fourth).
schedule(t5,tuesday,fourth).
schedule(t5,wednesday,fourth).
schedule(t5,thursday,fourth).










actual_student(S) :- student(S) , \+ jta(S).

ta_free(Name, Day, Slot) :- ta(Name), slot(Slot), day(Day), \+ ta_busy(Name, Day, Slot), \+ ta_day_off(Name, Day).

jta_free(Name, Day, Slot) :- jta(Name), slot(Slot), day(Day), \+ jta_busy(Name, Day, Slot), \+ jta_day_off(Name, Day).

evaluator_free(Name, Day, Slot) :- ta_free(Name, Day, Slot) ; jta_free(Name, Day, Slot).

student_free(S, Day, Slot) :- actual_student(S), day(Day), slot(Slot), in_tutorial(S, Num), \+ schedule(Num, Day, Slot), Day \= friday.

teams_free(Num, Day, Slot) :- findall(X, in_team(X, _), L), setof(Y, member(Y,L), L2), member(Num, L2), setof(Student,
								in_team(Num, Student), List), team_free(List, Day, Slot).

team_free([H1, H2, H3], Day, Slot) :- student_free(H1, Day, Slot), student_free(H2, Day, Slot), student_free(H3, Day, Slot).
team_free([H1, H2], Day, Slot) :- student_free(H1, Day, Slot), student_free(H2, Day, Slot).

suitable_timing(Time) :- findall(X, in_team(X, _), L), setof(Y, member(Y,L), L2), member(Num, L2), teams_free(Num, Day, Slot),
						evaluator_free(TA, Day, Slot), Time = evaluation_timing(Num, Day, Slot, TA).

evaluation(Sched) :- findall(X, in_team(X, _), L1), setof(Y, member(Y,L1), L2), setof(X, suitable_timing(X), L), do_it(L2, L, [], Sched).

do_it([], _, _, []).
do_it([Num|NumT], Times, Prev, [Chosen|Ans]) :- in_team(Num, _), member(evaluation_timing(Num, Day, Slot, TA), Times), \+ member(evaluation_timing(_, Day, Slot, TA), Prev),
												delete(Times, evaluation_timing(Num, Day, Slot, TA), Times2), Chosen = evaluation_timing(Num, Day, Slot, TA),
												do_it(NumT, Times2, [Chosen|Prev], Ans).























