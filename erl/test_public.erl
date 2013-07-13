-module(test_public).

-export([init/1, allowed_methods/2, content_types_accepted/2, from_json/2]).

-include("internal.hrl").
-include_lib("webmachine/include/webmachine.hrl").
-include_lib("yunio_core/include/msg_types.hrl").

-record(ctx, {
		method :: atom(),
		user :: #tbl_users{},
		app :: #tbl_applications{},
		resource :: #tbl_user_resources{},
		user_file :: #tbl_user_files{},
		link :: #tbl_public_links{},
		path = [] :: [string()]
	}).

init([]) ->
	{ok, #ctx{}}.

allowed_methods(RD, Ctx) ->
	{['PUT'], RD, Ctx}.

content_types_accepted(RD, Ctx) ->
    case wrq:get_req_header("Content-Type", RD) of
        undefined ->
            %% user must specify content type of the data
            {[], RD, Ctx};
        CType ->
            Media = hd(string:tokens(CType, ";")),
            case string:tokens(Media, "/") of
                [_Type, _Subtype] ->
                    %% accept whatever the user says
                    {[{Media, from_json}], RD, Ctx};
                _ ->
                    {[], RD, Ctx}
            end
    end.

from_json(RD, Ctx) ->
	Body = wrq:req_body(RD),
	{struct, Props} = yunio_api_wm_util:decode_json(Body),
	Res = [decode_struct(Props1) || Props1 <- Props],
%	V1 = proplists:get_value(<<"ops">>, Props),
	io:format("body is ~p ~n",[Res]),
	{<<"ok">>, RD, Ctx}.

decode_struct(Val) ->
	{_, Props} = Val,
	io:format("body1 is ~p ~n",[Props]),
	[decode_struct1(Val1) || Val1 <- Props].

decode_struct1(Val) ->
	{struct, Props} = Val,
	io:format("body2 is ~p ~n",[Props]),
	Method = proplists:get_value(<<"method">>, Props),
	Url = proplists:get_value(<<"url">>, Props),
	{Method, Url}.

