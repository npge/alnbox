-- alnbox, alignment viewer based on the curses library
-- Copyright (C) 2015 Boris Nagaev
-- See the LICENSE file for terms of use

describe("alnbox.consensusChar", function()
    it("gets consensus of an alignment", function()
        local aln = {
            name2text = {
                a = "ATGC",
                b = "ATCA",
                c = "A-G-",
            },
            names = { "a", "b", "c"},
        }
        local consensusChar = require 'alnbox.consensusChar'
        assert.same({'A', 1.0}, {consensusChar(0, aln)})
        assert.same({'T', 0.5}, {consensusChar(1, aln)})
        assert.same({'G', 0.0}, {consensusChar(2, aln)})
        assert.same({'A', 0.0}, {consensusChar(3, aln)})
    end)

    it("treats an alignment of rows of different lengths",
    function()
        local aln = {
            name2text = {
                a = "ATGC",
                b = "ATCAA",
                c = "A-G-",
            },
            names = { "a", "b", "c"},
        }
        local consensusChar = require 'alnbox.consensusChar'
        assert.same({'A', 0.5}, {consensusChar(4, aln)})
    end)
end)
