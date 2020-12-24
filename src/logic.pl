% Statistics predicates
reset_timer :- statistics(walltime,_).	
print_time(Message) :-
	statistics(walltime,[_,T]),
	TS is ((T//10)*10)/1000,
	nl, write(Message), write(' time: '), write(TS), write('s'), nl.

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

% Applies restriction "Number includes digit given in input" to Var, given the max Length the number can have
% includes_digit(+Var, +Input)
includes_digit(Var, Input):-
    Var mod 10  #= Input.
includes_digit(Var, Input):-
    Var #> 0,
    Rest #= Var // 10,
    includes_digit(Rest, Input).

% Applies restriction "Number includes digit given in input" to every element in Output
% includes_digit_list(+Vars, +Input)
includes_digit_list(Vars, Input):-
    includes_digit_list(Vars, Input, 1).
includes_digit_list([], _, _).
includes_digit_list([Var|T], Input, Index):-
    nth1(Index, Input, InputNum),
    includes_digit(Var, InputNum),
    NewIndex is Index + 1, includes_digit_list(T, Input, NewIndex).

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
    num_digits(Number, RandMax),
    random(0, RandMax, N),
    truncate_to(N, Number, Output).

% Returns number of digits of a given number Num
% num_digits(+Num, -Output)
num_digits(Num, Output):-
   Output is floor(log(10, max(Num, 1))) + 1.

% Solves a given puzzle
% solver(+Input, +Sum, -Output)
solver(Input, Sum, Output):-
    length(Input, Length),
    N is round(sqrt(Length)),

    % Decision variables
    length(Output, Length),
    DomainMax is Sum - N,
    domain(Output, 1, DomainMax),

    make_rows(Output, N, Rows),
    transpose(Rows, Cols),

    % Restrictions
    sum_rows(Rows, Sum),                % All rows sum to Sum
    sum_rows(Cols, Sum),                % All columns sum to Sum
    includes_digit_list(Output, Input), % All numbers include input digit

    % Labeling
    labeling([], Output).

% Calls solver and displays results
% solve_and_display(+Input, +Sum)
solve_and_display(Input, Sum):-
    length(Input, Length),
    N is round(sqrt(Length)), nl,

    % Solver and statistics
    reset_timer,
    solver(Input, Sum, Output),
    print_time('Solver'), nl,

    % Display Output
    write('Output board'), nl, nl,
    make_rows(Output, N, OutputRows),
    write_board(OutputRows).

% Generates a puzzle of given Size and target Sum
% generator(+Size, +Sum, -Output)
generator(Size, Sum, Output):-
    % Variables
    N is round(exp(Size, 2)),
    length(Res, N),
    DomainMax is Sum - N,
    domain(Res, 1, DomainMax),

    make_rows(Res, Size, Rows),
    transpose(Rows, Cols),

    % Restrictions
    sum_rows(Rows, Sum),            % All rows sum to Sum
    sum_rows(Cols, Sum),            % All columns sum to Sum
    
    % Labeling
    labeling([value(randomSelector)], Res),

    %nl, write_board(Rows), nl,

    % Remove random digits
    maplist(truncate_to_rand, Res, Output).

% Generates a puzzle of given Size and target Sum, making sure it only has ONE solution
% generator_unique(+Size, +Sum, -Output)
generator_unique(Size, Sum, Output):-
    % Variables
    N is round(exp(Size, 2)),
    length(Res, N),
    DomainMax is Sum - N,
    domain(Res, 1, DomainMax),

    make_rows(Res, Size, Rows),
    transpose(Rows, Cols),

    % Restrictions
    sum_rows(Rows, Sum),            % All rows sum to Sum
    sum_rows(Cols, Sum),            % All columns sum to Sum
    
    % Labeling
    labeling([value(randomSelector)], Res),

    % Remove random digits
    maplist(truncate_to_rand, Res, Output),

    nl, write('Found a solution, checking if its unique... '),
    (
        more_than_once(solver(Output, Sum, _)) ->
        write('Not unique, retrying'), nl, fail
        ;
        write('Found unique puzzle!'), nl
    ).

% Calls generator and displays results
% generate_and_display(+Size, +Sum)
generate_and_display(Size, Sum):-
    % Generator and statistics
    reset_timer,
    generator(Size, Sum, Output),
    print_time('Generator'), nl,
    
    length(Output, Length),
    N is round(sqrt(Length)),

    %Display Output
    write('Generated board'), nl, nl,
    make_rows(Output, N, OutputRows),
    write_board(OutputRows),

    ask_for_solver(Output, Sum).

% Calls generator_unique and displays results
% generate_unique_and_display(+Size, +Sum)
generate_unique_and_display(Size, Sum):-
    % Generator and statistics
    reset_timer,
    generator_unique(Size, Sum, Output),
    print_time('Generator'), nl,
    
    length(Output, Length),
    N is round(sqrt(Length)), nl,

    %Display Output
    write('Generated board'), nl, nl,
    make_rows(Output, N, OutputRows),
    write_board(OutputRows),

    ask_for_solver(Output, Sum).
