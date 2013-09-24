%%%-----------------------------------
%%% @Module  : game_tcp_player_sup
%%% @Description: 客户端服务监控树
%%%-----------------------------------
-module(game_tcp_player_sup).
-behaviour(supervisor).

%% API
-export([start_link/0,start_child/0]).

%% Supervisor callbacks
-export([init/1]).

start_child() ->
	supervisor:start_child(?MODULE,[]).

start_link() ->
    supervisor:start_link({local,?MODULE}, ?MODULE, []).

init([]) ->
    {ok, {{simple_one_for_one, 10, 10},
          [{game_player_con, {game_player_con,start_link,[]},
            temporary, brutal_kill, worker, [game_player_con]}]}}.
