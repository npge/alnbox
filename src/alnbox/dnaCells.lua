-- alnbox, alignment viewer based on the curses library
-- Copyright (C) 2015 Boris Nagaev
-- See the LICENSE file for terms of use

local dnaCells = {}

local cc = require 'alnbox.cursesConsts'

dnaCells.letter2background = {
    A = cc.COLOR_GREEN,
    T = cc.COLOR_BLUE,
    G = cc.COLOR_RED,
    C = cc.COLOR_YELLOW,
    N = cc.COLOR_RED,
    ['-'] = cc.COLOR_WHITE,
}

return dnaCells
