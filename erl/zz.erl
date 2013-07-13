-module(zz).

-behaviour(zc).

-export([start/0,stop/0, new_account/1, deposit/2, withdraw/2]).

-export(
	[init/1,
	handle_call/3,
	handle_cast/2,
	handle_info/2,
	terminate/2,
	code_change/3
	]
	).

start() ->
	io:format("1111"),
	zc:start_link(?MODULE, ?MODULE, [],[]),
	io:format("2222").

stop()->
	zc:call(?MODULE, stop).

new_account(Who) ->
	zc:call(?MODULE, Who).

deposit(Who, Amount) ->
	zc:call(?MODULE, {add, Who, Amount}).

withdraw(Who, Amount) ->
	zc:call(?MODULE, {remove, Who, Amount}).


init([])->
	{ok, state}.

handle_call({new, Who}, _From, State) ->
	Reply = {welcome, Who},
	{reply, Reply, State};
handle_call({add, Who, Amount}, _From, State) ->
        Reply = {Who,add,Amount},
        {reply, Reply, State};
handle_call({remove, Who, Amount}, _From, State) ->
        Reply = {Who, remove, Amount},
        {reply, Reply, State}.

handle_cast(_Msg, State) ->
	{noreply,State}.

handle_info(_Info,State) -> 
	{noreply,State}.

terminate(_Reason,_State) -> 
	ok.

code_change(_OldVsn,State,Extra) -> 
	{ok,State}.

