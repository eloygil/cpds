-module(erato).
-export([erato/1]).
-export([filter/1, generator/2]). %reason: to spawn

% N >= 2
erato(N) -> FirstFilterPid = spawn(erato, filter, [[]]),
    spawn(erato, generator, [N, FirstFilterPid]),
    ok.

% N >= 2
generator(N, Pid) -> generator(2, N, Pid).

%N >= 2, K <= N + 1
generator(K, N, Pid) when K == N + 1 -> Pid ! eos;
generator(K, N, Pid) -> Pid ! K,
    generator(K+1, N, Pid).

% Primes is the list of primes already generated
filter(Primes) ->
    receive
        eos -> io:format("~p~n",[lists:reverse(Primes)]);
        P -> NextFilterPid = spawn(erato, filter, [[P|Primes]]),
            loop(P, NextFilterPid)
    end.

loop(P, NextFilterPid) ->
    receive
        eos -> NextFilterPid ! eos;
        M when M rem P /= 0 -> NextFilterPid ! M,
            loop(P, NextFilterPid);
        _ -> loop(P, NextFilterPid)
    end.