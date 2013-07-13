-module(sina_mysql).

-export([insert/1]).
	
insert(Value) ->
	Id = sina_util:get_key(<<"id">>, Value),
	Name = case Id of
		false ->
			sina_log:error("get id failure");
		_ ->
			sina_util:get_key(<<"name">>, Value)
		   end,
	boss_record_compiler:compile("src/lib/user_info.erl"),
	case boss_db:find(user_info,[{id, 'equals', "user_info-"++integer_to_list(Id)}]) of
		[] ->
			Record = user_info:new(Id, sina_util:to_l(Name), null),
			{ok,_} = Record:save();
		_ ->
			ok
	end.
