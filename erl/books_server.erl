-module(books_server).

-behaviour(gen_server).

-author('lucas@yun.io').

-export([start/1, add_book/1, query_book/0]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(book, {id, name, price}).

start([Id, Name, Price]) ->
	gen_server:start({local,?MODULE}, ?MODULE, [Id, Name, Price], []).

add_book([Id, Name, Price]) ->
	gen_server:call(?MODULE, {add, Id, Name, Price}).

query_book()->
	gen_server:call(?MODULE, query_book).

init([Id, Name, Price]) ->
	{ok, #book{id=Id, name=Name, price=Price}}.

handle_call({add,Id, Name, Price}, From, State) ->
	Reply = {add, ok},
	State1 = #book{id=Id, name=Name, price=Price},
	{reply, Reply, State1};
handle_call(query_book, From, State) ->
	Reply = [State#book.id,State#book.name,State#book.price],
	{reply,Reply, State}.

handle_cast(Req, State) ->
	{noreply, State}.

handle_info(Info, State) ->
	{noreply,State}.

terminate(Rea, State) ->
	ok.

code_change(Old, State, Ext) ->
	{ok,State}.

	
	
