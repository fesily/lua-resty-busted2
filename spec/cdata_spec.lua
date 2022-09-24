local ffi = require "ffi"
it('is_cdata',function()
    local ptr = ffi.new('int8_t[1]')
    assert.cdata(ptr)
end)