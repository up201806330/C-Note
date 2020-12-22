% Statistics predicates
reset_timer :- statistics(walltime,_).	
print_time(Message) :-
	statistics(walltime,[_,T]),
	TS is ((T//10)*10)/1000,
	nl, write(Message), write(' time: '), write(TS), write('s'), nl, nl.


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

% Custom labeling function to select random values from domain
% randomSelector(+Var, +Rest, +BB, +BB1)
randomSelector(Var, _Rest, BB, BB1) :-
    fd_set(Var, Set),
    select_best_value(Set, Value),
    (   
        first_bound(BB, BB1), Var #= Value
        ;   
        later_bound(BB, BB1), Var #\= Value
    ).
select_best_value(Set, BestValue):-
    fdset_to_list(Set, List),
    length(List, Len),
    random(0, Len, RandomIndex),
    nth0(RandomIndex, List, BestValue).

% Truncates a given Number to its digit of index N 
% (e.g. truncate_to(0, 29, 9))
% truncate_to(+N, +Number, -Output)
truncate_to(N, Number, Output):-
    Divisor is round(exp(10, N)),
    Output is (Number//Divisor) mod 10.
% Truncates to a random digit of the number
% truncate_to_rand(+Number, -Output)
truncate_to_rand(Number, Output):-
    RandMax is floor(log(10, Number)) + 1,
    random(0, RandMax, N),
    truncate_to(N, Number, Output).

solver(Input, Output):-
    length(Input, Length),
    N is round(sqrt(Length)),

    % Decision variables
    length(Output, Length),
    domain(Output, 1, 100),

    make_rows(Output, N, Rows),
    transpose(Rows, Cols),
    Sum is 100,                     % In future will be input (?)

    % Restrictions
    sum_rows(Rows, Sum),            % All rows sum to Sum
    sum_rows(Cols, Sum),            % All columns sum to Sum
    includes_digit(Output, Input),  % All numbers include input digit

    % Labeling
    labeling([], Output).

solve_and_display(Input, Output):-
    length(Input, Length),
    N is round(sqrt(Length)), nl,

    % Display Input
    write('Input board'), nl, nl,
    make_rows(Input, N, InputRows),
    write_board(InputRows), nl,

    % Solver and statistics
    reset_timer,
    solver(Input, Output),
    print_time('Solver'), nl, nl,

    % Display Output
    write('Output board'), nl, nl,
    make_rows(Output, N, OutputRows),
    write_board(OutputRows).


generator(Size, Output):-
    % Variables
    N is round(exp(Size, 2)),
    length(Res, N),
    domain(Res, 1, 100),

    make_rows(Res, Size, Rows),
    transpose(Rows, Cols),
    Sum is 100,                     % In future will be input (?)

    % Restrictions
    sum_rows(Rows, Sum),            % All rows sum to Sum
    sum_rows(Cols, Sum),            % All columns sum to Sum
    
    % Labeling
    labeling([value(randomSelector)], Res),

    nl, write_board(Rows), nl,

    % Remove random digits
    maplist(truncate_to_rand, Res, Output).

generate_and_display(Size, Output):-
    % Generator and statistics
    reset_timer,
    generator(Size, Output),
    print_time('Generator'), nl,
    
    length(Output, Length),
    N is round(sqrt(Length)), nl,

    %Display Output
    write('Generated board'), nl, nl,
    make_rows(Output, N, OutputRows),
    write_board(OutputRows),

    ask_for_solver(Output).
