describe("alnbox.makePair", function()
    it("converts pair of colors to pair number", function()
        local makePair = require 'alnbox.makePair'
        assert.equal(7, makePair(0, 0))
        assert.equal(0, makePair(7, 0))
        assert.equal(56, makePair(7, 7))
        assert.equal(63, makePair(0, 7))
    end)
end)
