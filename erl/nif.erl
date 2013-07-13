-module(nif).

-export([init/0, hello/0]).

init() ->
	erlang:load_nif("./nif",0).

hello() ->
	"NIF library not loaded".
