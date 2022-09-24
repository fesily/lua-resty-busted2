local s = require 'say'

s:set_namespace('en')

--#region error_log
s:set("assertion.error_log.positive", "Expected find error_log: %s")
s:set("assertion.error_log.negative", "Expected not find error_log: %s")
--#endregion
