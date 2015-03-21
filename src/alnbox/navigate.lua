-- alnbox, alignment viewer based on the curses library
-- Copyright (C) 2015 Boris Nagaev
-- See the LICENSE file for terms of use

-- listen keyboard and call appropriate methods of AlnWindow
return function(aw, refresh, getch, bindings)
    local cursesConsts = require 'alnbox.cursesConsts'

    aw:drawAll()

    while true do
        refresh()
        local ch = getch()
        if ch == cursesConsts.KEY_UP then
            aw:moveUp()
        elseif ch == cursesConsts.KEY_DOWN then
            aw:moveDown()
        elseif ch == cursesConsts.KEY_RIGHT then
            aw:moveRight()
        elseif ch == cursesConsts.KEY_LEFT then
            aw:moveLeft()
        elseif ch == cursesConsts.KEY_PPAGE then
            aw:moveUpEnd()
        elseif ch == cursesConsts.KEY_NPAGE then
            aw:moveDownEnd()
        elseif ch == cursesConsts.KEY_END then
            aw:moveRightEnd()
        elseif ch == cursesConsts.KEY_HOME then
            aw:moveLeftEnd()
        elseif ch == string.byte('q') then
            break
        elseif bindings and bindings[ch] then
            local func = bindings[ch]
            func()
        end
    end
end
