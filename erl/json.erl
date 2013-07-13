-module(json).

-export([
        encode/1,
        decode/1
    ]).

-spec encode(term()) -> binary().
encode(Term) ->
    jiffy:encode(make_io(Term,[], true)).

-spec decode(binary()) -> term().
decode(Bin) ->
    type(format(jiffy:decode(Bin), []),[]).

%% ===================================================================
%% Internal functions
%% ===================================================================

make_io([], Acc, Type) when Type == false ->
    {lists:reverse(Acc)};
make_io([], Acc, Type) when Type == true ->
    lists:reverse(Acc);
make_io([{Key, Value} | Rest], Acc, _Type) when is_list(Value) ->
    make_io(Rest, [{Key, make_io(Value,[], true)} | Acc], false);
make_io([{Key, Value} | Rest], Acc, _Type) when is_binary(Value);
                                         is_float(Value);
                                         is_integer(Value);
                                         is_boolean(Value);
                                         Value == null ->
    make_io(Rest, [{Key, Value} | Acc], false);
make_io([{Key, undefined} | Rest], Acc, _Type) ->
    make_io(Rest, [{Key, null} | Acc], false);
make_io([{Key, Value} | Rest], Acc, _Type) ->
    make_io(Rest, [{Key, y:to_b(y:to_str(Value))} | Acc], false);
make_io([Value | Rest], Acc, Type) when is_list(Value) ->
    make_io(Rest, [make_io(Value, [], true) | Acc], Type);
make_io([KV | Rest], Acc, Type) ->
    make_io(Rest, [KV | Acc], Type).

format([], Acc) ->
	lists:reverse(Acc);
format([{Key, Value} | Rest], Acc) when is_list(Value) ->
	format(Rest, [{Key, format(Value, [])} | Acc]);
format([{Value} | Rest], Acc) ->
	format(Rest, [format(Value, []) | Acc]);
format([Value | Rest], Acc) when is_list(Value)->
	format(Rest, [format(Value, []) | Acc]);
format([Value | Rest], Acc) ->
	format(Rest, [Value | Acc]);
format({Value}, Acc) ->
	format(Value, Acc);
format(Value, _Acc) ->
	Value.

type([], Acc) ->
	lists:reverse(Acc);
type([{Key, Value} | Rest], Acc) when is_list(Value) ->
	type(Rest, [{y:to_a(Key), type(Value, [])} | Acc]);
type([{Key, Value} | Rest], Acc) ->
	type(Rest, [{y:to_a(Key), do_type(Value)} | Acc]);
type([Value | Rest], Acc) when is_list(Value)->
	type(Rest, [type(Value, []) | Acc]);
type([Value | Rest], Acc) ->
	type(Rest, [type(Value, []) | Acc]);
type(Value, _Acc) ->
	Value.

do_type(Value = <<${,_/bits>>) ->
	{ok, Token, _} = erl_scan:string(y:to_list(Value) ++ "."),
	{ok, Result} = erl_parse:parse_term(Token),
	Result;
do_type(Value) ->
	Value.


-ifdef(TEST).  
-include_lib("eunit/include/eunit.hrl").

all_test_() ->
    [
        {"decode and encode", fun proplist_case/0},
        {"special characters", fun special_chars_case/0}
    ].

proplist_case() ->
    Props1 = [{one,1},{two,"2"},{three,<<"3">>}],
    Res1 = <<"{\"one\":1,\"two\":[50],\"three\":\"3\"}">>,
    _ = ensure(Props1,Res1),
    Props2 = [[{one,1}],[{two,2}]],
    Res2 = <<"[{\"one\":1},{\"two\":2}]">>,
    _ = ensure(Props2,Res2),
    Props3 = [{one,[[{two,2}],[{three,[[[{four,4}]]]}]]}],
    Res3 = <<"{\"one\":[{\"two\":2},{\"three\":[[{\"four\":4}]]}]}">>,
    _ = ensure(Props3,Res3),
    Props4 = [[[[{one,1}]]],[{two,2}]],
    Res4 = <<"[[[{\"one\":1}]],{\"two\":2}]">>,
    _ = ensure(Props4,Res4),
    Props5 = [{one,{three,<<"element">>,tuple}}],
    Res5 = <<"{\"one\":\"{three,<<\\\"element\\\">>,tuple}\"}">>,
    Res5 = encode(Props5),
    Props6 = [{bool,true},{bool2,false}],
    Res6 = <<"{\"bool\":true,\"bool2\":false}">>,
    Res6 = encode(Props6).

special_chars_case() ->
    Props1 = [{str, <<"中文">>}],
    _ = ensure(Props1),
    Props2 = [{str, y:to_b(http_uri:encode(" /\\"))},{str2," %20"}],
    _ = ensure(Props2).

ensure(From) ->
    ensure(From, encode(From)).

ensure(From, To) ->
    To = encode(From),
    From = decode(To).

-endif.
