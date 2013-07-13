-module(books_event).

-author('lucas@yun.io').

-export([start/0, notify/1, call/0]).

start() ->
	A = gen_event:start({local,?MODULE}),
	io:format("a ~p ~n",[A]),
	gen_event:add_handler(?MODULE, books_handler, [123,lucas,456]).


notify([Id, Name, Price])->
	gen_event:notify(?MODULE,{add_book,Id, Name, Price}).

call()->
	gen_event:call(?MODULE, books_handler, query_book).

