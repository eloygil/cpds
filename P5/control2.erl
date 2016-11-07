-module(control2).
-export([go/2, initializefirst/2, initialize/3]).

% Authors: Albert Cerezo & Eloy Gil

% Token ring version 2, the control process creates a
% single worker and each worker creates its next worker,
% the same things happens in order to kill them

go(N, M) -> 
    Tokens = createrandoms(M, M),
    io:format("~p~n",[Tokens]),
    FirstWorker = spawn(control2, initializefirst, [N-1, self()]),
    FirstWorker ! {token, M-1},
    control(Tokens, FirstWorker, []).

% Control process
control([], FirstWorker, Assigned) ->
    io:format("~p~n",[lists:reverse(Assigned)]),
    FirstWorker ! stop;
control([First|Others], FirstWorker, Assigned) ->
    receive 
        {Pid, eats} -> io:format("~p eats ~n",[Pid]),
            NewAssigned = [{Pid, First}|Assigned],
            control(Others, FirstWorker, NewAssigned)
    end.

% Worker process
worker(Control, Next) -> 
    receive
        {token, 0} -> Control ! {self(), eats},
            worker(Control, Next);
        {token, M} -> Control ! {self(), eats},
            Next ! {token, M-1},
            worker(Control, Next);
        stop -> Next ! stop
    end.

% Creates a list of Times numbers between 1 and M
createrandoms(_, 0) -> [];
createrandoms(M, Times) -> [random:uniform(M)|createrandoms(M, Times-1)].

% Initialize for the first 
initializefirst(0, Control) -> worker(Control, self());
initializefirst(N, Control) -> Next = spawn(control2, initialize, [N-1, Control, self()]),
    worker(Control, Next).

% Initialize others
initialize(0, Control, First) -> worker(Control, First);
initialize(N, Control, _) -> Next = spawn(control2, initialize, [N-1, Control, self()]),
    worker(Control, Next).