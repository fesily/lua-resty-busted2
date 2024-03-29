local autoexit = false
if arg[0] and arg[0]:find("/resty_", 1, true) == nil and arg[0]:find("rebusted2", 1, true) == nil then
    local new_t = {}
    for i = 2, #arg + 1, 1 do
        new_t[i] = arg[i - 1]
    end
    new_t[1] = arg[0]
    new_t[0] = 'rebusted2'
    arg = new_t
    autoexit = true
end
require 'resty.busted2.luarocks_path'
ngx.exit = function() end

--- disable _G write guard
local mt = getmetatable(_G)
if mt then
    setmetatable(_G, nil)
end

local execute = require 'busted.execute'
package.loaded['busted.execute'] = function(busted)
    require 'resty.busted2.execute' (busted)
    return execute(busted)
end

--##region luassert
do
    local assert = require('luassert.assert')
    local util = require('luassert.util')

    local function set_failure_message(state, message)
        if message ~= nil then
            state.failure_message = message
        end
    end

    local function is_type(state, arguments, level, etype)
        util.tinsert(arguments, 2, "type " .. etype)
        arguments.nofmt = arguments.nofmt or {}
        arguments.nofmt[2] = true
        set_failure_message(state, arguments[3])
        return arguments.n > 1 and type(arguments[1]) == etype
    end

    local function is_cdata(state, arguments, level) return is_type(state, arguments, level, "cdata") end

    assert:register('assertion', 'cdata', is_cdata, "assertion.same.positive", "assertion.same.negative")
    local function length(state, arguments, level)
        set_failure_message(state, arguments[3])
        local t = arguments[1]
        local length = arguments[2]
        assert(type(t) == 'table')
        assert(type(length) == 'number')
        return arguments.n > 1 and #arguments[1] == length
    end

    assert:register('assertion', 'length', length, 'assertion.same.positive', "assertion.same.negative")
end

--##endregion

local fn = require 'busted.runner'
return function(...)
    fn(...)
    if autoexit then
        os.exit(0)
    end
end
