%%% @copyright (c) 2013,2016 Francesco Cesarini
-module(hlr).
-export([new/0, attach/1, detach/0, lookup_id/1, lookup_ms/1]).

new() ->
    ets:new(msisdn2pid, [public, named_table]),
    ets:new(pid2msisdn, [public, named_table]),
    ok.

% @doc Inserts a mobile identifier (for a phone number) and a pid into 2 key-value tables. @end
attach(Ms) ->
    ets:insert(msisdn2pid, {Ms, self()}),
    ets:insert(pid2msisdn, {self(), Ms}).

detach() ->
    case ets:lookup(pid2msisdn, self()) of
    	[{Pid, Ms}] ->
  	    ets:delete(pid2msisdn, Pid),
  	    ets:delete(msisdn2pid, Ms);
    	[] -> ok
    end.

% @doc Finds a mobile identifier's pid. @end
lookup_id(Ms) ->
    case ets:lookup(msisdn2pid, Ms) of
    	[] -> {error, invalid};
    	[{Ms, Pid}] -> {ok, Pid}
    end.

% @doc Finds a pid's mobile identifier. @end
lookup_ms(Pid) ->
    case ets:lookup(pid2msisdn, Pid) of
    	[] -> {error, invalid};
    	[{Pid, Ms}] -> {ok, Ms}
    end.
