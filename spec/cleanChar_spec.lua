-- alnbox, alignment viewer based on the curses library
-- Copyright (C) 2015 Boris Nagaev
-- See the LICENSE file for terms of use

describe("alnbox.cleanChar", function()
    it("convert anything to byte code", function()
        local cleanChar = require 'alnbox.cleanChar'
        assert.equal(string.byte(' '), cleanChar(' '))
        assert.equal(string.byte('1'), cleanChar(1))
        assert.equal(string.byte(' '), cleanChar(''))
        assert.equal(string.byte('t'), cleanChar('ttt'))
        assert.equal(string.byte(' '), cleanChar({}))
        assert.equal(string.byte(' '), cleanChar())
    end)
end)
