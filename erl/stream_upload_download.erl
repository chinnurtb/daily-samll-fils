-module(http_upload).
-export([create_thread/1,body_processing_result/1,connect_http/0,get_http/1,put_http/1]).

%%
%% create the thread;
%%
create_thread(0) ->
    ok;
create_thread(N) -> 
    inets:start(),
    erlang:system_flag(fullsweep_after,0),
    erlang:system_flag(min_bin_vheap_size,0),
    erlang:system_flag(min_heap_size,0),
    spawn(http_upload,connect_http,[]),
    create_thread(N-1).

%%
%% add the functions to threads;
%%
connect_http() ->
    get_http(1).
   

%%
%% upload datas;
%%
put_http(0) ->
	ok;
put_http(N) ->
	Url = "http://localhost:8000/home/get/123",
	{ok,Fd} = file:open("/home/lucas/tes.txt",read),
        httpc:request(put,{Url,[],"text/octet-stream",{chunkify,fun body_processing_result/1,Fd}},[],[]),
   	io:format("upload is over ~n"),
	erlang:garbage_collect(self()),
	put_http(N-1).

%%
%% read chunk datas;
%%
body_processing_result(Fd)->
	case file:read(Fd,16384) of 
		{ok,Data} ->
			{ok,Data,Fd};
		eof ->
			file:close(Fd),
			eof;
		{error,_ } ->
			eof
	end.

%%
%% download datas;
%%
get_http(0) ->
	ok;
get_http(N) ->
	Url = "http://localhost:8000/home/get/123",
	httpc:request(get,{Url,[]},[],[{stream,"/home/lucas/ll/jj/m"}]),
	erlang:garbage_collect(self()),
	get_http(N-1).
