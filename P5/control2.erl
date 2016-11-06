-module(control2).
-export([go/2, initializefirst/2, initialize/3]).

go(N, M) -> 
    Tokens = [random:uniform(M) || _ <- lists:seq(1, M)],
    io:format("~p~n",[Tokens]),
    FirstWorker = spawn(control2, initializefirst, [N-1, self()]),
    FirstWorker ! {token, M-1},
    control(Tokens, FirstWorker, []).


control([], FirstWorker, Assigned) ->
    io:format("~p~n",[lists:reverse(Assigned)]),
    FirstWorker ! stop;
control([First|Others], FirstWorker, Assigned) ->
    receive 
        {Pid, eats} -> io:format("~p eats ~n",[Pid]),
            NewAssigned = [{Pid, First}|Assigned],
            control(Others, FirstWorker, NewAssigned)
    end.


initializefirst(0, Control) -> worker(Control, self());
initializefirst(N, Control) -> Next = spawn(control2, initialize, [N-1, Control, self()]),
    worker(Control, Next).

initialize(0, Control, First) -> worker(Control, First);
initialize(N, Control, _) -> Next = spawn(control2, initialize, [N-1, Control, self()]),
    worker(Control, Next).


worker(Control, Next) -> 
    receive
        {token, 0} -> Control ! {self(), eats},
            worker(Control, Next);
        {token, M} -> Control ! {self(), eats},
            Next ! {token, M-1},
            worker(Control, Next);
        stop -> Next ! stop
    end.