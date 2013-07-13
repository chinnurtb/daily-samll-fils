-module(sina_web_index_controller, [Req]).
-compile(export_all).
 
index('GET', []) ->
    {ok, []}.

login('POST', []) ->
	Code = Req:post_param("code"),
	ScreenName = Req:post_param("screen_name"),
	Token = sina_oauth:oauth([{code, Code}]),
	yunio_util:set_session(Req, "xtoken", Token),
	Value = sina_user:info([{screen_name, "lucas-lzz"}]),
	sina_mysql:insert(Value),
	{redirect, "/account"}.

attention('POST', []) ->
	AccessToken = sina_util:to_l(y_util:get_session(Req, "xtoken")),
	io:format("token ~p~n",[AccessToken]),
	ScreenName = Req:post_param("screen_name"),
	{json,sina_friendship:create([{access_token,AccessToken},{screen_name, ScreenName}])}.

send('POST', []) ->
	AccessToken = sina_util:to_l(yunio_util:get_session(Req, "xtoken")),
	Status = Req:post_param("status"),
	{output,io_lib:format("~s",[sina_blog:blog([{access_token,AccessToken},{status, Status}])])}.
	
