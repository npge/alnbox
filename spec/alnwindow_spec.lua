-- alnbox, alignment viewer based on the curses library
-- Copyright (C) 2015 Boris Nagaev
-- See the LICENSE file for terms of use

local function sleep()
    local duration = os.getenv('TEST_SLEEP') or 5
    os.execute('sleep ' .. duration)
end

local function startCode(rt, code)
    if type(code) == 'function' then
        code = string.dump(code)
    end
    local fname = os.tmpname()
    local f = io.open(fname, 'w')
    f:write(code)
    f:close()
    local lluacov = os.getenv('LOAD_LUACOV') or ''
    local cmd = 'lua %s %s; rm %s'
    cmd = cmd:format(lluacov, fname, fname)
    rt:forkPty(cmd)
end

describe("alnbox.alnwindow", function()
    it("draws simple alignment in a curses window", function()
        local rote = require 'rote'
        local rt = rote.RoteTerm(24, 80)
        startCode(rt, function()
            local curses = require 'curses'
            local initializeCurses = require 'alnbox.initializeCurses'
            local stdscr = initializeCurses(curses)

            local nlines = 1
            local ncols = 1
            local begin_y = 2
            local begin_x = 5
            local win = stdscr:derive(nlines, ncols,
                begin_y, begin_x)

            local alnwindow = require 'alnbox.alnwindow'
            local aw = alnwindow(win, {rows = 1, cols = 1,
                getCell = function() return 'X' end})

            local navigate = require 'alnbox.navigate'
            local refresh = function() win:refresh() end
            local getch = function() return win:getch() end
            navigate(aw, refresh, getch, nil, curses)

            curses.endwin()
        end)
        sleep()
        rt:update()
        local begin_y = 2
        local begin_x = 5
        assert.equal('X', rt:cellChar(begin_y, begin_x))
        rt:write('q')
    end)
end)
