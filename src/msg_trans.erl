-module(msg_trans).

%% Application callbacks
-export([int_to_enum/2,enum_to_int/2]).

%% ===================================================================
%% Application callbacks
%% ===================================================================


%% copy from header_pb.erl
enum_to_int(msgtype, leave_world_respond) -> 11;
enum_to_int(msgtype, leave_world_require) -> 10;
enum_to_int(msgtype, enter_world_respond) -> 9;
enum_to_int(msgtype, enter_world_require) -> 8;
enum_to_int(msgtype, notify_sec_loginin) -> 7;
enum_to_int(msgtype, create_role_respond) -> 6;
enum_to_int(msgtype, create_role_require) -> 5;
enum_to_int(msgtype, role_list_respond) -> 4;
enum_to_int(msgtype, role_list_require) -> 3;
enum_to_int(msgtype, loginin_respond) -> 2;
enum_to_int(msgtype, loginin_require) -> 1.

int_to_enum(msgtype, 11) -> leave_world_respond;
int_to_enum(msgtype, 10) -> leave_world_require;
int_to_enum(msgtype, 9) -> enter_world_respond;
int_to_enum(msgtype, 8) -> enter_world_require;
int_to_enum(msgtype, 7) -> notify_sec_loginin;
int_to_enum(msgtype, 6) -> create_role_respond;
int_to_enum(msgtype, 5) -> create_role_require;
int_to_enum(msgtype, 4) -> role_list_respond;
int_to_enum(msgtype, 3) -> role_list_require;
int_to_enum(msgtype, 2) -> loginin_respond;
int_to_enum(msgtype, 1) -> loginin_require;
int_to_enum(_, Val) -> Val.