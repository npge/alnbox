-- alnbox, alignment viewer based on the curses library
-- Copyright (C) 2015 Boris Nagaev
-- See the LICENSE file for terms of use

-- starts curses session and the interactive pager
-- See arguments of alnbox.alnwindow
-- Usage: alnbox {rows=5, cols=5,
--     getCell = function() return {character='5'} end,
--   }
return function(p)
    local curses = require 'posix.curses'

    local stdscr = curses.initscr()
    curses.echo(false)
    curses.start_color()
    curses.raw(true)
    curses.curs_set(0)
    stdscr:nodelay(false)
    stdscr:keypad(true)

    -- TODO has_colors()
    local initializeColors = require 'alnbox.initializeColors'
    initializeColors(curses)

    local alnwindow = require 'alnbox.alnwindow'
    alnwindow(stdscr, p)

    curses.endwin()
end
