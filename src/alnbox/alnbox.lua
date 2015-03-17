-- alnbox, alignment viewer based on the curses library
-- Copyright (C) 2015 Boris Nagaev
-- See the LICENSE file for terms of use

local function makePair(foreground, background)
    return background * 8 + 7 - foreground
end

local function initializeColors(curses)
    for foreground = 0, 7 do
        for background = 0, 7 do
            if foreground ~= 7 or background ~= 0 then
                local pair = makePair(foreground, background)
                curses.init_pair(pair, foreground, background)
            end
        end
    end
end

-- starts interactive pager
-- getCell is function(row, col) ->
--      character, foreground, background, [bold, [blink]]
-- Usage:
-- alnbox(5, 5, function() return '5', 0, 2, true, true end)
return function(table_rows, table_cols, getCell)
    assert(table_rows >= 1)
    assert(table_cols >= 1)

    local curses = require 'posix.curses'

    local stdscr = curses.initscr()
    curses.echo(false)
    curses.start_color()
    curses.raw(true)
    stdscr:nodelay(false)
    stdscr:keypad(true)
    local win_rows, win_cols = stdscr:getmaxyx()

    -- TODO has_colors()
    initializeColors(curses)

    -- TODO has_ic, has_il
    -- https://luaposix.github.io/luaposix/modules/posix.curses.html#has_ic

    -- TODO enable idcok, idlok

    -- TODO A_UNDERLINE

    local function pgetCell(row, col)
        if row < table_rows and col < table_cols then
            return getCell(row, col)
        else
            return ' ', curses.COLOR_WHITE, curses.COLOR_BLACK
        end
    end

    local function drawAll()
        for row = 0, win_rows - 1 do
            for col = 0, win_cols - 1 do
                local ch, fg, bg, bold, blink =
                    pgetCell(row, col)
                stdscr:move(row, col)
                local pair = makePair(fg, bg)
                stdscr:attrset(curses.color_pair(pair))
                if bold then
                    stdscr:attron(curses.A_BOLD)
                end
                if blink then
                    stdscr:attron(curses.A_BLINK)
                end
                stdscr:addch(string.byte(ch))
            end
        end
    end

    drawAll()
    stdscr:refresh()
    stdscr:getch()

    curses.endwin()
end
