%%%-----------------------------------
%%% @Module  : game_tcp_acceptor
%%% @Description: tcp acceptor
%%%-----------------------------------
-module(game_tcp_acceptor).
-behaviour(gen_server).
-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).
-include("common.hrl").
-record(state, {sock, ref}).

start_link(LSock) ->
    gen_server:start_link(?MODULE, {LSock}, []).

init({LSock}) ->
    gen_server:cast(self(), accept),
    {ok, #state{sock=LSock}}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(accept, State) ->
    ?INFO("game_tcp_acceptor handle_cast(accept, State) ~n",[]),
    accept(State);

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({inet_async, LSock, Ref, {ok, Sock}}, State = #state{sock=LSock, ref=Ref}) ->
    ?INFO("game_tcp_acceptor handle_info({inet_async, LSock, Ref, {ok, Sock}},_) ~n",[]),
    case set_sockopt(LSock, Sock) of
        ok -> ok;
        {error, Reason} -> exit({set_sockopt, Reason})
    end,
    start_player(Sock),
    accept(State);

handle_info({inet_async, LSock, Ref, {error, closed}}, State=#state{sock=LSock, ref=Ref}) ->
    ?WARN("game_tcp_acceptor handle_info({inet_async, LSock, Ref, {error, closed}},_) ~n"),
    {stop, normal, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, State) ->
    ?WARN("game_tcp_acceptor terminate Reason is ~p ~n",[_Reason]),
    gen_tcp:close(State#state.sock),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%-------------私有函数--------------

set_sockopt(LSock, Sock) ->
    true = inet_db:register_socket(Sock, inet_tcp),
    case prim_inet:getopts(LSock, [active, nodelay, keepalive, delay_send, priority, tos]) of
        {ok, Opts} ->
            case prim_inet:setopts(Sock, Opts) of
                ok    -> ok;
                Error -> 
                    gen_tcp:close(Sock),
                    Error
            end;
        Error ->
            gen_tcp:close(Sock),
            Error
    end.


accept(State = #state{sock=LSock}) ->
    ?INFO("game_tcp_acceptor accept LSock is ~p ~n",[LSock]),
    case prim_inet:async_accept(LSock, -1) of
        {ok, Ref} -> {noreply, State#state{ref=Ref}};
        {error, Ref} -> {stop, {cannot_accept,  inet:format_error(Ref)}, State}        
    end.

%% 开启客户端服务
start_player(Sock) ->
    {ok, Child} = game_tcp_player_sup:start_child(),
    ok = gen_tcp:controlling_process(Sock, Child),
    Child ! {go, Sock}.