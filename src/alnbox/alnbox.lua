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
-- gets a table of properties:
--  * rows -- number of rows
--  * cols -- number of cols
--  * getCell -- function (row, col) -> table of fields:
--      character, foreground, background,
--      bold, blink, underline
-- Usage: alnbox {rows=5, cols=5,
--     getCell = function() return {character='5'} end,
--   }
return function(p)
    assert(p.rows >= 1)
    assert(p.cols >= 1)

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

    local start_row = 0
    local start_col = 0

    local function moveUp()
        if start_row > 0 then
            start_row = start_row - 1
        end
    end

    local function moveDown()
        if start_row + win_rows < p.rows then
            start_row = start_row + 1
        end
    end

    local function moveLeft()
        if start_col > 0 then
            start_col = start_col - 1
        end
    end

    local function moveRight()
        if start_col + win_cols < p.cols then
            start_col = start_col + 1
        end
    end

    local function pgetCell(row, col)
        row = start_row + row
        col = start_col + col
        if row >= 0 and col >= 0 and
                row < p.rows and col < p.cols then
            return p.getCell(row, col)
        else
            return {character=' '}
        end
    end

    local function drawAll()
        for row = 0, win_rows - 1 do
            for col = 0, win_cols - 1 do
                local cell = pgetCell(row, col)
                stdscr:move(row, col)
                local fg = cell.foreground or curses.COLOR_WHITE
                local bg = cell.background or curses.COLOR_BLACK
                local pair = makePair(fg, bg)
                stdscr:attrset(curses.color_pair(pair))
                if cell.bold then
                    stdscr:attron(curses.A_BOLD)
                end
                if cell.blink then
                    stdscr:attron(curses.A_BLINK)
                end
                if cell.underline then
                    stdscr:attron(curses.A_UNDERLINE)
                end
                stdscr:addch(string.byte(cell.character))
            end
        end
    end

    while true do
        drawAll()
        stdscr:refresh()
        local ch = stdscr:getch()
        if ch == curses.KEY_UP then
            moveUp()
        elseif ch == curses.KEY_DOWN then
            moveDown()
        elseif ch == curses.KEY_RIGHT then
            moveRight()
        elseif ch == curses.KEY_LEFT then
            moveLeft()
        elseif ch == string.byte('q') then
            break
        end
    end

    curses.endwin()
end
