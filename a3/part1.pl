%%%%%%%%%%%%%%%%%%%% MAIN FUNCTIONS %%%%%%%%%%%%%%%%%%%%

start :- write('Say something!'), nl, getToken.

getToken :-
   read_line_to_codes(user_input, Cs),           % Takes in the next line
   atom_codes(A, Cs),                           % Converting part 1
   atomic_list_concat(_L, ' ', A),               % Converting part 2 - now it is an atom
   downcase_atom(A,X),                          % makes everything lowercase
   checkEnd(X).

checkEnd('') :- printF('Exiting Program').      % Exits if nothing is entered
checkEnd(X) :- getKeyWord(X), getToken.         % Else, check the input, respond, and move to next question

getKeyWord(X) :-                                % Checks for keywords
    thingIsThing(X);                            % Checks for the form A(n) _ is a(n) _.
    personIs(X);                                % Checks for the form _ is a(n) _.
    isPerson(X).                                % Checks for the form Is _ a(n) _?

%%%%%%%%%%%%%%%%%% KEYWORD DEFINITIONS %%%%%%%%%%%%%%%%%%

personIs(X) :-                                             % Handle the strings that contain "... is a ..."
   sub_atom(X,Before,Length,After,' is a '),                % Separates the atom into 3 parts.
   MidEnd is Length + After,                                % MidEnd keeps place after the name
   sub_atom(X,0,_Whatever,MidEnd,Name),                      % Divides atom to only the person name as Name
   MidBegin is Before + Length,                             % MidBegin keeps place up to type of thing
   sub_atom(X,MidBegin,_Whatever2, 1, Thing),                % Divides atom to only the thing name as Thing
   add_rule(Name, Thing),                                   % Assert new rule into the database with person as a thing
   okay;                                                    % 
   sub_atom(X,Before,Length,After,' is an '),              % Separates the atom based on the form with "an" instead of "a".
   MidEnd is Length + After,                                % The exact same stuff happens from here on.
   sub_atom(X,0,_Whatever,MidEnd,Name),                      % 
   MidBegin is Before + Length,                             % 
   sub_atom(X,MidBegin,_Whatever2, 1, Thing),                % 
   add_rule(Name, Thing),                                   % 
   okay.                                                    % Really, it is okay.

thingIsThing(X) :-
    sub_atom(X,0,Len,_Aft,'a '),                            % Handle the strings beginning with "A ..."
    sub_atom(X, Len, _Whatever0, 0, ThingIs),                % Stores remainder of string into "ThingIs"
    sub_atom(ThingIs,Before,Length,After,' is a '),         % Handles the rest of the string parsing exactly as personIs
    MidEnd is Length + After,                               % MidEnd keeps place after the first thing
    sub_atom(ThingIs,0,_Whatever,MidEnd,Thing1),             % Divides atom to only the first thing as Thing1
    MidBegin is Before + Length,                            % MidBegin keeps place up to the second thing
    sub_atom(ThingIs,MidBegin,_Whatever2, 1, Thing2),        % Divides atom to only the second thing name as Thing2
    inheritance_rule(Thing1, Thing2),                       % Assert new rule into the database with Thing1 as a Thing2
    okay;                                                   % Really, it is okay.
    sub_atom(X,0,Len,_Aft,'an '),                           % Handle the strings beginning with "An ..."
    sub_atom(X, Len, _Whatever0, 0, ThingIs),                % 
    sub_atom(ThingIs,Before,Length,After,' is a '),        % Handle " ... is a ... "
    MidEnd is Length + After,                               % 
    sub_atom(ThingIs,0,_Whatever,MidEnd,Thing1),             % 
    MidBegin is Before + Length,                            % 
    sub_atom(ThingIs,MidBegin,_Whatever2, 1, Thing2),        % 
    inheritance_rule(Thing1, Thing2),                       % 
    okay;                                                   % 
    sub_atom(X,0,Len,_Aft,'a '),                            % Handle the strings beginning with "A ..."
    sub_atom(X, Len, _Whatever0, 0, ThingIs),                % 
    sub_atom(ThingIs,Before,Length,After,' is an '),       % Handle " ... is an ... "
    MidEnd is Length + After,                               % 
    sub_atom(ThingIs,0,_Whatever,MidEnd,Thing1),             % 
    MidBegin is Before + Length,                            % 
    sub_atom(ThingIs,MidBegin,_Whatever2, 1, Thing2),        % 
    inheritance_rule(Thing1, Thing2),                       % 
    okay;                                                   % 
    sub_atom(X,0,Len,_Aft,'an '),                           % Handle the strings beginning with "An ..."
    sub_atom(X, Len, _Whatever0, 0, ThingIs),                % 
    sub_atom(ThingIs,Before,Length,After,' is an '),       % Handle " ... is an ... "
    MidEnd is Length + After,                               % 
    sub_atom(ThingIs,0,_Whatever,MidEnd,Thing1),             % 
    MidBegin is Before + Length,                            % 
    sub_atom(ThingIs,MidBegin,_Whatever2, 1, Thing2),        % 
    inheritance_rule(Thing1, Thing2),                       % 
    okay.                                                   % The real, actual end of this part with so many lines of copy/paste

isPerson(X) :- 
    sub_atom(X,_Before,Length,_After,'is '),                  % Seperate the string into parts after "Is ..."
    sub_atom(X, Length, _Whatever, 0, NameAThing),           % Store all things from _ a _ ? into "NameAThing"
    sub_atom(NameAThing, Before2, Length2, After2, ' a '), % Seperate the string into parts on either side of ' a '
    MidEnd is Length2 + After2,                             % MidEnd keeps place of all parts after the first _.
    sub_atom(NameAThing, 0, _Whatever2, MidEnd, Name),       % Stores everything in the first _ position as the Name
    RealEnd is Before2 + Length2,                           % RealEnd keeps place of all parts before the last _.
    sub_atom(NameAThing, RealEnd, _Whatever3, 1, Thing),     % Stores everything in the second _ position as the Thing
    check_rule(Name, Thing);                                % Determines whether Name is a Thing, "thing(name)"
    sub_atom(X,_Before,Length,_After,'is '),                 % Separates the atom based on the form with "an" instead of "a".
    sub_atom(X, Length, _Whatever, 0, NameAThing),           % The exact same stuff happens from here on.
    sub_atom(NameAThing, Before2, Length2, After2, ' an '), % 
    MidEnd is Length2 + After2,                             % 
    sub_atom(NameAThing, 0, _Whatever2, MidEnd, Name),       % 
    RealEnd is Before2 + Length2,                           % 
    sub_atom(NameAThing, RealEnd, _Whatever3, 1, Thing),     % 
    check_rule(Name, Thing).                                % Does prolog really have to handle things this way?

%%%%%%%%%%%%%%%%%%%% RULES FUNCTIONS %%%%%%%%%%%%%%%%%%%%

add_rule(X, Predicate) :-                   % Procedure for asserting a new rule
   Fact =.. [Predicate, X],                 % Create new Term in the form Predicate(X)
   asserta(Fact).                           % Assert the Term, Fact, first in the database.

check_rule(X, Predicate) :-                 % Procedure for asking whether something is true
    Rule =.. [Predicate, _],                % First, check to see if said Predicate exists
    catch(                                  %   If not, this is "Unknown"
    (Rule,                                  %
    Fact =.. [Predicate, X],                % If the rule is valid, check the specific Term, Fact = Predicate(X)
    Fact,                                   % If Fact has been asserted, then write "Yes.", else "No."
    write("Yes."), nl;                      %
    write("No."), nl),                      %
    _E, printF("Unknown.")).                 % All nexted within one catch statement

inheritance_rule(Thing1, Thing2) :-         % Procedure for asserting a new inheritance relationship.
        Cond =.. [Thing1, X],               % Declare Thing1(X) as a Term.
        Head =.. [Thing2, X],               % Do the same for Thing2.
        dynamic(Head),                      % Make Head a dynamic rule to be modified.
        assertz(Head :- Cond).              % Assert the new resultant clause last in the database.

%%%%%%%%%%%%%%%%%%%% PRINT FUNCTIONS %%%%%%%%%%%%%%%%%%%%

okay :- write('Okay.'), nl.

printF(X) :- write(X), nl.