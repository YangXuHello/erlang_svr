-module(game_svr_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).
-include("common.hrl").

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    {ok, SupPid} = game_svr_sup:start_link(),
    start_kernel(),
    start_player(),
    start_tcp(?PORT),
    {ok, SupPid}.

stop(_State) ->
    ok.

%%开启核心服务
start_kernel() ->
	{ok,_} = game_svr_sup:start_child(permanent,supervisor,srv_kernel,[],10000),
    ok.    

%%开启tcp listener监控树
start_tcp(Port) ->
    {ok,_} = game_svr_sup:start_child(transient,infinity,supervisor,game_tcp_listener_sup,[Port]),
    ok.

%%开启player监控树
start_player() ->
	{ok,_} = game_svr_sup:start_child(transient,infinity,supervisor,game_tcp_player_sup,[]),
    ok.
