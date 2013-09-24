%%%-----------------------------------
%%% @Module  : game_tcp_acceptor_sup
%%% @Description: tcp acceptor 监控树
%%%-----------------------------------
-module(game_tcp_acceptor_sup).
-behaviour(supervisor).

-export([start_child/1]).

-export([start_link/0, init/1]).

start_child(LSock)->
	supervisor:start_child(?MODULE, [LSock]).

start_link() ->
    supervisor:start_link({local,?MODULE}, ?MODULE, []).

init([]) ->
    {ok, {{simple_one_for_one, 10, 10},
          [{game_tcp_acceptor, {game_tcp_acceptor, start_link, []},
            transient, brutal_kill, worker, [game_tcp_acceptor]}]}}.
