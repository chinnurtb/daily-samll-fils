-module(zc).

-export([start_link/4,call/2,loop/2]).

-export([behaviour_info/1]).

behaviour_info(callbacks) ->
	[{init,1},{handle_call,3},{handle_cast,2},{handle_info,2},
	 {terminate,2},{code_change,3}];
behaviour_info(_Other) ->
	undefined.

start_link(Name, Mod, Args, Options) ->
	Pid = spawn(?MODULE, loop, [Name, Mod]),
	register(db, Pid).

call(Name, Request) ->
	db ! {new, Name, Request}.

loop(Name, Mod) ->
	receive 
			{new, Name, Who} ->
						Reply = Name:handle_call({new, Who}, 1, 2),
						io:format("reply is ~p ~n",[Reply]);
			{add ,Name, Who} ->
						Name:handle_call({add, Who}, 1, 2)
	end.
