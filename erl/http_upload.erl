-module(http_upload).
-export([create_thread/1,connect_http/0]).


create_thread(0) ->
    ok;
create_thread(N) -> 
    spawn(http_upload,connect_http,[]),
    create_thread(N-1).

connect_http() ->
    Url = "https://10.32.0.11:9081/test",
    inets:start(),
    ssl:start(),
    {ok,Data} = file:read_file("/home/lucas/testjob/test/input_json.txt"),
    io:format("data ~p~n",[Data]),
    F = httpc:request(put,{Url,[{"Authorization","OAuth2 M2QzZDk3ZTQzZDA0Y2ViZjo2MzJlODNmZTUxODdjMjI1"},{"Source","yunio_linux_2_0_key"}],"application/json", Data},[],[]),
%	F = httpc:request(get,{Url,[{"Authorization","OAuth2 M2QzZDk3ZTQzZDA0Y2ViZjo2MzJlODNmZTUxODdjMjI1"},{"Source","yunio_linux_2_0_key"}]},[],[{stream,"/home/lucas/testjob/test/json"}]),
%    io:format("last ~p ~n",[Data]),
    io:format("upload is over ~p ~n",[F]).
