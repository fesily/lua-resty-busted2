it('length',function()
    local t = {}
    assert.length(t, 0)
    t[1] = 1
    assert.length(t, 1)
    t[3] = 1
    assert.length(t, 1)
end)