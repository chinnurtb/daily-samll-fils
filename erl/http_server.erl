-module(http_server).

-export([start/0]).

start() ->
      gen_tcp:listen(8000,[binary,{packet,0},{active,false}]).
	
