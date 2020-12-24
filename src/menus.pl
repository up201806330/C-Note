solve_menu:-
    write('Type out input puzzle in the format [x,x,x, x,x,x, x,x,x]. (square array of numbers, recommended size: 3*3)'), nl,
    write(':- '), read(Input1), nl,
    write('Type number that all rows and columns sum up to (recommended: 100.)'), nl,
    write(':- '), read(Input2), nl, get_char(_),

    solve_and_display(Input1, Input2),
    back_to_main_menu.

generate_menu:-
    write('Type the size of the square array (recommended: 3.)'), nl,
    write(':- '), read(Input1), nl,
    write('Type number that all rows and columns sum up to (recommended: 100.)'), nl,
    write(':- '), read(Input2), nl, get_char(_),
    
    generate_and_display(Input1, Input2),
    back_to_main_menu.

generate_unique_menu:-
    write('Type the size of the square array (recommended: 3.)'), nl,
    write(':- '), read(Input1), nl,
    write('Type number that all rows and columns sum up to (recommended: 100.)'), nl,
    write(':- '), read(Input2), nl, get_char(_),

    generate_unique_and_display(Input1, Input2),
    back_to_main_menu.

back_to_main_menu:-
    write('Go to Main Menu?'), nl,
    enter_to_continue, nl,
    clear_terminal, main_menu.

main_menu:-
    write('  /$$$$$$                      /$$   /$$  /$$$$$$  /$$$$$$$$ /$$$$$$$$'),    nl,
    write(' /$$__  $$                    | $$$ | $$ /$$__  $$|__  $$__/| $$_____/'),    nl,
    write('| $$  \\__/                    | $$$$| $$| $$  \\ $$   | $$   | $$      '),  nl,
    write('| $$             /$$$$$$      | $$ $$ $$| $$  | $$   | $$   | $$$$$   '),    nl,
    write('| $$            |______/      | $$  $$$$| $$  | $$   | $$   | $$__/   '),    nl,
    write('| $$    $$                    | $$\\  $$$| $$  | $$   | $$   | $$      '),   nl,
    write('|  $$$$$$/                    | $$ \\  $$|  $$$$$$/   | $$   | $$$$$$$$'),   nl,
    write(' \\______/                     |__/  \\__/ \\______/    |__/   |________/'), nl, nl, nl,

    write('1. Solve input puzzle'), nl,
    write('2. Generate puzzle'), nl,
    write('3. Generate puzzle with unique solution'), nl, 
    write('0. Exit'), nl, nl,
    write(':- '),
    get_char(Input), get_char(_),
    (   Input = '1' -> clear_terminal, solve_menu;
        Input = '2' -> clear_terminal, generate_menu;
        Input = '3' -> clear_terminal, generate_unique_menu;
        Input = '0' -> true;
    
    nl, write('Invalid Option'), nl,                % "Else statement"
    enter_to_continue, nl,
    clear_terminal, main_menu
    ).

