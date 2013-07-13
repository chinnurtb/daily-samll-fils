-module(y_ua).

-author('lucas@yun.io').

-export([parse/1,
		satisfies/3
		]).

%%% parse the user agent to part
-spec parse(string()) -> list(any()).
parse(Str)->
	parse_choice(Str, true).

%%% check the user agent whether satisfy the given version
satisfies(UA, Str, List) ->
	List1 = parse_choice(UA,false),
	N = case query_string(List1, Str, 0) of
			ok ->
				error;
			N1 ->
				N1
		end,
	List2 = case get_string(List1, N+1, 1) of
				nothing ->
					error;
				List3 ->
					List3
			end,
	List4 = compare_string(List2, List, []),
	get_result(List4).
	

%%% ----------------------------------------------------------
%%% internal functions
%%% ----------------------------------------------------------

parse_choice(Str,N) ->
	N1 = get_pos(Str,1),
	case parse_juge(Str, N1) of
		true ->
			parse_choice1(Str, N);
		false ->
			case get_backslash_num1(Str, 0) > 1 of
					true ->
						parse6(Str,N);
					false ->
						parse4(Str,N)
			end
	end.

%%% N has two value :true ,false.
%%% according the N ,parse the string to the special formate
parse_choice1(Str,N) ->
	case get_backslash_num(Str, 0) > 4 of
		true ->
			parse3(Str, N);
		false ->
			case get_pos2(Str, 0, ";") of
				over ->
					parse2(Str, N);
				_ ->
					case get_backslash_num1(Str, 0) > 1 of
					true ->
						parse5(Str,N);
					false ->
						parse1(Str,N)
					end					
			end
	end.

%%% judge if like this "Mozilla/5.0 ArchLinux (X11; U Linux x86_64 en-US) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.60 Safari/534.30"
parse_juge([A|_Rest], N)  when N =:= 0->
	case A =:= 40 of
		true ->
			true;
		false ->
			false
	end;
parse_juge([_A|Rest], N) ->
	parse_juge(Rest, N-1).

%%% parse1 parse2 parse3 functions used to parse the List
%%% Mozilla/5.0 (X11; U Linux x86_64 en-US) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.60 Safari/534.30
parse1(Str, N) ->
	N1 = get_pos(Str,0),
	{List1,[_|List2]} = lists:split(N1, Str),
	N2 = get_pos(List2,0),
	{List3,[_|List4]} = lists:split(N2, List2),
	N3 = get_pos(List4,0),
	{List5,[_|List6]} = lists:split(N3, List4),
	N4 = get_pos(List6,0),
	{[_|List7],[_|List8]} = lists:split(N4, List6),
	N5 = get_pos(List8,0),
	{List9,[_|List10]} = lists:split(N5, List8),

	M1 = get_pos2(List1,0,"/"),
	{List1a,[_|List1b]} = lists:split(M1, List1),
	M2 = get_pos2(List3,0,";"),
	{[_|List3a],[_|List3b1]} = lists:split(M2, List3),
	[_|List3b] = remove_symbol(List3b1),
	M3 = get_pos2(List5,0,"/"),
	{List5a,[_|List5b]} = lists:split(M3, List5),
	M5 = get_pos2(List9,0,"/"),
	{List9a,[_|List9b]} = lists:split(M5, List9),
	M6 = get_pos2(List10,0,"/"),
	{List10a,[_|List10b]} = lists:split(M6, List10),
	case N of
		true ->
			[{List1a, List1b, [List3a, List3b]},{List5a, List5b, [remove_symbol(List7)]},{List9a, List9b, []},{List10a, List10b, []}];
		false ->
			[List1a, List1b, List3a, List3b, List5a, List5b, remove_symbol(List7), List9a, List9b, List10a, List10b]
	end.

%%% Mozilla/5.0 (Windows NT 6.1; en-US) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.750.0 Safari/534.30
parse2(Str,N) ->
	N1 = get_pos(Str,0),
	{List1,[_|List2]} = lists:split(N1, Str),
	N2 = get_pos(List2,0),
	{List3,[_|List4]} = lists:split(N2, List2),
	N3 = get_pos(List4,0),
	{List5,[_|List6]} = lists:split(N3, List4),
	N4 = get_pos(List6,0),
	{[_|List7],[_|List8]} = lists:split(N4, List6),
	N5 = get_pos(List8,0),
	{List9,[_|List10]} = lists:split(N5, List8),

	M1 = get_pos2(List1,0,"/"),
	{List1a,[_|List1b]} = lists:split(M1, List1),
%	M2 = get_pos2(List3,0,";"),
	[_|List3a] = remove_symbol(List3),
	M3 = get_pos2(List5,0,"/"),
	{List5a,[_|List5b]} = lists:split(M3, List5),
	M5 = get_pos2(List9,0,"/"),
	{List9a,[_|List9b]} = lists:split(M5, List9),
	M6 = get_pos2(List10,0,"/"),
	{List10a,[_|List10b]} = lists:split(M6, List10),
	case N of
		true ->
			[{List1a, List1b, [List3a]},{List5a, List5b, [remove_symbol(List7)]},{List9a, List9b, []},{List10a, List10b, []}];
		false ->
			[List1a, List1b, List3a, List5a, List5b, remove_symbol(List7), List9a, List9b, List10a, List10b]
	end.

%%% Mozilla/5.0 (X11; U; Linux x86_64; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Ubuntu/10.10 Chromium/10.0.642.0 Chrome/10.0.642.0 Safari/534.16
parse3(Str, N) ->
	N1 = get_pos(Str,0),
	{List1,[_|List2]} = lists:split(N1, Str),
	N2 = get_pos(List2,0),
	{List3,[_|List4]} = lists:split(N2, List2),
	N3 = get_pos(List4,0),
	{List5,[_|List6]} = lists:split(N3, List4),
	N4 = get_pos(List6,0),
	{[_|List7],[_|List8]} = lists:split(N4, List6),
	N5 = get_pos(List8,0),
	{List9,[_|List10]} = lists:split(N5, List8),
	N6 = get_pos(List10,0),
	{List11,[_|List12]} = lists:split(N6, List10),
	N7 = get_pos(List12,0),
	{List13,[_|List14]} = lists:split(N7, List12),

	M1 = get_pos2(List1,0,"/"),
	{List1a,[_|List1b]} = lists:split(M1, List1),
	M3 = get_pos2(List5,0,"/"),
	{List5a,[_|List5b]} = lists:split(M3, List5),
	M5 = get_pos2(List9,0,"/"),
	{List9a,[_|List9b]} = lists:split(M5, List9),
	M6 = get_pos2(List11,0,"/"),
	{List11a,[_|List11b]} = lists:split(M6, List11),
	M7 = get_pos2(List13,0,"/"),
	{List13a,[_|List13b]} = lists:split(M7, List13),
	M8 = get_pos2(List14,0,"/"),
	{List14a,[_|List14b]} = lists:split(M8, List14),
	case get_pos2(Str, 0, ";") of
		over->
			[_|Listf1] = List3,
			Listf2 = remove_symbol(Listf1),
			case N of
		true ->
			[{List1a, List1b, [Listf2]},{List5a, List5b, [remove_symbol(List7)]},{List9a, List9b, []},{List11a, List11b, []},{List13a, List13b, []},{List14a, List14b, []}];
		false ->
			[List1a, List1b, Listf2, List5a, List5b, remove_symbol(List7), List9a, List9b, List11a, List11b, List13a, List13b, List14a, List14b]
			end;
		_ ->
			M2 = get_pos2(List3,0,";"),
			{[_|List3a],[_|List3b1]} = lists:split(M2, List3),
			[_|List3b] = remove_symbol(List3b1),
			case N of
		true ->
			[{List1a, List1b, [List3a, List3b]},{List5a, List5b, [remove_symbol(List7)]},{List9a, List9b, []},{List11a, List11b, []},{List13a, List13b, []},{List14a, List14b, []}];
		false ->
			[List1a, List1b, List3a, List3b, List5a, List5b, remove_symbol(List7), List9a, List9b, List11a, List11b, List13a, List13b, List14a, List14b]
			end
	end.

%%% judge like this Mozilla/5.0 ArchLinux (X11; U; Linux x86_64; en-US) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.60 Safari/534.30
parse4(Str, N) ->
	N1 = get_pos(Str,0),
	{List1,[_|List2]} = lists:split(N1, Str),
	O = get_pos(List2,0),
	{Listp1,[_|Listp2]} = lists:split(O, List2),
	N2 = get_pos(Listp2,0),
	{List3,[_|List4]} = lists:split(N2, Listp2),
	N3 = get_pos(List4,0),
	{List5,[_|List6]} = lists:split(N3, List4),
	N4 = get_pos(List6,0),
	{[_|List7],[_|List8]} = lists:split(N4, List6),
	N5 = get_pos(List8,0),
	{List9,[_|List10]} = lists:split(N5, List8),

	M1 = get_pos2(List1,0,"/"),
	{List1a,[_|List1b]} = lists:split(M1, List1),
	M2 = get_pos2(List3,0,";"),
	{[_|List3a],[_|List3b1]} = lists:split(M2, List3),
	[_|List3b] = remove_symbol(List3b1),
	M3 = get_pos2(List5,0,"/"),
	{List5a,[_|List5b]} = lists:split(M3, List5),
	M5 = get_pos2(List9,0,"/"),
	{List9a,[_|List9b]} = lists:split(M5, List9),
	M6 = get_pos2(List10,0,"/"),
	{List10a,[_|List10b]} = lists:split(M6, List10),
	case N of
		true ->
			[{List1a, List1b, Listp1, [List3a, List3b]},{List5a, List5b, [remove_symbol(List7)]},{List9a, List9b, []},{List10a, List10b, []}];
		false ->
			[List1a, List1b, Listp1, List3a, List3b, List5a, List5b, remove_symbol(List7), List9a, List9b, List10a, List10b]
	end.

%%% Mozilla/5.0 (X11; U; Linux x86_64; en-US) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.60 Safari/534.30
parse5(Str, N) ->
	case N of
		true ->
			[L1,L2,L5,L4] = parse1(Str, N),
			{L6,L7,[L8,L3]} = L1,
			M1 = get_pos2(L3,0,";"),
			{List1a,[_|List1b]} = lists:split(M1, L3),
			M2 = get_pos2(List1b,0,";"),
			{[_|List2a],[_|[_|List2b]]} = lists:split(M2, List1b),
			[{L6,L7,[L8,List1a,List2a,List2b]},L2,L5,L4];
		false ->
			 parse1(Str,N)
	end.

%%% handle the user agent like this "Mozilla/5.0 ArchLinux (X11; U; Linux x86_64; en-US) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.60 Safari/534.30"
parse6(Str, N) ->
	case N of
		true ->
			[L1,L2,L5,L4] = parse4(Str, N),
			{L6,L7,L9,[L8,L3]} = L1,
			M1 = get_pos2(L3,0,";"),
			{List1a,[_|List1b]} = lists:split(M1, L3),
			M2 = get_pos2(List1b,0,";"),
			{[_|List2a],[_|[_|List2b]]} = lists:split(M2, List1b),
			[{L6,L7,L9,[L8,List1a,List2a,List2b]},L2,L5,L4];
		false ->
			 parse4(Str,N)
	end.

%%% get the first position of blank except the blanks in the brackets
%%% N is a number reprensent the position of the blank
-spec get_pos(string(), integer()) -> any().
get_pos([A|Rest], N) ->
	case A =:= 40 of
		true ->
			get_pos1(Rest, N+1);
		false ->
			case A =:= 32 of
				true ->
					N;
				false ->
					get_pos(Rest, N+1)
			end
	end;
get_pos([], _N)->
	over.

%%% get the position of blank in brankets
%%% N is a number represent a position
-spec get_pos1(string(), integer()) -> any().
get_pos1([A|Rest], N) when A =:= 41->
	get_pos(Rest,  N+1);
get_pos1([_A|Rest], N) ->
	get_pos1(Rest, N+1);
get_pos1([], _N) ->
	"input error".

%%% M is a string ,it's value is a symbol, N is a number represent the position of the M in the list.
%%% return the postion of M
-spec get_pos2(string(), integer(), string()) -> any().
get_pos2([A|Rest], N, M) ->
	[M1|_] = M,
	case A =:= M1 of
		true ->
			N;
		false ->
			get_pos2(Rest, N+1, M)
	end;
get_pos2([], _N, _M) ->
	over.

%%% remove the last value of the List
-spec remove_symbol(string()) -> any().
remove_symbol(List) ->
	[_|List1] = lists:reverse(List),
	lists:reverse(List1).

%%% return the total number of backslash in the List backslash
-spec get_backslash_num(string(), integer()) -> any().
get_backslash_num([A|Rest], N) ->
	case A =:= 47 of
		true ->
			get_backslash_num(Rest, N+1);
		false ->
			get_backslash_num(Rest, N)
	end;
get_backslash_num([], N)->
	N.

%%% return the total number of backslash in the List Semicolon
get_backslash_num1([A|Rest], N) ->
	case A =:= 59 of
		true ->
			get_backslash_num1(Rest, N+1);
		false ->
			get_backslash_num1(Rest, N)
	end;
get_backslash_num1([], N)->
	N.

%%% return the next position of given string in list
-spec query_string(string(),string(),integer()) -> any().
query_string([A|Rest], Str, N) ->
	case A =:= Str of
		true ->
			N+1;
		false ->
			query_string(Rest, Str, N+1)
	end;
query_string([], _Str, _N) ->
	ok.

%%% get the value of given string in list
%%% N is the return value in last function ,M contols to traversal the list
-spec get_string(string(),integer(),integer()) -> any().
get_string([A|Rest],N,M) ->
	case N =:= M of
		true ->
			A;
		false ->
			get_string(Rest,N,M+1)
	end;
get_string([],_N,_M) ->
	nothing.

%%% check if there's false in list
-spec get_result(string()) -> any().
get_result([A|Rest]) ->
	case A =:= "false" of
		true ->
			false;
		false ->
			get_result(Rest)
	end;
get_result([])->
	true.

%%% compare to the return symbol and return the result list contain "true" or "false"
-spec compare_string(string(),string(),any()) ->any().
compare_string(Str, [A|Rest], List) ->
	{Symbol, Val} = A,
	List1 = case compare_list(Str, Val) =:= Symbol of 
		true ->
			"true";
		false ->
			"false"
	end,
	compare_string(Str, Rest, [List1|List]);
compare_string(_Str, [], List) ->
	List.

%%% compare two list and return corresponding symbol
compare_list([A|Rest1], [B|Rest2]) when A == B ->
	compare_list(Rest1, Rest2);
compare_list([A|_Rest1], [B|_Rest2]) when A > B ->
	'>';
compare_list([A|_Rest1], [B|_Rest2]) when A < B ->
	'<';
compare_list([A|_Rest1], [_List2]) when A =:= 46 ->
	'<';
compare_list([_List1], [B|_Rest2]) when B =:= 46 ->
	'>';
compare_list([], [_List2]) ->
	'<';
compare_list([_List1], []) ->
	'>';
compare_list([], []) ->
	'='.

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

parse_test() ->
	Str1 = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/14.0.810.0 Safari/535.1",
	Str2 = "Mozilla/5.0 (X11; Linux i686) AppleWebKit/535.1 (KHTML, like Gecko) Ubuntu/11.04 Chromium/14.0.803.0 Chrome/14.0.803.0 Safari/535.1",
	Str3 = "Mozilla/5.0 (Windows NT 5.1) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/14.0.809.0 Safari/535.1",

	?assertEqual([{"Mozilla","5.0",["Windows NT 6.1","WOW64"]},{"AppleWebKit","535.1",["KHTML, like Gecko"]},{"Chrome","14.0.810.0",[]},{"Safari","535.1",[]}], parse(Str1)),
	?assertEqual([{"Mozilla","5.0",["Windows NT 5.1"]},{"AppleWebKit","535.1",["KHTML, like Gecko"]},{"Chrome","14.0.809.0",[]},{"Safari","535.1",[]}], parse(Str3)),
	?assertEqual([{"Mozilla","5.0",["X11","Linux i686"]},{"AppleWebKit","535.1",["KHTML, like Gecko"]},{"Ubuntu","11.04",[]},{"Chromium","14.0.803.0",[]},{"Chrome","14.0.803.0",[]},{"Safari","535.1",[]}], parse(Str2)).

satisfy_test() ->
	Str1 = "Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/13.0.782.107 Safari/535.1",
	Str2 = "Mozilla/5.0 (Windows NT 6.0) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/13.0.782.1 Safari/535.1",
	Str3 = "Mozilla/5.0 (Windows NT 6.0) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/13.0.782.1 Safari/535.1",
	?assertEqual(true,satisfies(Str1,"AppleWebKit",[{'=', "535.1"}])),
	?assertEqual(false,satisfies(Str1,"AppleWebKit",[{'>', "535.1"}])),
	?assertEqual(false,satisfies(Str2,"Chrome",[{'<', "12.0.782.1"}])),
	?assertEqual(true,satisfies(Str1,"Safari",[{'>', "535.0"}])).

-endif.
