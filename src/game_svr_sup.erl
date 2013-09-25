
-module(game_svr_sup).

-behaviour(supervisor).

%% API
-export([start_link/0,start_child/5]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).


start_child(transient,infinity,supervisor,Mod, Args)->
    supervisor:start_child(?MODULE,
                              {Mod, {Mod, start_link, Args},
                              transient, infinity, supervisor, [Mod]});

start_child(permanent,supervisor,Mod,Args,Time)->
    supervisor:start_child(?MODULE,
                              {Mod, {Mod, start_link, Args},
                              permanent, Time, supervisor, [Mod]}).  

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    {ok, { {one_for_one, 5, 10}, []} }.

