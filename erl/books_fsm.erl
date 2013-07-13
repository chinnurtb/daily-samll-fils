-module(books_fsm).

-behaviour(gen_fsm).

-author('lucas@yun.io').

-export([init/1, handle_event/3, unlogin/2, login/2, handle_sync_event/4,handle_info/3,terminate/3,code_change/4]).

-export([start/1, send_event/1]).

start(Code)->
	gen_fsm:start({local, ?MODULE}, ?MODULE, Code, []).

send_event(Pass)->
	gen_fsm:send_event(?MODULE, {to_login, Pass}).

init(Code) ->
	{ok, unlogin,Code}.

unlogin({to_login, Pass}, Code) ->
	case Pass of
		Code ->
			io:format("login success"),
			{next_state, login, 123};
		_ ->
			io:format("password is not correct"),
			{next_state, unlogin, Code}
	end.

login({to_login, _Pass}, Code) ->
	io:format("the code is ~p ~n", [Code]),
	{next_state, unlogin, Code}.

handle_event(_Event, _StateName, _StateData) ->
	{next_state, _StateName, _StateData}.

handle_sync_event(_Event, _From, _StateName, _StateData) ->
	{next_state, _StateName, _StateData}.

handle_info(_Info, _StateName, _StateData) ->
	{next_state, _StateName, _StateData}.

terminate(_Reason, _StateName, _StateData) ->
	ok.

code_change(_Old, _StateName, _StateData, _Extra) ->
	{ok, _StateName, _StateData}.
