-- alnbox, alignment viewer based on the curses library
-- Copyright (C) 2015 Boris Nagaev
-- See the LICENSE file for terms of use

describe("alnbox.initializeColors", function()
    it("initialize standard color pairs", function()
        local curses = {
            init_pair = function(pair, fg, bg) end
        }
        stub(curses, "init_pair")
        local ic = require 'alnbox.initializeColors'
        ic(curses)
        assert.stub(curses.init_pair).was_called_with(7, 0, 0)
    end)
end)
