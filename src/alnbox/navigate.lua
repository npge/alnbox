-- alnbox, alignment viewer based on the curses library
-- Copyright (C) 2015 Boris Nagaev
-- See the LICENSE file for terms of use

-- listen keyboard and call appropriate methods of AlnWindow
return function(aw, refresh, getch)
    local cursesConsts = require 'alnbox.cursesConsts'

    while true do
        aw:drawAll()
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
        elseif ch == string.byte('q') then
            break
        end
    end
end
