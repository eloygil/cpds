-module(control).
-export([go/2, worker/2]).

go(N, M) -> 
    Tokens = [random:uniform(M) || _ <- lists:seq(1, M)],
    io:format("~p~n",[Tokens]),
    [First|Rest] = generate(N),
    setring(First, [First|Rest]),
    First ! {token, M-1},
    control(Tokens, [First|Rest], []).


control([], Workers, Assigned) ->
    io:format("~p~n",[lists:reverse(Assigned)]),
    stopworkers(Workers),
    stop;
control([First|Others], Workers, Assigned) ->
    receive 
        {Pid, eats} -> io:format("~p eats ~n",[Pid]),
            NewAssigned = [{Pid, First}|Assigned],
            control(Others, Workers, NewAssigned)
    end.


worker(Control, Next) -> 
    receive
        {next, Pid} -> worker(Control, Pid);
        {token, 0} -> Control ! {self(), eats},
            worker(Control, Next);
        {token, M} -> Control ! {self(), eats},
            Next ! {token, M-1},
            worker(Control, Next);
        stop -> true
    end.


generate(0) -> [];
generate(N) -> [spawn(control, worker, [self(), []]) |  generate(N-1)].

setring(First, [H|[]]) -> H ! {next, First};
setring(First, [H|[S|T]]) -> H ! {next, S},
    setring(First, [S|T]).


stopworkers([Last|[]]) -> Last ! stop;
stopworkers([First|Rest]) -> First ! stop,
    stopworkers(Rest).


