% Source: http://www.complang.tuwien.ac.at/ulrich/sicstus-prolog/call_nth.pl
:- use_module(library(structs),
         [new/2,
          dispose/1,
          get_contents/3,
          put_contents/3]).

:- meta_predicate(call_nth(0, ?)).
:- meta_predicate(call_nth1(0, +, ?)).

call_nth(Goal_0, Nth) :-
   new(unsigned_32, Counter),
   call_cleanup(call_nth1(Goal_0, Counter, Nth),
           dispose(Counter)).

call_nth1(Goal_0, Counter, Nth) :-
   nonvar(Nth),
   !,
   Nth \== 0,
   \+arg(Nth,s(1),2), % produces all expected errors
   call(Goal_0),
   get_contents(Counter, contents, Count0),
   Count1 is Count0+1,
   (  Nth == Count1
   -> !
   ;  put_contents(Counter, contents, Count1),
      fail
   ).
call_nth1(Goal_0, Counter, Nth) :-
   call(Goal_0),
   get_contents(Counter, contents, Count0),
   Count1 is Count0+1,
   put_contents(Counter, contents, Count1),
   Nth = Count1.

more_than_once(Goal) :-
   \+ \+ call_nth(Goal,2).

max_list(List, Return):-
   max_list(List, 0, Return).
max_list([], Counter, Return):-
   Return is Counter.
max_list([H|T], Counter, Return):-
   NewMax is max(H, Counter),
   max_list(T, NewMax, Return).
max_list_nested(List, Return):-
   max_list_nested(List, 0, Return).
max_list_nested([], Counter, Return):-
   Return is Counter.
max_list_nested([H|T], Counter, Return):-
   max_list(H, Max),
   NewMax is max(Max, Counter),
   max_list_nested(T, NewMax, Return).