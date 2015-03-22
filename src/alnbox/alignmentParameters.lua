-- alnbox, alignment viewer based on the curses library
-- Copyright (C) 2015 Boris Nagaev
-- See the LICENSE file for terms of use

-- gets an alignment, return parameters for alnbox
return function(alignment)
    local p = {}
    p.rows = #alignment.names
    p.cols = 0
    p.left_headers = 0
    for name, text in pairs(alignment.name2text) do
        p.cols = math.max(p.cols, #text)
        p.left_headers = math.max(p.left_headers, #name)
    end
    p.left_headers = p.left_headers + 1
    p.getCell = function(row, col)
        local name = alignment.names[row + 1]
        local text = alignment.name2text[name]
        local ch = text:sub(col + 1, col + 1)
        -- assume DNA
        local dnaCells = require 'alnbox.dnaCells'
        local cc = require 'alnbox.cursesConsts'
        return {
            character = ch,
            foreground = cc.COLOR_BLACK,
            background = dnaCells.letter2background[ch],
        }
    end
    p.getLeftHeader = function(row, col)
        local name = alignment.names[row + 1]
        return name:sub(col + 1, col + 1)
    end
    p.top_headers = 1
    p.getTopHeader = function(_, col)
        local columnDigit = require 'alnbox.columnDigit'
        return columnDigit(col, p.cols)
    end
    return p
end
