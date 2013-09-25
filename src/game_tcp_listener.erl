%%%-----------------------------------
%%% @Module  : game_tcp_listener
%%% @Description: tcp监听
%%%-----------------------------------
-module(game_tcp_listener).
-behaviour(gen_server).
-export([start_link/2]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).
-include("common.hrl").

start_link(AcceptorCount, Port) ->
    gen_server:start_link({local,?MODULE},?MODULE,{AcceptorCount, Port}, []).

init({AcceptorCount, Port}) ->
    process_flag(trap_exit, true), %%stop the exit signal propagating.
    case gen_tcp:listen(Port, ?TCP_OPTIONS) of
        {ok, LSock} ->
            error_logger:info_msg("game_tcp_listener gen_tcp:listen port is ~p,alloc socket is ~p ~n",[Port,LSock]),
            lists:foreach(fun (_) ->
                                {ok, _APid} = game_tcp_acceptor_sup:start_child([LSock])
                          end,
                          lists:duplicate(AcceptorCount, dummy)),
            %{ok, {LIPAddress, LPort}} = inet:sockname(LSock),
            {ok, LSock};
        {error, Reason} ->
            {stop, {cannot_listen, Reason}}
    end.

handle_call(_Request, _From, State) ->
    {reply, State, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, State) ->
    %{ok, {IPAddress, Port}} = inet:sockname(State),
    gen_tcp:close(State),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
