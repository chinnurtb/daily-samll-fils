-module(link).
-export([create_thread/1,connect_http/0]).


create_thread(0) ->
    ok;
create_thread(N) -> 
    spawn(http_upload,connect_http,[]),
    create_thread(N-1).

connect_http() ->
    Url = "https://api.testyun.io/public/links",
    inets:start(),
    ssl:start(),
%    {ok,Fd} =file:open("/home/lucas/testjob/test",read),
%    {ok,Data} = file:read_file("/home/lucas/testjob/edoc.dtd"),
%   Data1 = mochijson:encode(Data),
%        F = httpc:request(put,{Url,[{"Authorization","OAuth2 NDZjN2RkYTk5YjJhYjNlYzpkMzMyMjc4YTFiNTVjZWFh"},{"Source","yunio_linux_2_0_key"},{"Content-Length","3330"}],"application/json",Data},[],[]),
	F = httpc:request(get,{Url,[{"Authorization","OAuth2 N2IyMWRkNDQ0YWUzMWY4Mzo0NzM0M2FmN2VhMDBjNDg5"},{"Source","yunio_linux_2_0_key"}]},[],[{stream,"/home/lucas/testjob/json"}]),
    io:format("upload is over ~p ~n",[F]).
%    file:close(Fd).
