-module(test1).
-export([f1/0, f2/0, test/0, factorial/1]).

% bad helper
f1() ->
    X = erlang:time(),
    seconds(X).

seconds({_Year, _Month, _Day, Hour, Min, Sec}) ->
    (Hour * 60 + Min)*60 + Sec.

% bad arg
f2() ->
    tuple_size(list_to_tuple({a,b,c})).

% bad logic
test() -> factorial(-5).
% changing to 1 && base case to 2, dialyzer misses (unrealistic) bug
% can only distinguish between `integer`, `non_neg_integer`, && `pos_integer`
factorial(0) -> 1;
factorial(N) -> N*factorial(N-1).

% dialyzer lib/dialyzer.erl -- a bit slow, but worth it... especially for coding challenges
% typer lib/dialyzer.erl

% apparently dialyzer doesn't work for Elixir; use dialyxr instead
