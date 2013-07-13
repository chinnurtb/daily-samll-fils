-module(http_post).
-export([connect_http/0]).

connect_http() ->
    Url = "https://10.32.0.11:8080/users/create",
    inets:start(),
	ssl:start(),
	Data = "username=lucas_lzz2&email=564985696@qq.com&password=a000000",
    F = httpc:request(post,{Url,[{"Authorization","OAuth2 Njk4Yzg0NDY2NWUyNTVhZTo0NjgxMGU4OTRhYmY4N2Vm"},{"Source","yunio_2_0_key"}],"text/plain", Data},[],[]),
    io:format("upload is over ~p ~n",[F]).
%    file:close(Fd).
