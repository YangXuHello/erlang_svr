-module(game_svr_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).
-include("common.hrl").

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    {ok, SupPid} = game_svr_sup:start_link().
    start_tcp(?PORT).
    {ok, SupPid}.

stop(_State) ->
    ok.

%%开启tcp listener监控树
start_tcp(Port) ->
    {ok,_} = supervisor:start_child(
               sd_sup,
               {sd_tcp_listener_sup,
                {sd_tcp_listener_sup, start_link, [Port]},
                transient, infinity, supervisor, [sd_tcp_listener_sup]}),
    ok.
