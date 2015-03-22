-- alnbox, alignment viewer based on the curses library
-- Copyright (C) 2015 Boris Nagaev
-- See the LICENSE file for terms of use

describe("alnbox.dnaCells", function()
    it("defines background colors for DNA letters", function()
        local dnaCells = require 'alnbox.dnaCells'
        assert.truthy(dnaCells.letter2background.A)
    end)
end)
