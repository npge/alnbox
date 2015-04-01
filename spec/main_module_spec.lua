-- alnbox, alignment viewer based on the curses library
-- Copyright (C) 2015 Boris Nagaev
-- See the LICENSE file for terms of use

describe("alnbox", function()
    it("provides all submodules as fields", function()
        local alnbox = require 'alnbox'
        local makeAlignment = require 'alnbox.makeAlignment'
        assert.equal(makeAlignment, alnbox.makeAlignment)
    end)
end)
