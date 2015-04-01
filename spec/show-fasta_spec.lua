-- alnbox, alignment viewer based on the curses library
-- Copyright (C) 2015 Boris Nagaev
-- See the LICENSE file for terms of use

local function sleep()
    local duration = os.getenv('TEST_SLEEP') or 5
    os.execute('sleep ' .. duration)
end

local function findLetter(rt, character)
    for row = 0, rt:rows() - 1 do
        for col = 0, rt:cols() - 1 do
            if rt:cellChar(row, col) == character then
                return row, col
            end
        end
    end
end

describe("show-fasta.lua", function()
    it("shows contents of a fasta file", function()
        local fasta = [[
>b_59_0 block=test
TGCTTCGGCGTGCCGGACCCGCGCACGCGCGAGGCCGTCAAGCTGTTCGTGGTGCTCGCG
>a_0_59 block=test
TCCTTC-GCGTGCCGGACCCGCGCACGCGCGAGGCCGTCAAGCTGTTCGTGGTGCTCGCG
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
        local cursesConsts = require 'rote.cursesConsts'
        rt:keyPress(cursesConsts.KEY_RIGHT)
        sleep()
        rt:update()
        assert.truthy(rt:termText():match('b_59_0'))
        assert.truthy(rt:termText():match('a_0_59'))
        assert.truthy(rt:termText():match('consensus'))
        assert.falsy(rt:termText():match('TGCTTCGGCGTGCCG'))
        -- find letters A and T, their attributes must differ
        local A_row, A_col = assert(findLetter(rt, 'A'))
        local T_row, T_col = assert(findLetter(rt, 'T'))
        assert.not_equal(rt:cellAttr(A_row, A_col),
                         rt:cellAttr(T_row, T_col))
        --
        rt:write('q')
        --
        os.remove(fname)
    end)
end)
