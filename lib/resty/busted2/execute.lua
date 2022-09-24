local busted_ngx = require 'resty.busted2.ngx.log'
require 'resty.busted2.languages.zh'
require 'resty.busted2.languages.en'

return function(busted)
    busted_ngx.register(busted)
end
