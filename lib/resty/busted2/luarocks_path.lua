--##region check luarocks path
local proc, err = io.popen("luarocks path", "r")
if not proc then
    ngx.log(ngx.ERR, err)
else
    local path = proc:read("*l")
    if path then
        local i, j = path:find("export LUA_PATH='")
        path = path:sub(j + 1) .. ';'
        package.path = path .. package.path

        local cpath = proc:read("*l")
        if cpath then
            i, j = cpath:find("export LUA_CPATH='")
            cpath = cpath:sub(j + 1) .. ';'
            package.cpath = cpath .. package.cpath
        end
    end
end
--#endregion
