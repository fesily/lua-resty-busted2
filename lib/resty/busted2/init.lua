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

--##region check luarocks path
do
    local pipe = require 'ngx.pipe'
    local proc, err = pipe.spawn({ "sh", "-c", 'luarocks path' })
    if not proc then
        ngx.log(ngx.ERR, err)
    else
        local path = proc:stdout_read_line()
        if path then
            local i, j = path:find("export LUA_PATH='")
            path = path:sub(j + 1, #path - 1) .. ';'
            package.path = path .. package.path
            ngx.log("use luarocks path:", path)

            local cpath = proc:stdout_read_line()
            if cpath then
                i, j = cpath:find("export LUA_CPATH='")
                cpath = cpath:sub(j + 1, #cpath - 1) .. ';'
                package.cpath = cpath .. package.cpath
                ngx.log("use luarocks cpath:", cpath)
            end
        end
        proc:wait()
    end
end
--#endregion

return require 'busted.runner'
