%%%--------------------------------------
%%% @Module  : event_account
%%% @Description:User account net event
%%%--------------------------------------
-module(event_account).
-export([delegate/4]).
-include("header_pb.hrl").
-include("login_pb.hrl").
-include("common.hrl").
-include("record.hrl").

%%登陆验证
delegate(loginin_require,Socket,Client,Binary) ->
    LoginIn_R = login_pb:decode_loginin_require(Binary),

    try is_pass(LoginIn_R) of
        true -> 
            ?INFO("loginin_require, accname is ~p",[LoginIn_R#loginin_require.user]),
            ClientNew = Client#client{
                    login = 1,
                    accid = LoginIn_R#loginin_require.password,
                    accname = LoginIn_R#loginin_require.user
                    },                                              
            BinData = iolist_to_binary(login_pb:encode_loginin_respond(#loginin_respond{success = true})),            
            m_send:send_one_msg(Socket,BinData,loginin_respond),
            {client,ClientNew};
        false->{false,"login failed!! is_pass unpass"}
    catch
        _:_ -> {false,"is_pass exception!"}
    end
    ;

%% 获取角色列表
delegate(role_list_require,Socket,Client,_) ->    
    case Client#client.login == 1 of
        true ->
            ?INFO("role_list_require success,accname is ~p",
                [Client#client.accname]),            
            L = m_account:get_role_list(Client#client.accname),
            ?INFO("role_list_require role ifo is ~p",[L]),

            %%first..we just use one role for test            
            MakeRoleList = 
            fun([[Pid, Status, NickName,Career] | _],N) -> 
                #role_list_respond{rolesize = N,id = Pid,nickname = NickName,career = Career};
                ([],N)->
                #role_list_respond{rolesize = 0}
            end,
            BinData = iolist_to_binary(login_pb:encode_role_list_respond(MakeRoleList(L,length(L)))),
            m_send:send_one_msg(Socket,BinData,role_list_respond);                                 
        false ->
            ?ERR("role_list_require failed!Not login,accname is ~p",
                [Client#client.accname]), 
            {false,not_login}                                               
    end
    ;

%% create 角色
delegate(create_role_require,Socket,Client,Binary) ->    
    case Client#client.login == 1 of
        true ->
            ?INFO("create_role_require ,accname is ~p",[Client#client.accname]),                        
            CreateRole_Packet = login_pb:decode_create_role_require(Binary),            
            case validate_name(CreateRole_Packet#create_role_require.nickname) of  %% 角色名合法性检测
                {false, Msg} ->
                    BinData = iolist_to_binary(login_pb:encode_create_role_respond(
                        #create_role_respond{resultcode = Msg})),
                    m_send:send_one_msg(Socket,BinData,create_role_respond);
                true ->
                    case m_account:create_role(Client#client.accid, Client#client.accname, 
                            CreateRole_Packet#create_role_require.nickname,
                            CreateRole_Packet#create_role_require.career) of
                        true ->
                            %%创建角色成功
                            ?INFO("create_role_require success!",[]),
                            BinData = iolist_to_binary(login_pb:encode_create_role_respond(
                                #create_role_respond{resultcode = 1})),
                            m_send:send_one_msg(Socket,BinData,create_role_respond);
                        false ->
                            %%角色创建失败
                            BinData = iolist_to_binary(login_pb:encode_create_role_respond(
                                #create_role_respond{resultcode = 0})),
                            m_send:send_one_msg(Socket,BinData,create_role_respond)
                    end                                
            end;                             
        false ->
            ?ERR("create_role_require failed!Not login,accname is ~p",[Client#client.accname]), 
            {false,not_login}                                               
    end
    ;


%% enter world
delegate(enter_world_require,Socket,Client,Binary) ->    
    case Client#client.login == 1 of
        true ->
            ?INFO("enter_world_require ,accname is ~p",[Client#client.accname]),
            Enter_World_Packet = login_pb:decode_enter_world_require(Binary),            
            case m_worldGate:enterWorld(start, [Enter_World_Packet#enter_world_require.id, 
                    Client#client.accname], Socket) of
                {error, fail} ->
                    %%告诉玩家登陆失败
                    ?INFO("enter_world_require failed .accname is ~p",[Client#client.accname]),
                    BinData = iolist_to_binary(login_pb:encode_enter_world_respond(
                        #enter_world_respond{resultcode = 0})),
                    m_send:send_one_msg(Socket,BinData,enter_world_respond)
                {ok, Pid} ->
                    %%告诉玩家登陆成功
                    ?INFO("enter_world_require success .accname is ~p",[Client#client.accname]),
                    BinData = iolist_to_binary(login_pb:encode_enter_world_respond(
                        #enter_world_respond{resultcode = 1})),
                    m_send:send_one_msg(Socket,BinData,enter_world_respond)
            end;                            
        false ->
            ?ERR("enter_world_require failed!Not login,accname is ~p",[Client#client.accname]), 
            {false,not_login}                                               
    end
    ;


delegate(UnKnown,_,_,_) ->    
    {false,{io:format("delegate a UnKnown Msg is ~p",[UnKnown])}}.                           
        





% handle(10002, Socket, Accname) 
%  when is_list(Accname) ->
%     L = lib_account:get_role_list(Accname),
%     {ok, BinData} = pt_10:write(10002, L),
%     lib_send:send_one(Socket, BinData);

% %% 创建角色
% handle(10003, Socket, [Accid, Accname, Realm, Career, Sex, Name])
% when is_list(Accname), is_list(Name)->
%     case validate_name(Name) of  %% 角色名合法性检测
%         {false, Msg} ->
%             {ok, BinData} = pt_10:write(10003, Msg),
%             lib_send:send_one(Socket, BinData);
%         true ->
%             case lib_account:create_role(Accid, Accname, Name, Realm, Career, Sex) of
%                 true ->
%                     %%创建角色成功
%                     {ok, BinData} = pt_10:write(10003, 1),
%                     lib_send:send_one(Socket, BinData);
%                 false ->
%                     %%角色创建失败
%                     {ok, BinData} = pt_10:write(10003, 0),
%                     lib_send:send_one(Socket, BinData)
%             end
%     end;

% %% 删除角色
% handle(10005, Socket, [Pid, Accname]) ->
%     case lib_account:delete_role(Pid, Accname) of
%         true ->
%             {ok, BinData} = pt_10:write(10005, 1),
%             lib_send:send_one(Socket, BinData);
%         false ->
%             {ok, BinData} = pt_10:write(10005, 0),
%             lib_send:send_one(Socket, BinData)
%     end;

% %%心跳包
% handle(10006, Socket, _R) ->
%     {ok, BinData} = pt_10:write(10006, []),
%     lib_send:send_one(Socket, BinData);

% handle(_Cmd, _Status, _Data) ->
%     ?DEBUG("handle_account no match", []),
%     {error, "handle_account no match"}.

%%通行证验证
is_pass(LoginIn_R) ->
    true.
    % Md5 = integer_to_list(Accid) ++ Accname ++ integer_to_list(Tstamp) ++ ?TICKET,
    % Hex = util:md5(Md5),
    % %%?DEBUG("~p~n~p~n", [Md5, Hex]),
    % Hex == Ts.

%% 角色名合法性检测
validate_name(Name) when is_list(Name)->
    validate_name(len, Name).

%% 角色名合法性检测:长度
validate_name(len, Name) ->
    case asn1rt:utf8_binary_to_list(list_to_binary(Name)) of
        {ok, CharList} ->
            Len = string_width(CharList),   
            case Len < 11 andalso Len > 1 of
                true ->
                    validate_name(existed, Name);
                false ->
                    %%角色名称长度为1~5个汉字
                    {false, 5}
            end;
        {error, _Reason} ->
            %%非法字符
            {false, 4}
    end; 

%%判断角色名是否已经存在
%%Name:角色名
validate_name(existed, Name) ->
    case m_account:is_exists(Name) of
        true ->
            %角色名称已经被使用
            {false, 3};    
        false ->
            true
    end;

validate_name(_, _Name) ->
    {false, 2}.

%% 字符宽度，1汉字=2单位长度，1数字字母=1单位长度
string_width(String) ->
    string_width(String, 0).
string_width([], Len) ->
    Len;
string_width([H | T], Len) ->
    case H > 255 of
        true ->
            string_width(T, Len + 2);
        false ->
            string_width(T, Len + 1)
    end.
