-- alnbox, alignment viewer based on the curses library
-- Copyright (C) 2015 Boris Nagaev
-- See the LICENSE file for terms of use

describe("alnbox.dnaCells", function()
    it("defines background colors for DNA letters", function()
        local curses = require 'rote.cursesConsts'
        local dnaCells = require('alnbox.dnaCells')(curses)
        assert.truthy(dnaCells.A)
    end)
end)
