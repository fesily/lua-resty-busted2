# lua-resty-busted2
better openresty busted test unit framework
## how to test
``` sh
resty [resty_options...] rebusted2 [busted_options...] [busted_files...]
```
``` sh
rebusted2 [busted_options...] [busted_files...]
```
### lua-debug
launch.json
```json
 {
    "type": "lua",
    "request": "launch",
    "name": "Debug",
    "program": "${file}",
    "luaexe": "resty",
    "arg0": ["-e","require 'resty.busted2'({standalone=false})"],
    "luaVersion": "jit",
    "cpath": null,
    "path": null,
}
```
## ngx.log
The ngx.log output can now be inspected.
```lua
it('DEBUG', function()
    ngx.log(ngx.DEBUG, '1')
    assert.error_log('1', ngx.DEBUG)
end)
```
`Notice`:
1. `CRIT`,`ALERT`,`EMERG` will throw error
2. `STDERR` will just output to std err
### default_ngx_log_level
`default` log level is `ngx.ERR`, changed by
```lua
assert:set_parameter('default_ngx_log_level', ngx.DEBUG)
```
### When to clear the log
start a new `describe`,`context`,`file`,`suite` test.
If you want to clean up in every test.
```lua
context('every test clear log', function()
    busted_ngx.each_test_clean_log()
    ngx.log(ngx.ERR, '1')
    it('1', function()
        assert.no.error_log()
    end)
    it('2', function()
        assert.no.error_log('1')
        ngx.log(ngx.ERR, '2')
        assert.error_log('2')
    end)
end)
```
