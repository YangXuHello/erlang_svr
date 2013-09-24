%%%-----------------------------------
%%% @Module  : game_tcp_listener_sup
%%% @Description: tcp connect listener supervisor
%%%-----------------------------------

-module(game_tcp_listener_sup).

-behaviour(supervisor).

-export([start_link/1]).

-export([init/1]).

start_link(Port) ->
    supervisor:start_link(?MODULE, {10, Port}).

init({AcceptorCount, Port}) ->
    {ok,
        {{one_for_all, 10, 10},
            [
                {
                    game_tcp_acceptor_sup,
                    {game_tcp_acceptor_sup, start_link, []},
                    transient,
                    infinity,
                    supervisor,
                    [game_tcp_acceptor_sup]
                },
                {
                    game_tcp_listener,
                    {game_tcp_listener, start_link, [AcceptorCount, Port]},
                    transient,
                    100,
                    worker,
                    [game_tcp_listener]
                }
            ]
        }
    }.
