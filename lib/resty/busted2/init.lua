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

require 'busted.runner' ({ standalone = false })