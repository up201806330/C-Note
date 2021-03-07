# C-Note

- **Project name:** C-Note
- **Short description:** Solving a decision problem using restriction programming, with SICStus' CLPFD library, namely solving the puzzle [C-Note](https://erich-friedman.github.io/puzzle/100/)
- **Environment:** Prolog
- **Tools:** SICStus Prolog, CLPFD
- **Institution:** [FEUP](https://sigarra.up.pt/feup/en/web_page.Inicial)
- **Course:** [PLOG](https://sigarra.up.pt/feup/en/ucurr_geral.ficha_uc_view?pv_ocorrencia_id=459482) (Logic Programming)
- **Project grade:** 17.6/20
- **Group members:**
    - [João António Cardoso Vieira e Basto de Sousa](https://github.com/JoaoASousa) ([up201806613@fe.up.pt](up201806613@fe.up.pt))
    - [Rafael Soares Ribeiro](https://github.com/up201806330) ([up201806330@fe.up.pt](mailto:up201806330@fe.up.pt))

## Install

After cloning the project, open a SICStus terminal, navigate to *File* and hit *Consult*, then choose the file [*cnote.pl*](./src/cnote.pl). The predicate `cnote.` starts the program.

## Usage

The main menu presents the following options:

```
  /$$$$$$                      /$$   /$$  /$$$$$$  /$$$$$$$$ /$$$$$$$$
 /$$__  $$                    | $$$ | $$ /$$__  $$|__  $$__/| $$_____/
| $$  \__/                    | $$$$| $$| $$  \ $$   | $$   | $$      
| $$             /$$$$$$      | $$ $$ $$| $$  | $$   | $$   | $$$$$   
| $$            |______/      | $$  $$$$| $$  | $$   | $$   | $$__/   
| $$    $$                    | $$\  $$$| $$  | $$   | $$   | $$      
|  $$$$$$/                    | $$ \  $$|  $$$$$$/   | $$   | $$$$$$$$
 \______/                     |__/  \__/ \______/    |__/   |________/

1. Solve input puzzle                       <--- Input existing puzzle (examples in the game's web page)
2. Generate puzzle                          <--- Generate a random puzzle
3. Generate puzzle with unique solution     <--- Generate a puzzle that only has one possible solution
0. Exit
```
