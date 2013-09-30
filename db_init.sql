-- 
-- 表的结构 `player`
-- 

DROP TABLE IF EXISTS `player`;
CREATE TABLE `player` (
  `id` int(11) unsigned NOT NULL auto_increment COMMENT 'id',
  `accid` int(11) unsigned NOT NULL default '0' COMMENT '平台账号id',
  `accname` varchar(50) NOT NULL default '' COMMENT '平台账户',
  `nickname` varchar(50) NOT NULL default '' COMMENT '玩家名',
  `status` tinyint(1) unsigned NOT NULL default '0' COMMENT '玩家状态（0正常1禁止）',
  `reg_time` int(11) unsigned NOT NULL default '0' COMMENT '注册时间',
  `last_login_time` int(11) NOT NULL default '0' COMMENT '最后登陆时间',
  `last_login_ip` varchar(20) NOT NULL default '' COMMENT '最后登陆IP',
  `scene` int(11) unsigned NOT NULL default '0' COMMENT '场景ID',
  `x` smallint(5) unsigned NOT NULL default '0' COMMENT 'X坐标',
  `y` smallint(5) unsigned NOT NULL default '0' COMMENT 'Y坐标',
  `career` tinyint(1) unsigned NOT NULL default '0' COMMENT '职业',
  `hp` int(11) unsigned NOT NULL default '0' COMMENT '气血',
  `mp` int(11) unsigned NOT NULL default '0' COMMENT '内息',
  `hp_lim` int(11) unsigned NOT NULL default '0' COMMENT '攻击',
  `mp_lim` int(11) unsigned NOT NULL default '0' COMMENT '防御',
  `online_flag` int(11) unsigned NOT NULL default '0' COMMENT '在线标记，0不在线 1在线\0Memo\0dit\0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `nickname` (`nickname`),
  UNIQUE KEY `accname` (`accname`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='用户信息';
