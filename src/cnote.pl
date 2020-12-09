:-use_module(library(clpfd)).
:-use_module(library(lists)).

% Display

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

% Logic

% Input -> square matrix filled with numbers given in flattened list

% Applies restriction "Sum of all elements equals S" to every row in the Matrix
% sum_rows(+Matrix, +S)
sum_rows([], _).
sum_rows([H|T], S):-
    sum(H, #=, S), sum_rows(T, S).

% Breaks up list of all Vars into list of Rows of length N
% make_rows(+Vars, +N, -Rows)
make_rows(Vars, N, Rows):-
    make_rows(Vars, [], [], 1, N, Rows).
make_rows([], _, X, _, _, Rows):- Rows = X.
make_rows([H|T], CurrRow, CurrRows, N, N, Rows):- 
    append(CurrRow, [H], NewCurrRow), 
    append(CurrRows, [NewCurrRow], NewCurrRows), 
    make_rows(T, [], NewCurrRows, 1, N, Rows).
make_rows([H|T], CurrRow, CurrRows, Counter, N, Rows):-
    append(CurrRow, [H], NewCurrRow),
    X is Counter + 1,
    make_rows(T, NewCurrRow, CurrRows, X, N, Rows).

% Applies restriction "Number includes digit given in input" to every element in Output (hardcoded for numbers until 100!!)
% includes_digit(+Numbers, +Input)
includes_digit(Numbers, Input):-
    includes_digit(Numbers, Input, 1).
includes_digit([], _, _).
includes_digit([Number|T], Input, Index):-
    nth1(Index, Input, Digit),
    Number // 10 #= Digit #\/ (Number - Digit) mod 10 #= 0,
    NewIndex is Index + 1, includes_digit(T, Input, NewIndex).

solver(Input, Output):-
    length(Input, Length),
    N is round(sqrt(Length)),

    % Decision variables
    length(Output, Length),
    domain(Output, 1, 100),

    make_rows(Output, N, Rows),
    transpose(Rows, Cols),
    Sum is 100,                     % In future will be input (?)

    % Restrictions / Evaluation functions
    sum_rows(Rows, Sum),            % All rows sum to Sum
    sum_rows(Cols, Sum),            % All columns sum to Sum
    includes_digit(Output, Input),  % All numbers include input digit

    % Labeling
    labeling([], Output),

    % Display
    write('Input board'), nl, nl,
    make_rows(Input, N, InputRows),
    write_board(InputRows), nl, nl,

    write('Output board'), nl, nl,
    write_board(Rows).

