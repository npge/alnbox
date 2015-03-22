-- alnbox, alignment viewer based on the curses library
-- Copyright (C) 2015 Boris Nagaev
-- See the LICENSE file for terms of use

describe("alnbox.columnDigit", function()
    it("gets a digit for top header", function()
        local columnDigit = require 'alnbox.columnDigit'
        local digits = {}
        local length = 25
        for i = 0, length - 1 do
            table.insert(digits, columnDigit(i, length))
        end
        assert.equal("        10        20     ",
            table.concat(digits))
    end)

    local function axis(length)
        local columnDigit = require 'alnbox.columnDigit'
        local digits = {}
        for i = 0, length - 1 do
            table.insert(digits, columnDigit(i, length))
        end
        return table.concat(digits)
    end

    it("gets axis", function()
        assert.equal("        10        20     ", axis(25))
        assert.equal("        10", axis(10))
        assert.equal("         ", axis(9))
        assert.equal("     ", axis(5))
        assert.equal("        10        20", axis(20))
        assert.equal("        10        20 ", axis(21))
        assert.equal("        10        ", axis(18))
        assert.equal("        10         ", axis(19))
    end)
end)
