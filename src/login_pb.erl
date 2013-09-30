-file("src/login_pb.erl", 1).

-module(login_pb).

-export([encode_leave_world_respond/1,
	 decode_leave_world_respond/1,
	 delimited_decode_leave_world_respond/1,
	 encode_leave_world_require/1,
	 decode_leave_world_require/1,
	 delimited_decode_leave_world_require/1,
	 encode_enter_world_respond/1,
	 decode_enter_world_respond/1,
	 delimited_decode_enter_world_respond/1,
	 encode_enter_world_require/1,
	 decode_enter_world_require/1,
	 delimited_decode_enter_world_require/1,
	 encode_notify_sec_loginin/1,
	 decode_notify_sec_loginin/1,
	 delimited_decode_notify_sec_loginin/1,
	 encode_create_role_respond/1,
	 decode_create_role_respond/1,
	 delimited_decode_create_role_respond/1,
	 encode_create_role_require/1,
	 decode_create_role_require/1,
	 delimited_decode_create_role_require/1,
	 encode_role_list_respond/1, decode_role_list_respond/1,
	 delimited_decode_role_list_respond/1,
	 encode_role_list_require/1, decode_role_list_require/1,
	 delimited_decode_role_list_require/1,
	 encode_loginin_respond/1, decode_loginin_respond/1,
	 delimited_decode_loginin_respond/1,
	 encode_loginin_require/1, decode_loginin_require/1,
	 delimited_decode_loginin_require/1]).

-export([has_extension/2, extension_size/1,
	 get_extension/2, set_extension/3]).

-export([decode_extensions/1]).

-export([encode/1, decode/2, delimited_decode/2]).

-record(leave_world_respond, {}).

-record(leave_world_require, {}).

-record(enter_world_respond, {resultcode}).

-record(enter_world_require, {id}).

-record(notify_sec_loginin, {}).

-record(create_role_respond, {resultcode}).

-record(create_role_require, {nickname, career}).

-record(role_list_respond,
	{rolesize, id, nickname, career}).

-record(role_list_require, {}).

-record(loginin_respond, {success}).

-record(loginin_require, {user, password}).

encode([]) -> [];
encode(Records) when is_list(Records) ->
    delimited_encode(Records);
encode(Record) -> encode(element(1, Record), Record).

encode_leave_world_respond(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_leave_world_respond(Record)
    when is_record(Record, leave_world_respond) ->
    encode(leave_world_respond, Record).

encode_leave_world_require(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_leave_world_require(Record)
    when is_record(Record, leave_world_require) ->
    encode(leave_world_require, Record).

encode_enter_world_respond(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_enter_world_respond(Record)
    when is_record(Record, enter_world_respond) ->
    encode(enter_world_respond, Record).

encode_enter_world_require(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_enter_world_require(Record)
    when is_record(Record, enter_world_require) ->
    encode(enter_world_require, Record).

encode_notify_sec_loginin(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_notify_sec_loginin(Record)
    when is_record(Record, notify_sec_loginin) ->
    encode(notify_sec_loginin, Record).

encode_create_role_respond(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_create_role_respond(Record)
    when is_record(Record, create_role_respond) ->
    encode(create_role_respond, Record).

encode_create_role_require(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_create_role_require(Record)
    when is_record(Record, create_role_require) ->
    encode(create_role_require, Record).

encode_role_list_respond(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_role_list_respond(Record)
    when is_record(Record, role_list_respond) ->
    encode(role_list_respond, Record).

encode_role_list_require(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_role_list_require(Record)
    when is_record(Record, role_list_require) ->
    encode(role_list_require, Record).

encode_loginin_respond(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_loginin_respond(Record)
    when is_record(Record, loginin_respond) ->
    encode(loginin_respond, Record).

encode_loginin_require(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_loginin_require(Record)
    when is_record(Record, loginin_require) ->
    encode(loginin_require, Record).

encode(loginin_require, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(loginin_require, Record) ->
    [iolist(loginin_require, Record)
     | encode_extensions(Record)];
encode(loginin_respond, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(loginin_respond, Record) ->
    [iolist(loginin_respond, Record)
     | encode_extensions(Record)];
encode(role_list_require, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(role_list_require, Record) ->
    [iolist(role_list_require, Record)
     | encode_extensions(Record)];
encode(role_list_respond, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(role_list_respond, Record) ->
    [iolist(role_list_respond, Record)
     | encode_extensions(Record)];
encode(create_role_require, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(create_role_require, Record) ->
    [iolist(create_role_require, Record)
     | encode_extensions(Record)];
encode(create_role_respond, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(create_role_respond, Record) ->
    [iolist(create_role_respond, Record)
     | encode_extensions(Record)];
encode(notify_sec_loginin, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(notify_sec_loginin, Record) ->
    [iolist(notify_sec_loginin, Record)
     | encode_extensions(Record)];
encode(enter_world_require, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(enter_world_require, Record) ->
    [iolist(enter_world_require, Record)
     | encode_extensions(Record)];
encode(enter_world_respond, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(enter_world_respond, Record) ->
    [iolist(enter_world_respond, Record)
     | encode_extensions(Record)];
encode(leave_world_require, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(leave_world_require, Record) ->
    [iolist(leave_world_require, Record)
     | encode_extensions(Record)];
encode(leave_world_respond, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(leave_world_respond, Record) ->
    [iolist(leave_world_respond, Record)
     | encode_extensions(Record)].

encode_extensions(_) -> [].

delimited_encode(Records) ->
    lists:map(fun (Record) ->
		      IoRec = encode(Record),
		      Size = iolist_size(IoRec),
		      [protobuffs:encode_varint(Size), IoRec]
	      end,
	      Records).

iolist(loginin_require, Record) ->
    [pack(1, optional,
	  with_default(Record#loginin_require.user, none), string,
	  []),
     pack(2, optional,
	  with_default(Record#loginin_require.password, none),
	  string, [])];
iolist(loginin_respond, Record) ->
    [pack(1, optional,
	  with_default(Record#loginin_respond.success, none),
	  bool, [])];
iolist(role_list_require, _Record) -> [];
iolist(role_list_respond, Record) ->
    [pack(1, optional,
	  with_default(Record#role_list_respond.rolesize, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#role_list_respond.id, none), int32,
	  []),
     pack(3, optional,
	  with_default(Record#role_list_respond.nickname, none),
	  string, []),
     pack(4, optional,
	  with_default(Record#role_list_respond.career, none),
	  int32, [])];
iolist(create_role_require, Record) ->
    [pack(1, optional,
	  with_default(Record#create_role_require.nickname, none),
	  string, []),
     pack(2, optional,
	  with_default(Record#create_role_require.career, none),
	  int32, [])];
iolist(create_role_respond, Record) ->
    [pack(1, optional,
	  with_default(Record#create_role_respond.resultcode,
		       none),
	  int32, [])];
iolist(notify_sec_loginin, _Record) -> [];
iolist(enter_world_require, Record) ->
    [pack(1, optional,
	  with_default(Record#enter_world_require.id, none),
	  int32, [])];
iolist(enter_world_respond, Record) ->
    [pack(1, optional,
	  with_default(Record#enter_world_respond.resultcode,
		       none),
	  int32, [])];
iolist(leave_world_require, _Record) -> [];
iolist(leave_world_respond, _Record) -> [].

with_default(Default, Default) -> undefined;
with_default(Val, _) -> Val.

pack(_, optional, undefined, _, _) -> [];
pack(_, repeated, undefined, _, _) -> [];
pack(_, repeated_packed, undefined, _, _) -> [];
pack(_, repeated_packed, [], _, _) -> [];
pack(FNum, required, undefined, Type, _) ->
    exit({error,
	  {required_field_is_undefined, FNum, Type}});
pack(_, repeated, [], _, Acc) -> lists:reverse(Acc);
pack(FNum, repeated, [Head | Tail], Type, Acc) ->
    pack(FNum, repeated, Tail, Type,
	 [pack(FNum, optional, Head, Type, []) | Acc]);
pack(FNum, repeated_packed, Data, Type, _) ->
    protobuffs:encode_packed(FNum, Data, Type);
pack(FNum, _, Data, _, _) when is_tuple(Data) ->
    [RecName | _] = tuple_to_list(Data),
    protobuffs:encode(FNum, encode(RecName, Data), bytes);
pack(FNum, _, Data, Type, _)
    when Type =:= bool;
	 Type =:= int32;
	 Type =:= uint32;
	 Type =:= int64;
	 Type =:= uint64;
	 Type =:= sint32;
	 Type =:= sint64;
	 Type =:= fixed32;
	 Type =:= sfixed32;
	 Type =:= fixed64;
	 Type =:= sfixed64;
	 Type =:= string;
	 Type =:= bytes;
	 Type =:= float;
	 Type =:= double ->
    protobuffs:encode(FNum, Data, Type);
pack(FNum, _, Data, Type, _) when is_atom(Data) ->
    protobuffs:encode(FNum, enum_to_int(Type, Data), enum).

enum_to_int(pikachu, value) -> 1.

int_to_enum(_, Val) -> Val.

decode_leave_world_respond(Bytes)
    when is_binary(Bytes) ->
    decode(leave_world_respond, Bytes).

decode_leave_world_require(Bytes)
    when is_binary(Bytes) ->
    decode(leave_world_require, Bytes).

decode_enter_world_respond(Bytes)
    when is_binary(Bytes) ->
    decode(enter_world_respond, Bytes).

decode_enter_world_require(Bytes)
    when is_binary(Bytes) ->
    decode(enter_world_require, Bytes).

decode_notify_sec_loginin(Bytes)
    when is_binary(Bytes) ->
    decode(notify_sec_loginin, Bytes).

decode_create_role_respond(Bytes)
    when is_binary(Bytes) ->
    decode(create_role_respond, Bytes).

decode_create_role_require(Bytes)
    when is_binary(Bytes) ->
    decode(create_role_require, Bytes).

decode_role_list_respond(Bytes) when is_binary(Bytes) ->
    decode(role_list_respond, Bytes).

decode_role_list_require(Bytes) when is_binary(Bytes) ->
    decode(role_list_require, Bytes).

decode_loginin_respond(Bytes) when is_binary(Bytes) ->
    decode(loginin_respond, Bytes).

decode_loginin_require(Bytes) when is_binary(Bytes) ->
    decode(loginin_require, Bytes).

delimited_decode_loginin_require(Bytes) ->
    delimited_decode(loginin_require, Bytes).

delimited_decode_loginin_respond(Bytes) ->
    delimited_decode(loginin_respond, Bytes).

delimited_decode_role_list_require(Bytes) ->
    delimited_decode(role_list_require, Bytes).

delimited_decode_role_list_respond(Bytes) ->
    delimited_decode(role_list_respond, Bytes).

delimited_decode_create_role_require(Bytes) ->
    delimited_decode(create_role_require, Bytes).

delimited_decode_create_role_respond(Bytes) ->
    delimited_decode(create_role_respond, Bytes).

delimited_decode_notify_sec_loginin(Bytes) ->
    delimited_decode(notify_sec_loginin, Bytes).

delimited_decode_enter_world_require(Bytes) ->
    delimited_decode(enter_world_require, Bytes).

delimited_decode_enter_world_respond(Bytes) ->
    delimited_decode(enter_world_respond, Bytes).

delimited_decode_leave_world_require(Bytes) ->
    delimited_decode(leave_world_require, Bytes).

delimited_decode_leave_world_respond(Bytes) ->
    delimited_decode(leave_world_respond, Bytes).

delimited_decode(Type, Bytes) when is_binary(Bytes) ->
    delimited_decode(Type, Bytes, []).

delimited_decode(_Type, <<>>, Acc) ->
    {lists:reverse(Acc), <<>>};
delimited_decode(Type, Bytes, Acc) ->
    try protobuffs:decode_varint(Bytes) of
      {Size, Rest} when size(Rest) < Size ->
	  {lists:reverse(Acc), Bytes};
      {Size, Rest} ->
	  <<MessageBytes:Size/binary, Rest2/binary>> = Rest,
	  Message = decode(Type, MessageBytes),
	  delimited_decode(Type, Rest2, [Message | Acc])
    catch
      _What:_Why -> {lists:reverse(Acc), Bytes}
    end.

decode(enummsg_values, 1) -> value1;
decode(loginin_require, Bytes) when is_binary(Bytes) ->
    Types = [{2, password, string, []},
	     {1, user, string, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(loginin_require, Decoded);
decode(loginin_respond, Bytes) when is_binary(Bytes) ->
    Types = [{1, success, bool, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(loginin_respond, Decoded);
decode(role_list_require, Bytes)
    when is_binary(Bytes) ->
    Types = [],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(role_list_require, Decoded);
decode(role_list_respond, Bytes)
    when is_binary(Bytes) ->
    Types = [{4, career, int32, []},
	     {3, nickname, string, []}, {2, id, int32, []},
	     {1, rolesize, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(role_list_respond, Decoded);
decode(create_role_require, Bytes)
    when is_binary(Bytes) ->
    Types = [{2, career, int32, []},
	     {1, nickname, string, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(create_role_require, Decoded);
decode(create_role_respond, Bytes)
    when is_binary(Bytes) ->
    Types = [{1, resultcode, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(create_role_respond, Decoded);
decode(notify_sec_loginin, Bytes)
    when is_binary(Bytes) ->
    Types = [],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(notify_sec_loginin, Decoded);
decode(enter_world_require, Bytes)
    when is_binary(Bytes) ->
    Types = [{1, id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(enter_world_require, Decoded);
decode(enter_world_respond, Bytes)
    when is_binary(Bytes) ->
    Types = [{1, resultcode, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(enter_world_respond, Decoded);
decode(leave_world_require, Bytes)
    when is_binary(Bytes) ->
    Types = [],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(leave_world_require, Decoded);
decode(leave_world_respond, Bytes)
    when is_binary(Bytes) ->
    Types = [],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(leave_world_respond, Decoded).

decode(<<>>, Types, Acc) ->
    reverse_repeated_fields(Acc, Types);
decode(Bytes, Types, Acc) ->
    {ok, FNum} = protobuffs:next_field_num(Bytes),
    case lists:keyfind(FNum, 1, Types) of
      {FNum, Name, Type, Opts} ->
	  {Value1, Rest1} = case lists:member(is_record, Opts) of
			      true ->
				  {{FNum, V}, R} = protobuffs:decode(Bytes,
								     bytes),
				  RecVal = decode(Type, V),
				  {RecVal, R};
			      false ->
				  case lists:member(repeated_packed, Opts) of
				    true ->
					{{FNum, V}, R} =
					    protobuffs:decode_packed(Bytes,
								     Type),
					{V, R};
				    false ->
					{{FNum, V}, R} =
					    protobuffs:decode(Bytes, Type),
					{unpack_value(V, Type), R}
				  end
			    end,
	  case lists:member(repeated, Opts) of
	    true ->
		case lists:keytake(FNum, 1, Acc) of
		  {value, {FNum, Name, List}, Acc1} ->
		      decode(Rest1, Types,
			     [{FNum, Name, [int_to_enum(Type, Value1) | List]}
			      | Acc1]);
		  false ->
		      decode(Rest1, Types,
			     [{FNum, Name, [int_to_enum(Type, Value1)]} | Acc])
		end;
	    false ->
		decode(Rest1, Types,
		       [{FNum, Name, int_to_enum(Type, Value1)} | Acc])
	  end;
      false ->
	  case lists:keyfind('$extensions', 2, Acc) of
	    {_, _, Dict} ->
		{{FNum, _V}, R} = protobuffs:decode(Bytes, bytes),
		Diff = size(Bytes) - size(R),
		<<V:Diff/binary, _/binary>> = Bytes,
		NewDict = dict:store(FNum, V, Dict),
		NewAcc = lists:keyreplace('$extensions', 2, Acc,
					  {false, '$extensions', NewDict}),
		decode(R, Types, NewAcc);
	    _ ->
		{ok, Skipped} = protobuffs:skip_next_field(Bytes),
		decode(Skipped, Types, Acc)
	  end
    end.

reverse_repeated_fields(FieldList, Types) ->
    [begin
       case lists:keyfind(FNum, 1, Types) of
	 {FNum, Name, _Type, Opts} ->
	     case lists:member(repeated, Opts) of
	       true -> {FNum, Name, lists:reverse(Value)};
	       _ -> Field
	     end;
	 _ -> Field
       end
     end
     || {FNum, Name, Value} = Field <- FieldList].

unpack_value(Binary, string) when is_binary(Binary) ->
    binary_to_list(Binary);
unpack_value(Value, _) -> Value.

to_record(loginin_require, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       loginin_require),
						   Record, Name, Val)
			  end,
			  #loginin_require{}, DecodedTuples),
    Record1;
to_record(loginin_respond, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       loginin_respond),
						   Record, Name, Val)
			  end,
			  #loginin_respond{}, DecodedTuples),
    Record1;
to_record(role_list_require, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       role_list_require),
						   Record, Name, Val)
			  end,
			  #role_list_require{}, DecodedTuples),
    Record1;
to_record(role_list_respond, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       role_list_respond),
						   Record, Name, Val)
			  end,
			  #role_list_respond{}, DecodedTuples),
    Record1;
to_record(create_role_require, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       create_role_require),
						   Record, Name, Val)
			  end,
			  #create_role_require{}, DecodedTuples),
    Record1;
to_record(create_role_respond, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       create_role_respond),
						   Record, Name, Val)
			  end,
			  #create_role_respond{}, DecodedTuples),
    Record1;
to_record(notify_sec_loginin, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       notify_sec_loginin),
						   Record, Name, Val)
			  end,
			  #notify_sec_loginin{}, DecodedTuples),
    Record1;
to_record(enter_world_require, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       enter_world_require),
						   Record, Name, Val)
			  end,
			  #enter_world_require{}, DecodedTuples),
    Record1;
to_record(enter_world_respond, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       enter_world_respond),
						   Record, Name, Val)
			  end,
			  #enter_world_respond{}, DecodedTuples),
    Record1;
to_record(leave_world_require, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       leave_world_require),
						   Record, Name, Val)
			  end,
			  #leave_world_require{}, DecodedTuples),
    Record1;
to_record(leave_world_respond, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       leave_world_respond),
						   Record, Name, Val)
			  end,
			  #leave_world_respond{}, DecodedTuples),
    Record1.

decode_extensions(Record) -> Record.

decode_extensions(_Types, [], Acc) ->
    dict:from_list(Acc);
decode_extensions(Types, [{Fnum, Bytes} | Tail], Acc) ->
    NewAcc = case lists:keyfind(Fnum, 1, Types) of
	       {Fnum, Name, Type, Opts} ->
		   {Value1, Rest1} = case lists:member(is_record, Opts) of
				       true ->
					   {{FNum, V}, R} =
					       protobuffs:decode(Bytes, bytes),
					   RecVal = decode(Type, V),
					   {RecVal, R};
				       false ->
					   case lists:member(repeated_packed,
							     Opts)
					       of
					     true ->
						 {{FNum, V}, R} =
						     protobuffs:decode_packed(Bytes,
									      Type),
						 {V, R};
					     false ->
						 {{FNum, V}, R} =
						     protobuffs:decode(Bytes,
								       Type),
						 {unpack_value(V, Type), R}
					   end
				     end,
		   case lists:member(repeated, Opts) of
		     true ->
			 case lists:keytake(FNum, 1, Acc) of
			   {value, {FNum, Name, List}, Acc1} ->
			       decode(Rest1, Types,
				      [{FNum, Name,
					lists:reverse([int_to_enum(Type, Value1)
						       | lists:reverse(List)])}
				       | Acc1]);
			   false ->
			       decode(Rest1, Types,
				      [{FNum, Name, [int_to_enum(Type, Value1)]}
				       | Acc])
			 end;
		     false ->
			 [{Fnum,
			   {optional, int_to_enum(Type, Value1), Type, Opts}}
			  | Acc]
		   end;
	       false -> [{Fnum, Bytes} | Acc]
	     end,
    decode_extensions(Types, Tail, NewAcc).

set_record_field(Fields, Record, '$extensions',
		 Value) ->
    Decodable = [],
    NewValue = decode_extensions(element(1, Record),
				 Decodable, dict:to_list(Value)),
    Index = list_index('$extensions', Fields),
    erlang:setelement(Index + 1, Record, NewValue);
set_record_field(Fields, Record, Field, Value) ->
    Index = list_index(Field, Fields),
    erlang:setelement(Index + 1, Record, Value).

list_index(Target, List) -> list_index(Target, List, 1).

list_index(Target, [Target | _], Index) -> Index;
list_index(Target, [_ | Tail], Index) ->
    list_index(Target, Tail, Index + 1);
list_index(_, [], _) -> -1.

extension_size(_) -> 0.

has_extension(_Record, _FieldName) -> false.

get_extension(_Record, _FieldName) -> undefined.

set_extension(Record, _, _) -> {error, Record}.

