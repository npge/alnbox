-- alnbox, alignment viewer based on the curses library
-- Copyright (C) 2015 Boris Nagaev
-- See the LICENSE file for terms of use

local function sleep()
    local duration = os.getenv('TEST_SLEEP') or 5
    os.execute('sleep ' .. duration)
end

describe("show-fasta.lua", function()
    it("shows contents of a fasta file", function()
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
        local rote = require 'rote'
        local rt = rote.RoteTerm(24, 30)
        rt:forkPty('show-fasta.lua ' .. fname)
        sleep()
        rt:update()
        assert.truthy(rt:termText():match('b_59_0'))
        assert.truthy(rt:termText():match('a_0_59'))
        assert.truthy(rt:termText():match('TGCTTCGGCGTGCCG'))
        --
        local cursesConsts = require 'alnbox.cursesConsts'
        rt:keyPress(cursesConsts.KEY_RIGHT)
        sleep()
        rt:update()
        assert.truthy(rt:termText():match('b_59_0'))
        assert.truthy(rt:termText():match('a_0_59'))
        assert.falsy(rt:termText():match('TGCTTCGGCGTGCCG'))
        --
        rt:write('q')
        --
        os.remove(fname)
    end)
end)
