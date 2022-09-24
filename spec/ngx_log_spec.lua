context('error_log arguments', function()
    it('arguments number', function()
        assert.has_error(function()
            assert.error_log(1, 2, 3, 4)
        end)
    end)
    it('three arguments 2:number,3:string', function()
        assert.has_error(function()
            assert.error_log('dffd', 'sdec', 1)
        end)
    end)
    it('two arguments 2:number|string', function()
        assert.has_error(function()
            assert.error_log('dffd', false)
        end)
        assert.has_error(function()
            assert.error_log('dffd', {})
        end)
    end)
end)
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

context('every test no clear log', function()
    ngx.log(ngx.ERR, '2')

    context('new context no log', function()
        it('1', function()
            assert.no.error_log()
        end)
    end)

    it('1', function()
        assert.error_log('2')
    end)

    it('2', function()
        assert.error_log('2')
    end)

end)
context('log throw error', function()
    it('ngx.CRIT', function()
        assert.has_error(function()
            ngx.log(ngx.CRIT, '')
        end)
    end)

    it('ngx.ALERT', function()
        assert.has_error(function()
            ngx.log(ngx.ALERT, '')
        end)
    end)

    it('ngx.EMERG', function()
        assert.has_error(function()
            ngx.log(ngx.EMERG, '')
        end)
    end)

    it('ngx.STDERR', function()
        assert.no.has_error(function()
            ngx.log(ngx.STDERR, '')
        end)
    end)
end)

context('check log level', function()
    it('DEBUG', function()
        ngx.log(ngx.DEBUG, '1')
        assert.error_log('1', ngx.DEBUG)
    end)
    it('INFO', function()
        ngx.log(ngx.INFO, '1')
        assert.error_log('1', ngx.INFO)
    end)
    it('NOTICE', function()
        ngx.log(ngx.NOTICE, '1')
        assert.error_log('1', ngx.NOTICE)
    end)
    it('WARN', function()
        ngx.log(ngx.WARN, '1')
        assert.error_log('1', ngx.WARN)
    end)
    it('ERR', function()
        ngx.log(ngx.ERR, '1')
        assert.error_log('1', ngx.ERR)
    end)
end)
