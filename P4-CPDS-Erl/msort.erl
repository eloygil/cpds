-module(msort).
-export([ms/1, pms/1, p_ms/2]).

%We export only the sequential version and the parallel version

sep(L,0) -> {[], L};
sep([H|T], N) ->
	{Lleft, Lright} = sep(T, N-1),
	{[H|Lleft], Lright}.

merge(L1, []) -> L1;
merge([], L2) -> L2;
merge([HL1|TL1], [HL2|TL2]) ->
  if
    HL1 < HL2 -> [HL1 | merge(TL1, [HL2|TL2])];
    true -> [HL2 | merge([HL1|TL1], TL2)]
  end.

ms([]) -> [];
ms([A]) ->[A];
ms(L) ->
	{L1, L2} = sep(L, length(L) div 2),
	merge(ms(L1), ms(L2)).


rcvp(Pid) -> 
	receive
		{Pid, L} -> L
	end.

pms(L) ->
	Pid = spawn(msort, p_ms, [self(), L]),
    rcvp(Pid).

p_ms(Pid, L) when length(L) < 100 -> Pid ! {self(), ms(L)};
p_ms(Pid, L) -> 
	{Lleft, Lright} = sep(L, length(L) div 2),
    Pid1 = spawn(msort, p_ms, [self(), Lleft]),
    Pid2 = spawn(msort, p_ms, [self(), Lright]),
    L1 = rcvp(Pid1),
    L2 = rcvp(Pid2),
    Pid ! {self(), merge(L1,L2)}.