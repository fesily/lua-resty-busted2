package = "lua-resty-busted2"
version = "dev-1"
source = {
   url = "git+https://github.com/fesily/lua-resty-busted2.git"
}

description = {
   homepage = "https://github.com/fesily/lua-resty-busted2",
   license = "Apache-2.0"
}

dependencies = {
    'busted'
}

build = {
   type = "builtin",
   modules = {
      ["resty.busted2.busted2.d"] = "lib/resty/busted2/busted2.d.lua",
      ["resty.busted2.execute"] = "lib/resty/busted2/execute.lua",
      ["resty.busted2.init"] = "lib/resty/busted2/init.lua",
      ["resty.busted2.languages.en"] = "lib/resty/busted2/languages/en.lua",
      ["resty.busted2.languages.zh"] = "lib/resty/busted2/languages/zh.lua",
      ["resty.busted2.ngx.log"] = "lib/resty/busted2/ngx/log.lua"
   },
   install = {
      bin = {
         "bin/rebusted2"
      }
   }
}
