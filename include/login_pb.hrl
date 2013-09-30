-ifndef(LOGININ_REQUIRE_PB_H).
-define(LOGININ_REQUIRE_PB_H, true).
-record(loginin_require, {
    user,
    password
}).
-endif.

-ifndef(LOGININ_RESPOND_PB_H).
-define(LOGININ_RESPOND_PB_H, true).
-record(loginin_respond, {
    success
}).
-endif.

-ifndef(ROLE_LIST_REQUIRE_PB_H).
-define(ROLE_LIST_REQUIRE_PB_H, true).
-record(role_list_require, {
    
}).
-endif.

-ifndef(ROLE_LIST_RESPOND_PB_H).
-define(ROLE_LIST_RESPOND_PB_H, true).
-record(role_list_respond, {
    rolesize,
    id,
    nickname,
    career
}).
-endif.

-ifndef(CREATE_ROLE_REQUIRE_PB_H).
-define(CREATE_ROLE_REQUIRE_PB_H, true).
-record(create_role_require, {
    nickname,
    career
}).
-endif.

-ifndef(CREATE_ROLE_RESPOND_PB_H).
-define(CREATE_ROLE_RESPOND_PB_H, true).
-record(create_role_respond, {
    resultcode
}).
-endif.

-ifndef(NOTIFY_SEC_LOGININ_PB_H).
-define(NOTIFY_SEC_LOGININ_PB_H, true).
-record(notify_sec_loginin, {
    
}).
-endif.

-ifndef(ENTER_WORLD_REQUIRE_PB_H).
-define(ENTER_WORLD_REQUIRE_PB_H, true).
-record(enter_world_require, {
    id
}).
-endif.

-ifndef(ENTER_WORLD_RESPOND_PB_H).
-define(ENTER_WORLD_RESPOND_PB_H, true).
-record(enter_world_respond, {
    resultcode
}).
-endif.

-ifndef(LEAVE_WORLD_REQUIRE_PB_H).
-define(LEAVE_WORLD_REQUIRE_PB_H, true).
-record(leave_world_require, {
    
}).
-endif.

-ifndef(LEAVE_WORLD_RESPOND_PB_H).
-define(LEAVE_WORLD_RESPOND_PB_H, true).
-record(leave_world_respond, {
    
}).
-endif.

