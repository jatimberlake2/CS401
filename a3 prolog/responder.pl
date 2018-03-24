%%%%%%%%%%%%%% Written by Jonathan Luetze %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Simulated Psychiatrist/Responder %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% MAIN FUNCTIONS %%%%%%%%%%%%%%%%%%%%

start :- write('What is your problem?'),nl, getToken.

getToken :-
    read_line_to_codes(user_input,Cs),          % Takes in the next line
    atom_codes(A, Cs),                          % Converting part 1
    atomic_list_concat(_L, ' ', A),             % Converting part 2 - now it's an atom
    downcase_atom(A,X),                         % makes everything lowercase
    checkEnd(X).                                % send to rules

checkEnd('') :- printF('Exiting Program').      % Exits if nothing is entered
checkEnd(X) :- getKeyWord(X), getToken.         % Else, check the input, respond, and move to next input

getKeyWord(X) :-                                % Checks for keywords
    thisIs(X);                                  % keyword "this is"
    family(X);                                  % Family keywords
    why(X);                                     % why keywords
    feeling(X);                                 % like keywords
    school(X);                                  % school keywords
    continue.                                   % If no keyword it found, just continue

%%%%%%%%%%%%%%%%%% KEYWORD DEFINITIONS %%%%%%%%%%%%%%%%%%

thisIs(X) :-
    sub_atom(X,Before,Length,After,'this is'),                       % starts with this is
    editString(X, Before, Length, After, 'What else do you regard as').

family(X) :-                                                         % Check for family references, and respond accordingly
    sub_atom(X,_Before,_Length,_After,'family'), printFamily;
    sub_atom(X,_Before,_Length,_After,'mother'), printFamily; 
    sub_atom(X,_Before,_Length,_After,'father'), printFamily;
    sub_atom(X,_Before,_Length,_After,'brother'),printFamily;
    sub_atom(X,_Before,_Length,_After,'sister'), printFamily.

why(X) :-
    sub_atom(X,_Before,_Length,After,'why should i'), After =:= 1,   % just why should i
    printF('Why should you what?');
    sub_atom(X,_Before,_Length,After,'why not'), After =:= 1,        % just why not
    printF('Because I said so.');
    sub_atom(X,_Before,_Length,After,'why'), After =:= 1,            % just why
    printF('Because I said so.');
    sub_atom(X,Before,Length,After,'why should i'),                  % starts with why should i, make it work with anything
    editString(X, Before, Length, After,'Why should you not');
    sub_atom(X,_Before,_Length,_After,'why'),                        % starts with why
    printF('Why should you not?').
    

feeling(X) :-                                                        % responds to like statement
    sub_atom(X,_Before,_Length,After,'i don\'t like you'), After =:= 1,
    printF('I guess it\'s a mutual dislike. What do you like?').

school(X) :-                                                         % responds to school & subject statements
    sub_atom(X,_Before,_Length,_After,'school'),
    printF('Tell me more about being a student. What is your favorite subject?');
    sub_atom(X,_Before,_Length,_After,'math'), 
    printF('Why do you like Math?');
    sub_atom(X,_Before,_Length,_After,'science'),
    printF('Why do you like Science?');
    sub_atom(X,_Before,_Length,_After,'history'),
    printF('Why do you like History?');
    sub_atom(X,_Before,_Length,_After,'programming'),
    printF('Why do you like Programming?').

editString(X, Before, Length, After, Response) :-   % answers with part of question
    Y is After - 1,
    Front is Before + Length,
    sub_string(X,Front,Y,1,S),          % The Y shortens it by 1 for the punctuation, then strips it away, saves to string S            
    string_concat(Response,S,T),        % Concatenate statement with trimmed string S, save to string T
    string_concat(T,'?',Answer),        % Concatenate string T with ? and save to Answer
    printF(Answer).

%%%%%%%%%%%%%%%%%%%% PRINT FUNCTIONS %%%%%%%%%%%%%%%%%%%%

printFamily :- printF('Tell me more about your family.').

continue :- printF('I see. Please continue.').

printF(X) :- write(X), nl.
