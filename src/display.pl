
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
write_board([]).
write_board([Head|Tail]) :-
    write('| '),
    write_line(Head), nl,
    write_board(Tail).
