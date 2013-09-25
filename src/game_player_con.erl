%%%-----------------------------------
%%% @Module  : game_player_con
%%% @Description: process for one player connecting
%%%-----------------------------------
-module(game_player_con).
-export([start_link/0, init/0]).
-include("common.hrl").
-include("header_pb.hrl").

-define(TCP_TIMEOUT, 1000). % 解析协议超时时间
-define(HEART_TIMEOUT, 60000). % 心跳包超时时间
-define(HEART_TIMEOUT_TIME, 0). % 心跳包超时次数
-define(HEADER_LENGTH, 8). % 消息头长度

%%记录客户端进程
-record(client, {
            player = none,
            login  = 0,
            accid  = 0,
            accname = none,
            timeout = 0 % 超时次数
     }).

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

%%接收来自客户端的数据 - 先处理登陆
%%Socket：socket id
%%Client: client记录
login_parse_packet(Socket, Client) ->
    Ref = async_recv(Socket, ?HEADER_LENGTH, ?HEART_TIMEOUT),
    receive
        %%登陆处理
        {inet_async, Socket, Ref, {ok, <<Data>>}} ->
            Pack_Header = header_pb:decode_header(Data),
            BodyLen = Pack_Header#header.len - ?HEADER_LENGTH;
            % case BodyLen > 0 of
            %     true ->
            %         Ref1 = async_recv(Socket, BodyLen, ?TCP_TIMEOUT),
            %         receive
            %            {inet_async, Socket, Ref1, {ok, Binary}} ->
            %                 case routing(Cmd, Binary) of
            %                     %%先验证登陆
            %                     {ok, login, Data} ->
            %                         case pp_account:handle(10000, [], Data) of
            %                             true ->
            %                                 [Accid, Accname, _, _] = Data,
            %                                 Client1 = Client#client{
            %                                     login = 1,
            %                                     accid = Accid,
            %                                     accname = Accname
            %                                 },
            %                                 {ok, BinData} = pt_10:write(10000, 1),
            %                                 lib_send:send_one(Socket, BinData),
            %                                 login_parse_packet(Socket, Client1);
            %                             false ->
            %                                 login_lost(Socket, Client, 0, "login fail")
            %                         end;
            %                     Other ->
            %                         login_lost(Socket, Client, 0, Other)
            %                 end;
            %             Other ->
            %                 login_lost(Socket, Client, 0, Other)
            %         end;
            %     false ->
            %         case Client#client.login == 1 of
            %             true ->
            %                 pp_account:handle(Cmd, Socket,  Client#client.accname),
            %                 login_parse_packet(Socket, Client);
            %             false ->
            %                 login_lost(Socket, Client, 0, "login fail")
            %         end
            % end;

        %%超时处理
        {inet_async, Socket, Ref, {error,timeout}} ->
            % case Client#client.timeout >= ?HEART_TIMEOUT_TIME of
            %     true ->
            %         login_lost(Socket, Client, 0, {error,timeout});
                    
            %     false ->
            %         login_parse_packet(Socket, Client#client {timeout = Client#client.timeout+1})
            % end;
            dummy;
        %%用户断开连接或出错
        Other ->
            dummy
            % login_lost(Socket, Client, 0, Other)
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
% login_lost(Socket, _Client, _Cmd, Reason) ->
%     gen_tcp:close(Socket),
%     exit({unexpected_message, Reason}).

% %%退出游戏
% do_lost(_Socket, Client, _Cmd, Reason) ->
%     mod_login:logout(Client#client.player),
%     exit({unexpected_message, Reason}).

% %%路由
% %%组成如:pt_10:read
% routing(Cmd, Binary) ->
%     %%取前面二位区分功能类型
%     %io:format("read: ~p~n",[Cmd]),
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
