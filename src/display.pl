% writes a given number, with padding of spaces to match largest number in the board
% write_num(MaxElemSize, +Num)
write_num(MaxElemSize, Num):-
    num_digits(Num, NumSize),
    NumSpaces is MaxElemSize - NumSize, NumSpaces >= 0,
    write_num(MaxElemSize, NumSpaces, Num).
write_num(_, 0, Num):-
    write(Num).
write_num(MaxElemSize, Counter, Num):-
    write(' '),
    NewCounter is Counter - 1,
    write_num(MaxElemSize, NewCounter, Num).

% writes each character of the list (line). Takes into account the number of digits of largest number in board
% write_line(+MaxElemSize, +Line) :-
write_line(_, []).
write_line(_MaxElemSize, [Head|Tail]) :-
    write_num(_MaxElemSize, Head),
    write('| '),
    write_line(_MaxElemSize, Tail).

% writes each line of the board by calling the write_line function multiple times
% write_board(+Board)
write_board(List):-
    max_list_nested(List, MaxElem),
    num_digits(MaxElem, MaxElemSize),
    write_board(MaxElemSize, List).
write_board(_, []):-!,nl.
write_board(MaxElemSize, [Head|Tail]) :-
    write('| '),
    write_line(MaxElemSize, Head), nl,
    write_board(MaxElemSize, Tail).


% asks the user if they want the solver to run on the generated input or to stop the program
% ask_for_solver(+Input, +Sum)
ask_for_solver(Input, Sum):-
    nl, write('Do you want to solve this generated board? (Y / n)'),
    get_char(Char),
    (
        (Char = 'Y' ; Char = '\n') ->
        solve_and_display(Input, Sum)
        ;
        true
    ).
