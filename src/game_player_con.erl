%%%-----------------------------------
%%% @Module  : game_player_con
%%% @Description: process for one player connecting
%%%-----------------------------------
-module(game_player_con).
-export([start_link/0, init/0]).
-include("common.hrl").
-include("header_pb.hrl").
-include("login_pb.hrl").
-include("record.hrl").

-define(TCP_TIMEOUT, 1000). % 解析协议超时时间
-define(HEART_TIMEOUT, 60000). % 心跳包超时时间
-define(HEART_TIMEOUT_TIME, 10). % 心跳包超时次数
-define(HEADER_LENGTH, 10). % 消息头长度


start_link() ->
    {ok, proc_lib:spawn_link(?MODULE, init, [])}.

%%gen_server init
%%Host:主机IP
%%Port:端口
init() ->
    process_flag(trap_exit, true),
    Client = #client{
                player = none,
                login  = 0,
                accid  = 0,
                accname = none,
                timeout = 0 
            },
    receive
        {go, Socket} ->
            login_parse_packet(Socket, Client)
    end.

parse_cmd(Cmd,BodyLen,Socket,Client) when is_atom(Cmd)->
    case BodyLen > 0 of
        true ->
            RefBody = async_recv(Socket, BodyLen, ?TCP_TIMEOUT),
            receive
                {inet_async, Socket, RefBody, {ok, Binary}} ->
                    case event_account:delegate(Cmd,Socket,Client,Binary) of
                        {false,Reason} ->
                            login_lost(Socket, Client, 0, Reason);
                        {client,ClientNew} ->
                            login_parse_packet(Socket,ClientNew);                          
                        _ -> ok                                                                                                                                                        
                    end
            end;                    
        false ->
            case event_account:delegate(Cmd,Socket,Client,<<>>) of
                {false,Reason} ->
                    login_lost(Socket, Client, 0, Reason);      
                _ -> ok                                                                                                                         
            end
    end
;

parse_cmd(Cmd,BodyLen,Socket,Client)->
    login_lost(Socket, Client, 0, "Packet Type Can Not Be Parse.It's not a atom").  

%%接收来自客户端的数据 - 先处理登陆
%%Socket：socket id
%%Client: client记录
login_parse_packet(Socket, Client) ->
    ?INFO("game_player_con login_parse_packet recv msg Socket is ~p ~n",[Socket]),
    Ref = async_recv(Socket, ?HEADER_LENGTH, ?HEART_TIMEOUT),  
    receive
        %%登陆处理
        {inet_async, Socket, Ref, {ok, Data}} ->           
            Pack_Header = header_pb:decode_header(Data),
            %<<Type:16,Len:16>> = Pack_Header#header.info,
            ?INFO("game_player_con login_parse_packet rev a pack type is ~p,size is ~p~n",
                [Pack_Header#header.type,Pack_Header#header.size]),
            BodyLen = Pack_Header#header.size,
            Cmd = msg_trans:int_to_enum(msgtype, Pack_Header#header.type),

            parse_cmd(Cmd,BodyLen,Socket,Client),%%parse packet

            login_parse_packet(Socket,Client);
        %%超时处理
        {inet_async, Socket, Ref, {error,timeout}} ->
            ?INFO("game_player_con login_parse_packet {inet_async, Socket, Ref, {error,timeout is ~p}}",
                [Client#client.timeout+1]),
            case Client#client.timeout >= ?HEART_TIMEOUT_TIME of
                true ->
                    login_lost(Socket, Client, 0, {error,timeout});
                    
                false ->
                    login_parse_packet(Socket, Client#client {timeout = Client#client.timeout+1})
            end;            
        %%用户断开连接或出错
        Other ->
            ?INFO("game_player_con login_parse_packet Other is ~p~n!",[Other]),           
            login_lost(Socket, Client, 0, Other)
    end.

% %%接收来自客户端的数据 - 登陆后进入游戏逻辑
% %%Socket：socket id
% %%Client: client记录
% do_parse_packet(Socket, Client) ->
%     Ref = async_recv(Socket, ?HEADER_LENGTH, ?HEART_TIMEOUT),
%     receive
%         {inet_async, Socket, Ref, {ok, <<Len:16, Cmd:16>>}} ->
%             BodyLen = Len - ?HEADER_LENGTH,
%             case BodyLen > 0 of
%                 true ->
%                     Ref1 = async_recv(Socket, BodyLen, ?TCP_TIMEOUT),
%                     receive
%                        {inet_async, Socket, Ref1, {ok, Binary}} ->
%                             case routing(Cmd, Binary) of
%                                 %%这里是处理游戏逻辑
%                                 {ok, Data} ->
%                                     case catch gen:call(Client#client.player, '$gen_call', {'SOCKET_EVENT', Cmd, Data}) of
%                                         {ok,_Res} ->
%                                             do_parse_packet(Socket, Client);
%                                         {'EXIT',Reason} ->
%                                              do_lost(Socket, Client, Cmd, Reason)
%                                     end;
%                                 Other ->
%                                     do_lost(Socket, Client, Cmd, Other)
%                             end;
%                          Other ->
%                             do_lost(Socket, Client, Cmd, Other)
%                     end;
%                 false ->
%                     case routing(Cmd, <<>>) of
%                         %%这里是处理游戏逻辑
%                         {ok, Data} ->
%                             case catch gen:call(Client#client.player, '$gen_call', {'SOCKET_EVENT', Cmd, Data}, 3000) of
%                                 {ok,_Res} ->
%                                     do_parse_packet(Socket, Client);
%                                 {'EXIT',Reason} ->
%                                     do_lost(Socket, Client, Cmd, Reason)
%                             end;
%                         Other ->
%                             do_lost(Socket, Client, Cmd, Other)
%                     end
%             end;

%         %%超时处理
%         {inet_async, Socket, Ref, {error,timeout}} ->
%             case Client#client.timeout >= ?HEART_TIMEOUT_TIME of
%                 true ->
%                     do_lost(Socket, Client, 0, {error,timeout});
%                 false ->
%                     do_parse_packet(Socket, Client#client {timeout = Client#client.timeout+1})            
%             end;
            
%         %%用户断开连接或出错
%         Other ->
%             do_lost(Socket, Client, 0, Other)
%     end.

% %%断开连接
login_lost(Socket, _Client, _Cmd, Reason) ->    
    gen_tcp:close(Socket),
    ?WARN("login_lost,socket closed!.player pid will end...reason is [~p]",[Reason]),
    exit({unexpected_message, Reason}).

% %%退出游戏
% do_lost(_Socket, Client, _Cmd, Reason) ->
%     mod_login:logout(Client#client.player),
%     exit({unexpected_message, Reason}).

% %%路由
% routing(Cmd, Binary) ->
%     [H1, H2, _, _, _] = integer_to_list(Cmd),
%     Module = list_to_atom("pt_"++[H1,H2]),
%     Module:read(Cmd, Binary).

%% 接受信息
async_recv(Sock, Length, Timeout) when is_port(Sock) ->
    case prim_inet:async_recv(Sock, Length, Timeout) of
        {error, Reason} -> throw({Reason});
        {ok, Res}       -> Res;
        Res             -> Res
    end.
