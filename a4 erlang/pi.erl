%Jonathan Luetze / J. Anthony Timberlake
%Assignment 4 - Erlang
%CS 401
%Spring 2018

-module(pi).
-import(math,[sqrt/1]).
-export([montecarlo/2]).

montecarlo(N,X) ->          % Main Montecarlo function
    SUM = estimate(N,X,0),  % call estimate to calculate points & add them up

    AVG = SUM / N,          % Calculate average
    writeNum(AVG).

estimate(N,X,SUM) when N > 0 -> % N is # of estimates | X is # of Actors| SUM is sum of estimate values
    A = hits(X,0),              % calculate hits for 1 iteration

    B = 4*A/X,                  % calculate pi estimate based on A and X
    NewSum = SUM + B,           % save sum of point values

    estimate(N-1,X,NewSum);     % loop N times

estimate(N,X,SUM) when N == 0, X >= 0 ->  % if n is 0, exit loop
    SUM.                                  % return SUM

hits(X,HIT) when X > 0 ->       % Calculate a hit
    ONE = rand:uniform(),       % Random number 1
    TWO = rand:uniform(),       % Random number 2

    VAL = sqrt(1-(ONE*ONE)),   % formula to calculate hit area
    if
        TWO =< VAL ->           % if TWO is within the hit area
            hits(X-1,HIT + 1);  % recurr and add 1 to # of hits
        true ->
            hits(X-1,HIT)       % else recurr without increment
    end;
    
hits(X,HIT) when X == 0 ->      % at the end, return # of hits
    HIT.

writeNum(X) ->                  % writes a number
    io:fwrite("~w~n",[X]).