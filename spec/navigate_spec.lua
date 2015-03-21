-- alnbox, alignment viewer based on the curses library
-- Copyright (C) 2015 Boris Nagaev
-- See the LICENSE file for terms of use

describe("alnbox.navigate", function()
    it("calls method moveUp when a user presses UP", function()
        local cursesConsts = require 'alnbox.cursesConsts'
        local aw = {
            drawAll = function() end,
            moveUp = function() end,
        }
        local refresh = function() end
        local getch = coroutine.wrap(function()
            coroutine.yield(cursesConsts.KEY_UP)
            coroutine.yield(string.byte('q'))
        end)
        --
        stub(aw, "drawAll")
        stub(aw, "moveUp")
        --
        local navigate = require 'alnbox.navigate'
        navigate(aw, refresh, getch)
        assert.stub(aw.drawAll).was_called()
        assert.stub(aw.moveUp).was_called()
    end)
end)
