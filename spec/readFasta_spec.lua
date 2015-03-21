-- alnbox, alignment viewer based on the curses library
-- Copyright (C) 2015 Boris Nagaev
-- See the LICENSE file for terms of use

describe("alnbox.readFasta", function()
    it("reads fasta file", function()
        local fasta = [[
>b_59_0 block=test
TGCTTCGGCGTGCCGGACCCGCGCACGCGCGAGGCCGTCAAGCTGTTCGTGGTGCTCGCG
>a_0_59 block=test
TGCTTCGGCGTGCCGGACCCGCGCACGCGCGAGGCCGTCAAGCTGTTCGTGGTGCTCGCG
]]
        local fname = os.tmpname()
        local f = io.open(fname, 'w')
        f:write(fasta)
        f:close()
        --
        local readFasta = require 'alnbox.readFasta'
        local f = io.open(fname, 'r')
        local aln = readFasta(f)
        assert.same({
            name2description = {
                a_0_59 = "block=test",
                b_59_0 = "block=test",
            },
            name2text = {
                a_0_59 = "TGCTTCGGCGTGCCGGACCCGCGCACGCGCGAGGCCGTCAAGCTGTTCGTGGTGCTCGCG",
                b_59_0 = "TGCTTCGGCGTGCCGGACCCGCGCACGCGCGAGGCCGTCAAGCTGTTCGTGGTGCTCGCG",
            },
            names = { "b_59_0", "a_0_59", },
        }, aln)
        --
        os.remove(fname)
    end)
end)
