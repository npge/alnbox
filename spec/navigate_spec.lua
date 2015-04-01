-- alnbox, alignment viewer based on the curses library
-- Copyright (C) 2015 Boris Nagaev
-- See the LICENSE file for terms of use

describe("alnbox.navigate", function()
    it("calls method moveUp when a user presses UP", function()
        local cursesConsts = require 'rote.cursesConsts'
        local times_up = 0
        local aw = {
            drawAll = function() end,
            moveUp = function()
                times_up = times_up + 1
            end,
        }
        local refresh = function() end
        local getch = coroutine.wrap(function()
            coroutine.yield(cursesConsts.KEY_UP)
            coroutine.yield(string.byte(' '))
            coroutine.yield(string.byte('q'))
        end)
        --
        spy.on(aw, "drawAll")
        spy.on(aw, "moveUp")
        --
        local navigate = require 'alnbox.navigate'
        navigate(aw, refresh, getch, nil, cursesConsts)
        assert.spy(aw.drawAll).was_called()
        assert.spy(aw.moveUp).was_called()
        assert.truthy(times_up >= 2)
    end)
end)
