%% @author author <author@example.com>
%% @copyright YYYY author.
%% @doc Example webmachine_resource.

-module(server_stream).
-export([init/1,allowed_methods/2,content_types_accepted/2,content_types_provided/2,to_text/2,from_text/2,json_body/1,get_streamed_body/2,read_data/1,read_datas/2,encoder/1,charseter/1]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) -> {ok, undefined}.

%%
%% request allowed methods;
%%
allowed_methods(RD, Ctx) ->
    {['GET','PUT','POST'], RD, Ctx}.

%%
%% stream methods to handle the datas;
%%
get_streamed_body({Hunk,done},Fd) ->
     ok;
get_streamed_body({Hunk,Next},Fd) ->
     file:write(Fd,Hunk),
     erlang:garbage_collect(self()),
     get_streamed_body(Next(),Fd).

%%
%% handling update request;
%%
content_types_accepted(RD,Ctx) ->
    {[{"text/octet-stream",from_text}],RD,Ctx}.

%%
%% return results to the clients;
%%
from_text(RD,Ctx) ->
	{ok,Fd} = file:open("/home/lucas/http_test",[write,append]),
        get_streamed_body(wrq:stream_req_body(RD, 16384),Fd),
	{<<"ok">>,RD,Ctx}.

%%
%% handling download request;
%%
content_types_provided(RD, Ctx) ->
    {[{"text/plain", to_text}], RD, Ctx}.

%%
%% return results to the clients;
%%
to_text(RD,Ctx) ->
	erlang:system_flag(fullsweep_after,0),
	RD2 = wrq:set_resp_body({writer,{fun ?MODULE:encoder/1,fun ?MODULE:charseter/1,fun ?MODULE:read_data/1 }},RD),	
	{wrq:resp_body(RD2),RD,Ctx}.

%%
%% encode method;
%%
encoder(W)->
	W.

%%
%% charset method for datas;
%%
charseter(W)->
	W.

%%
%% stream method to handle the datas updating from clients;
%%
read_data(Writer) ->
	{ok,Fd} = file:open("/home/lucas/tes.txt",read),
	read_datas(Fd,Writer).

read_datas(Fd,Writer) ->
	Result = case file:read(Fd,16384) of
		{ok,Data1} ->
		 Data2 = erlang:list_to_binary(Data1),	
		 Writer(Data2),
		erlang:garbage_collect(self()),
		read_datas(Fd,Writer);
		eof -> 
			file:close(Fd);
		{error,_} ->
			io:format("error")
	end,
	Result.

%%
%% to handle the json request;
%%
to_json(RD, Ctx) ->
    [Meth,Select_ID] = wrq:path_tokens(RD),
    Select_ID1 = erlang:list_to_integer(Select_ID),
    mysql:prepare(post_title, <<"SELECT * FROM test1 WHERE id = ?">>),
    Results = mysql:execute(p1, post_title, [Select_ID1]),
    {data,{mysql_result, _, List, _, _ }} = Results,
    [[Id,Name,Path,Size,Hash,Createtime,Last_modify]] = List,
    List1 = [Id,erlang:binary_to_list(Name),erlang:binary_to_list(Path),Size,erlang:binary_to_list(Hash),erlang:binary_to_list(Createtime),erlang:binary_to_list(Last_modify)],
    SS = [{name,Name},{path,Path},{size,{struct,[{hash,Hash}]}},{createtime,Createtime},{last_modify,Last_modify}],
    F = [name,{struct,SS}],
    {mochijson:encode({array,F}), RD, Ctx}.

json_body(QS) -> mochijson:encode({struct, QS}).
