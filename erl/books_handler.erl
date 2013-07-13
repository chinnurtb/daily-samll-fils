-module(books_handler).

-behaviour(gen_event).

-author('lucas@yun.io').

-export([init/1, handle_call/2, handle_event/2, handle_info/2, terminate/2,code_change/3]).

-record(book, {id, name, price}).

init([Id, Name, Price]) ->
     {ok, #book{id=Id, name=Name, price=Price}}.

handle_call(query_book, State) ->
    {ok, [State#book.id, State#book.name, State#book.price], State}.

handle_event({add_book, Id, Name, Price}, State)->
	{ok, State#book{id=Id, name=Name, price=Price}}.

handle_info(_Info, State) ->
	{ok, State}.

terminate(_Reason, _State) ->
	ok.

code_change(_Old, State, _Extra) ->
	{ok, State}.
