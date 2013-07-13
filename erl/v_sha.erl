-module(v_sha).

-compile(export_all).

start()->
	{ok ,Data} = file:read_file("/home/lucas/testjob/erl/test.erl"),
	D = crypto:sha(Data),
        Md5_list = binary_to_list(D),
        E = lists:flatten(list_to_hex(Md5_list)),
	io:format("sha is ~p ~n", [E] ).
%       list_to_integer(K,16).

list_to_hex(L) ->
        lists:map(fun(X) -> int_to_hex(X) end, L).

int_to_hex(N) when N < 256 ->
        [hex(N div 16), hex(N rem 16)].

hex(N) when N < 10 ->
        $0+N;
hex(N) when N >= 10, N < 16 ->
        $a + (N-10).
	
