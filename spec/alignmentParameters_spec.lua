-- alnbox, alignment viewer based on the curses library
-- Copyright (C) 2015 Boris Nagaev
-- See the LICENSE file for terms of use

describe("alnbox.alignmentParameters", function()
    it("gets an alignment, return parameters for alnbox",
    function()
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
        f:close()
        --
        local alignmentParameters =
            require 'alnbox.alignmentParameters'
        local parameters = alignmentParameters(aln)
        --
        assert.truthy(parameters.getCell)
        assert.truthy(parameters.left_headers > 0)
        --
        os.remove(fname)
    end)
end)
