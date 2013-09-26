-module(app).

%% Application callbacks
-export([go/0]).
-include("common.hrl").

%% ===================================================================
%% Application callbacks
%% ===================================================================

go()->
	reloader:start(),
	application:start(sasl),
	application:start(game_svr).