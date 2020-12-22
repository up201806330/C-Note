write_num(Num):- 
    (
        Num // 10 =:= 0 -> % If its single digit number
            write(' '), write(Num), write(' ') ;
            write(Num), write(' ')
    ).

% writes each character of the list (line).
% write_line(+Line) :-
write_line([]).
write_line([Head|Tail]) :-
    write_num(Head),
    write('| '),
    write_line(Tail).

% writes each line of the board by calling the write_line function multiple times
% write_board(+Board)
write_board([]):-!,nl.
write_board([Head|Tail]) :-
    write('| '),
    write_line(Head), nl,
    write_board(Tail).


% asks the user if they want the solver to run on the generated input or to stop the program
% ask_for_solver(+Input)
ask_for_solver(Input):-
    nl, write('Do you want to solve this generated board? (Y / n)'),
    get_char(Char),
    (
        (Char = 'Y' ; Char = '\n') ->
        solve_and_display(Input, _)
        ;
        true
    ).