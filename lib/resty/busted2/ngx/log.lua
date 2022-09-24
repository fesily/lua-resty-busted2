local astate = require 'luassert.state'
local assert = require 'luassert'

local function set_failure_message(state, message)
    if message ~= nil then
        state.failure_message = message
    end
end

local old_ngx_log = ngx.log
ngx.log = function(level, ...)
    local t = table.pack(...)
    for i = 1, t.n, 1 do
        local v = t[i]
        if type(v) == 'nil' then
            t[i] = 'nil'
        elseif type(v) == 'cdata' and v == ngx.null then
            t[i] = 'null'
        else
            t[i] = tostring(v)
        end
    end

    if level < ngx.ERR and level > ngx.STDERR then
        error(table.concat(t, ''), 2)
    end
    if level == ngx.STDERR then
        return old_ngx_log(level, ...)
    end

    local log = astate.get_parameter('ngx_log' .. level)
    if log then
        log[#log + 1] = table.concat(t, '')
    end
end

local _M = {}
local disable_context = 'test'
function _M.push_log(contex)
    if contex ~= disable_context then
        for i = ngx.ERR, ngx.DEBUG do
            local log = astate.get_parameter('ngx_log' .. i)
            local new_log = log and setmetatable({}, { __index = log }) or {}
            astate.set_parameter('ngx_log' .. i, new_log)
        end
    end
end

function _M.pop_log(contex)
    if contex ~= disable_context then
        for i = ngx.ERR, ngx.DEBUG do
            local log = astate.get_parameter('ngx_log' .. i)
            local old_log_mt = getmetatable(log)
            if old_log_mt then
                local old_log = old_log_mt and old_log_mt.__index
                astate.set_parameter('ngx_log' .. i, old_log)
            end
        end
    end
end

--- same as before_each(busted_ngx.push_log);after_each(busted_ngx.pop_log);
function _M.each_test_clean_log()
    before_each(function()
        disable_context = ''
    end)
    after_each(function()
        disable_context = 'test'
    end)
end

local function error_log(state, arguments, level)
    level = (level or 1) + 1
    local nargs = arguments.n
    local pattern = arguments[1]
    local log_level
    assert(nargs <= 3)
    if nargs == 2 then
        if type(arguments[2]) == 'string' then
            set_failure_message(state, arguments[2])
        else
            assert.number(arguments[2])
            log_level = arguments[2]
        end
    elseif nargs == 3 then
        log_level = arguments[2]
        set_failure_message(state, arguments[3])
    end

    if not log_level then
        log_level = astate.get_parameter('default_ngx_log_level') or ngx.ERR
    end

    assert(log_level >= ngx.ERR and log_level <= ngx.DEBUG)
    local log = astate.get_parameter('ngx_log' .. log_level)
    if not log then return false end
    if not pattern then
        return #log > 0
    end
    log = table.concat(log, '\n')
    local fn = function(v)
        local from, to, err = ngx.re.find(log, v)
        if err then
            error(err, level)
        end
        return from ~= nil
    end
    if type(pattern) == 'table' then
        for i, v in ipairs(pattern) do
            if not fn(pattern) then
                return false
            end
        end
        return true
    else
        return fn(pattern)
    end

end

function _M.register(busted)
    ---@class luassert
    local assert = busted.api.assert

    _M.push_log(nil)

    assert:register('assertion', 'error_log', error_log,
        'assertion.error_log.positive', 'assertion.error_log.negative')

    busted.subscribe({ 'file', 'start' }, function()
        _M.push_log('file')
    end)
    busted.subscribe({ 'file', 'end' }, function()
        _M.pop_log('file')
    end)
    busted.subscribe({ 'describe', 'start' }, function()
        _M.push_log('describe')
    end)
    busted.subscribe({ 'describe', 'end' }, function()
        _M.pop_log('describe')
    end)
    busted.subscribe({ 'test', 'start' }, function()
        _M.push_log('test')
    end)
    busted.subscribe({ 'test', 'end' }, function()
        _M.pop_log('test')
    end)

    busted.wrap(_M.each_test_clean_log)

    busted.export('busted_ngx', _M)
end

return _M
