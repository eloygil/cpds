-module(control).
-export([go/2, worker/2]).

% Authors: Albert Cerezo & Eloy Gil

% Token ring version 1, the control process creates all the
% workers and kills all workers too

go(N, M) -> 
    Tokens = createrandoms(M, M),
    io:format("~p~n",[Tokens]),
    [First|Rest] = generate(N),
    setring(First, [First|Rest]),
    First ! {token, M-1},
    control(Tokens, [First|Rest], []).

% Control process
control([], Workers, Assigned) ->
    io:format("~p~n",[lists:reverse(Assigned)]),
    stopworkers(Workers);
control([First|Others], Workers, Assigned) ->
    receive 
        {Pid, eats} -> io:format("~p eats ~n",[Pid]),
            NewAssigned = [{Pid, First}|Assigned],
            control(Others, Workers, NewAssigned)
    end.

% Worker process
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

% Creates a list of Times numbers between 1 and M
createrandoms(_, 0) -> [];
createrandoms(M, Times) -> [random:uniform(M)|createrandoms(M, Times-1)].

% Generates N workers
generate(0) -> [];
generate(N) -> [spawn(control, worker, [self(), []]) |  generate(N-1)].

% Sets the next worker for each worker
setring(First, [H|[]]) -> H ! {next, First};
setring(First, [H|[S|T]]) -> H ! {next, S},
    setring(First, [S|T]).

% Sends a message of stop to all the workers
stopworkers([]) -> stop;
stopworkers([First|Rest]) -> First ! stop,
    stopworkers(Rest).


