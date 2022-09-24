local s = require 'say'

s:set_namespace('zh')

--#region error_log
s:set("assertion.error_log.positive", "期望在错误日志里找到: %s")
s:set("assertion.error_log.negative", "不期望在错误日志里找到: %s")
--#endregion
