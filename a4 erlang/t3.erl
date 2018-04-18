%Jonathan Luetze / J. Anthony Timberlake
%Assignment 4 - Erlang
%CS 401
%Spring 2018

-module(t3).
-export([newgame/0, playwith/1, stop/0, create_empty_board/0, wait_opponent/0, connect_opponent/1, tell/1, placetoken/1, printBoard/1]).

% erl -name jonathan@10.229.30.46 -setcookie game
% erl -name tony@192.168.10.107 -setcookie game
% erl -name yournamen@yourIP -setcookie game

% t3:newgame()
% t3:playwith('jonathan@192.168.1.72').
% t3:playwith('tony@10.229.67.20').


wait_msg(YourSym, HisSym, Board, OpponentPID, Turn) ->
    receive

{sendmsg, Msg} ->
    OpponentPID ! {message, Msg},
    NewTurn = Turn,
    NewBoard = Board;

{message, Msg} ->

    %%% SET CORRECT TURN ASSIGNMENT IN THE BEGINNING %%%
    CheckBoard = create_empty_board(),
    if
        ((Board =:= CheckBoard) and (Msg =:= 'You will start first. ~n')) ->
            NewTurn = self();
        ((Board =:= CheckBoard) and (Msg =:= 'Your Opponent will start first. ~n')) ->
            NewTurn = OpponentPID;
        true ->
            NewTurn = Turn
    end,

    io:format("Msg: ~w~n", [Msg]),
    NewBoard = Board;

{sendbrd, Coord} ->          % When message is being sent
    
    %%% CHECK BOARD BEFORE MOVE IS MADE %%%
    if
        (Turn =/= OpponentPID) -> 
            NewBoard = play(YourSym, Coord,Board),
            if
                Board =/= NewBoard ->         %
                    NewTurn = OpponentPID;    % Check to see if move was executed
                true ->                       %
                    NewTurn = self()          %
            end;
        true ->                     % Else set variables and return Board
            NewBoard = Board,
            NewTurn = Turn,
            Board 
    end,
    
    %%% CHECK BOARD AFTER MOVE WAS MADE %%%
    Move = check(NewBoard),
    if
        Move =:= victory ->
            io:fwrite("YOU ARE VICTORIOUS!!\n"),
            OpponentPID ! {message, 'YOU LOSE!! ~n'},
            stop();
        Move =:= draw ->
            io:fwrite("IT'S A DRAW!!\n"),
            OpponentPID ! {message, 'IT IS A DRAW!! ~n'},
            stop();
        true ->
            ok
    end,
    %%% ONLY SEND BOARD IF YOU MADE A MOVE %%%
    if
        NewTurn =:= self() ->
            io:write("");
        Turn =:= OpponentPID ->
            io:fwrite("It's not your turn!\n");
        true ->
            printBoard(NewBoard),              % print the board
            OpponentPID ! {rcvBoard, NewBoard} % send the board
    end;

{rcvBoard, NewBoard} ->           % When message is being received

    NewTurn = self(),
    printBoard(NewBoard)
    end,

    wait_msg(YourSym, HisSym, NewBoard, OpponentPID, NewTurn).

create_empty_board() ->
    {und, und, und,
     und, und, und,
     und, und, und}.

wait_opponent() ->
    receive
        {connect, PlayerY_PID} ->
            io:format("Another player joined. ~n", []),
            PlayerY_PID ! {gamestart, self()}, random:seed(now()),
            R = random:uniform(),               % better to have a seed for random number
            io:format("Random = ~w~n", [R]),
            Board = create_empty_board(),

            if
            R > 0.5 ->
                % current player starts
                io:format("You will start first. ~n", []), Turn = self(),
                PlayerY_PID ! {message, 'Your Opponent will start first. ~n'};
            true ->
                % Other player starts
                PlayerY_PID ! {message, 'You will start first. ~n'}, Turn = PlayerY_PID,
                io:format("Your Opponent will start first. ~n", [])
            end,
            wait_msg(x, o, Board, PlayerY_PID, Turn)
    end.

    connect_opponent(XNode) ->
        {player, XNode} ! {connect, self()},
        receive
        {gamestart, PlayerX_PID} ->
            io:format("Connection successful.~n",[]),
            Board = create_empty_board(),
            wait_msg(o,x,Board, PlayerX_PID, self())
        end.

% sends the message to the same node: wait_msg
% The node will then forward the message to the opponent

tell(Message) ->
    {player, node()} ! {sendmsg, Message}.

placetoken(Coord) ->
    %Board = create_empty_board(),
    {player, node()} ! {sendbrd, Coord}.

newgame() ->            % starts a new game node and waits for an opponent
    register(player, spawn(t3, wait_opponent, [])).

playwith(XNode)->       % connects to another Erlang node identified by Opponent and starts a new game
    register(player, spawn(t3, connect_opponent, [XNode])).

stop() ->
    player ! {self(), reqstop},
    unregister(player).

play(Who, Coord, Board) ->
    Index = checkCoord(Coord),        % Calculate index in tuple that the player selected
    
    if
        ((element(Index,Board) == und) and (Index > 0)) ->    % If spot isn't taken
            setelement(Index, Board, Who);
        true ->                                 % If spot is taken
            io:fwrite("Please select a different Location\n"),
            Board                               % Return the unchanged Board
    end.

checkCoord(Coord) ->
        if Coord =:= a1 -> 1;
         Coord =:= a2 -> 2;
         Coord =:= a3 -> 3;
         Coord =:= b1 -> 4;
         Coord =:= b2 -> 5;
         Coord =:= b3 -> 6;
         Coord =:= c1 -> 7;
         Coord =:= c2 -> 8;
         Coord =:= c3 -> 9;
        true -> -1 end.

printBoard(Board) ->
    io:fwrite("\n"),
    printElement(1,Board),
    io:fwrite("\n").

printElement(Index, Board) when Index =< 9 ->
    
    Element = element(Index, Board),
    if
        (Element =:= und) -> io:fwrite("- ");
        true -> io:fwrite(Element), io:fwrite(" ")
    end,

    if
        ((Index == 3) or (Index == 6)) -> io:fwrite("\n");
        true -> ok
    end,
    printElement(Index+1, Board);

printElement(Index, _Board) when Index =:= 10 -> io:fwrite("\n").

check(Board) ->
    case Board of
        {x, x, x,
         _, _, _,
         _, _, _} -> victory;

        {_, _, _,
         x, x, x,
         _, _, _} -> victory;

        {_, _, _,
         _, _, _,
         x, x, x} -> victory;

        {x, _, _,
         x, _, _,
         x, _, _} -> victory;

        {_, x, _,
         _, x, _,
         _, x, _} -> victory;

        {_, _, x,
         _, _, x,
         _, _, x} -> victory;

        {x, _, _,
         _, x, _,
         _, _, x} -> victory;

        {_, _, x,
         _, x, _,
         x, _, _} -> victory;

        {o, o, o,
         _, _, _,
         _, _, _} -> victory;

        {_, _, _,
         o, o, o,
         _, _, _} -> victory;

        {_, _, _,
         _, _, _,
         o, o, o} -> victory;

        {o, _, _,
         o, _, _,
         o, _, _} -> victory;

        {_, o, _,
         _, o, _,
         _, o, _} -> victory;

        {_, _, o,
         _, _, o,
         _, _, o} -> victory;

        {o, _, _,
         _, o, _,
         _, _, o} -> victory;

        {_, _, o,
         _, o, _,
         o, _, _} -> victory;

        {A, B, C,
         D, E, F,
         G, H, I} when A =/= und, B =/= und, C =/= und,
                       D =/= und, E =/= und, F =/= und,
                       G =/= und, H =/= und, I =/= und ->
            draw;   % no result, everything full

        _ -> ok     %continue
    end.