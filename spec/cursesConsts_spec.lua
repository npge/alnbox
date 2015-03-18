describe("alnbox.cursesConsts", function()
    it("gets values of curses constants", function()
        local cursesConsts = require 'alnbox.cursesConsts'
        assert.truthy(cursesConsts.KEY_UP)
        assert.truthy(cursesConsts.KEY_DOWN)
        assert.truthy(cursesConsts.KEY_LEFT)
        assert.truthy(cursesConsts.KEY_RIGHT)
    end)
end)
