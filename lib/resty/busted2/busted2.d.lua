---@meta

--- clear all ngx log
---#Example
--[[
```lua
    context('every test clear log',function()
        busted_ngx.each_test_clean_log()
        ngx.log(ngx.ERR,'1')
        it('1', function()
            assert.no.error_log()
        end)
        it('2', function()
            ngx.log(ngx.ERR,'2')
            assert.no.error_log('1')
            assert.error_log('2')
        end)
    end)
```
]]
busted_ngx = {}

--- enable each test clean log
--- default when file/context/suite changed clean
function busted_ngx.each_test_clean_log() end

---@class luassert.internal
local ngx_log_assert = {}

---@alias luassert.ngx.log_level `ngx.ERR`|`ngx.WARN `|`ngx.NOTICE`|`ngx.INFO`|`ngx.DEBUG`|integer
---comment check ngx log
---@param pattern string|string[] the pattern is a regex string for `ngx.re`
---@param level? luassert.ngx.log_level default is `ngx.ERR`
---@param message? string
---@overload fun(pattern:string|string[], level?:luassert.ngx.log_level)
---@overload fun(pattern:string|string[], message?:string)
function ngx_log_assert.error_log(pattern, level, message) end

---@class luassert.internal
local luassert = {}

---comment check table length
---@param table table
---@param length number
---@param message? string
function luassert.length(table, length, message) end

---comment check is cdata
---@param obj any
---@param message? string
function luassert.cdata(obj,message) end