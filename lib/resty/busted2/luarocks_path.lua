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

            local cpath = proc:stdout_read_line()
            if cpath then
                i, j = cpath:find("export LUA_CPATH='")
                cpath = cpath:sub(j + 1, #cpath - 1) .. ';'
                package.cpath = cpath .. package.cpath
            end
        end
        proc:wait()
    end
end
--#endregion