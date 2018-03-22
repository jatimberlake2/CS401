%%%%
%%%% Name: runtime.pl -- Runtime rule insertion.
%%%%

man(tony).

thingIsThing(X) :-
        sub_atom(X,0,Len,Aft,'a '),                             % Handle the strings beginning with "A ..."
        sub_atom(X, Len, Whatever0, 0, ThingIs),                % Stores remainder of string into "ThingIs"
        sub_atom(ThingIs,Before,Length,After,' is a '),         % Handles the rest of the string parsing exactly as personIs
        MidEnd is Length + After,                               % MidEnd keeps place after the first thing
        sub_atom(ThingIs,0,Whatever,MidEnd,Thing1),             % Divides atom to only the first thing as Thing1
        MidBegin is Before + Length,                            % MidBegin keeps place up to the second thing
        sub_atom(ThingIs,MidBegin,Whatever2, 1, Thing2),        % Divides atom to only the second thing name as Thing2
        create_a_rule(Thing1, Thing2),                          % Assert new rule into the database with Thing1 as a Thing2
        %okay.                                                  % Really, it is okay.
        write("Well then.").                                    % Temporary differentiation from personIs procedure
  
    /*
    This is a [l,i,s,t], and this is a (t,u,p,l,e).  
    Convertng list to tuple:  
    []    -> undefined  
    [x]   -> (x) == x  
    [x,y] -> (x,y).  
    [x,y,z..whatever] = (x,y,z..whatever)  
    */

inheritance_rule(Thing1, Thing2) :- 

        Fact =.. [Thing1, X],
        Fact2 =.. [Thing2, X],
        Cond=Fact,
        Head=Fact2,
        %list_to_tuple(Cond,Body),
        dynamic(Head),
        assertz(Head :- Cond).
        %assert(Head :- Body),
        %listing(Head).

    
%    list_to_tuple([],_) :- 
%        write("Grr"),
%        ValidDomain='[x|xs]',
%        Culprit='[]',
%        Formal=domain_error(ValidDomain, Culprit),
%        Context=context('list_to_tuple','Cannot create empty tuple!'),
%        throw(error(Formal,Context)).
    
%    list_to_tuple([X],X).
    
%    list_to_tuple([H|T],(H,Rest_Tuple)) :-
%        write("snek"),
%        list_to_tuple(T,Rest_Tuple).