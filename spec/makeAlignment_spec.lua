-- alnbox, alignment viewer based on the curses library
-- Copyright (C) 2015 Boris Nagaev
-- See the LICENSE file for terms of use

describe("alnbox.makeAlignment", function()
    it("creates alignment object", function()
        local names = { "c_59_0", "b_59_0", "a_0_59" }
        local name2text = {
            a_0_59 = "TGCTTCGGCG",
            b_59_0 = "TGCTTCGGCG",
            c_59_0 = "TGCTTCGGCG",
        }
        local name2description = {
            b_59_0 = "block=test",
            c_59_0 = "block test",
        }
        --
        local makeAlignment = require 'alnbox.makeAlignment'
        local aln = makeAlignment(names, name2text,
            name2description)
        assert.same({
            names=names,
            name2text=name2text,
            name2description={
                a_0_59 = "",
                b_59_0 = "block=test",
                c_59_0 = "block test",
            },
        }, aln)
    end)

    it("creates alignment object without descriptions",
    function()
        local names = { "c_59_0", "b_59_0", "a_0_59" }
        local name2text = {
            a_0_59 = "TGCTTCGGCG",
            b_59_0 = "TGCTTCGGCG",
            c_59_0 = "TGCTTCGGCG",
        }
        --
        local makeAlignment = require 'alnbox.makeAlignment'
        local aln = makeAlignment(names, name2text)
        assert.same({
            names=names,
            name2text=name2text,
            name2description={
                a_0_59 = "",
                b_59_0 = "",
                c_59_0 = "",
            },
        }, aln)
    end)
end)
