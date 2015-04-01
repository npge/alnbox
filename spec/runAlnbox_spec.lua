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

describe("alnbox.runAlnbox", function()
    it("draws simple alignment", function()
        local rote = require 'rote'
        local rt = rote.RoteTerm(24, 80)
        startCode(rt, function()
            local runAlnbox = require 'alnbox.runAlnbox'
            runAlnbox {rows = 1, cols = 1,
                getCell = function() return 'X' end}
        end)
        sleep()
        rt:update()
        assert.truthy(rt:termText():match('X'))
        rt:write('q')
    end)

    it("draws simple alignment with #right header", function()
        local rote = require 'rote'
        local rt = rote.RoteTerm(24, 80)
        startCode(rt, function()
            local runAlnbox = require 'alnbox.runAlnbox'
            runAlnbox {rows = 1, cols = 1,
                getCell = function()
                    return 'X'
                end,
                right_headers = 1,
                getRightHeader = function()
                    return '|'
                end,
            }
        end)
        sleep()
        rt:update()
        assert.truthy(rt:termText():match('X|'))
        rt:write('q')
    end)

    it("draws simple alignment with decoration", function()
        local rote = require 'rote'
        local rt = rote.RoteTerm(24, 80)
        startCode(rt, function()
            local runAlnbox = require 'alnbox.runAlnbox'
            runAlnbox {rows = 1, cols = 1,
                getCell = function()
                    return {
                        character='X',
                        underline=true,
                        bold=true,
                        blink=true,
                    }
                end}
        end)
        sleep()
        rt:update()
        assert.truthy(rt:termText():match('X'))
        local attr = rt:cellAttr(0, 0)
        local fg, bg, bold, blink = rote.fromAttr(attr)
        assert.truthy(bold)
        assert.truthy(blink)
        -- TODO rote can't test underline
        rt:write('q')
    end)

    it("draws 1x1 alignment with all headers and #corners",
    function()
        local rote = require 'rote'
        local rt = rote.RoteTerm(24, 80)
        startCode(rt, function()
            local runAlnbox = require 'alnbox.runAlnbox'
            runAlnbox {rows = 1, cols = 1,
                getCell = function()
                    return 'X'
                end,
                left_headers = 1,
                getLeftHeader = function()
                    return '<'
                end,
                right_headers = 1,
                getRightHeader = function()
                    return '>'
                end,
                top_headers = 1,
                getTopHeader = function()
                    return '^'
                end,
                bottom_headers = 1,
                getBottomHeader = function()
                    return 'v'
                end,
                getTopLeft = function()
                    return '/'
                end,
                getTopRight = function()
                    return '`'
                end,
                getBottomRight = function()
                    return '/'
                end,
                getBottomLeft = function()
                    return '`'
                end,
            }
        end)
        sleep()
        rt:update()
        assert.equal('/^`', rt:rowText(0):sub(1, 3))
        assert.equal('<X>', rt:rowText(1):sub(1, 3))
        assert.equal('`v/', rt:rowText(2):sub(1, 3))
        rt:write('q')
    end)

    it("moves with arrow buttons", function()
        local rote = require 'rote'
        local cursesConsts = require 'rote.cursesConsts'
        local rt = rote.RoteTerm(5, 5)
        startCode(rt, function()
            local runAlnbox = require 'alnbox.runAlnbox'
            runAlnbox {rows = 6, cols = 6,
                getCell = function(row, col)
                    return (row + 3 * col) % 4
                end}
        end)
        sleep()
        rt:update()
        assert.truthy(rt:rowText(0):match('03210'))
        assert.truthy(rt:rowText(1):match('10321'))
        assert.truthy(rt:rowText(2):match('21032'))
        assert.truthy(rt:rowText(3):match('32103'))
        assert.truthy(rt:rowText(4):match('03210'))
        -- move down
        rt:keyPress(cursesConsts.KEY_DOWN)
        sleep()
        rt:update()
        assert.truthy(rt:rowText(0):match('10321'))
        assert.truthy(rt:rowText(1):match('21032'))
        assert.truthy(rt:rowText(2):match('32103'))
        assert.truthy(rt:rowText(3):match('03210'))
        assert.truthy(rt:rowText(4):match('10321'))
        -- move down again (does nothing)
        rt:keyPress(cursesConsts.KEY_DOWN)
        sleep()
        rt:update()
        assert.truthy(rt:rowText(0):match('10321'))
        assert.truthy(rt:rowText(1):match('21032'))
        assert.truthy(rt:rowText(2):match('32103'))
        assert.truthy(rt:rowText(3):match('03210'))
        assert.truthy(rt:rowText(4):match('10321'))
        -- move right
        rt:keyPress(cursesConsts.KEY_RIGHT)
        sleep()
        rt:update()
        assert.truthy(rt:rowText(0):match('03210'))
        assert.truthy(rt:rowText(1):match('10321'))
        assert.truthy(rt:rowText(2):match('21032'))
        assert.truthy(rt:rowText(3):match('32103'))
        assert.truthy(rt:rowText(4):match('03210'))
        -- move right again (does nothing)
        rt:keyPress(cursesConsts.KEY_RIGHT)
        sleep()
        rt:update()
        assert.truthy(rt:rowText(0):match('03210'))
        assert.truthy(rt:rowText(1):match('10321'))
        assert.truthy(rt:rowText(2):match('21032'))
        assert.truthy(rt:rowText(3):match('32103'))
        assert.truthy(rt:rowText(4):match('03210'))
        -- move down again (does nothing)
        rt:keyPress(cursesConsts.KEY_DOWN)
        sleep()
        rt:update()
        assert.truthy(rt:rowText(0):match('03210'))
        assert.truthy(rt:rowText(1):match('10321'))
        assert.truthy(rt:rowText(2):match('21032'))
        assert.truthy(rt:rowText(3):match('32103'))
        assert.truthy(rt:rowText(4):match('03210'))
        -- move up
        rt:keyPress(cursesConsts.KEY_UP)
        sleep()
        rt:update()
        assert.truthy(rt:rowText(0):match('32103'))
        assert.truthy(rt:rowText(1):match('03210'))
        assert.truthy(rt:rowText(2):match('10321'))
        assert.truthy(rt:rowText(3):match('21032'))
        assert.truthy(rt:rowText(4):match('32103'))
        -- move up again (does nothing)
        rt:keyPress(cursesConsts.KEY_UP)
        sleep()
        rt:update()
        assert.truthy(rt:rowText(0):match('32103'))
        assert.truthy(rt:rowText(1):match('03210'))
        assert.truthy(rt:rowText(2):match('10321'))
        assert.truthy(rt:rowText(3):match('21032'))
        assert.truthy(rt:rowText(4):match('32103'))
        -- move left (back to original position)
        rt:keyPress(cursesConsts.KEY_LEFT)
        sleep()
        rt:update()
        assert.truthy(rt:rowText(0):match('03210'))
        assert.truthy(rt:rowText(1):match('10321'))
        assert.truthy(rt:rowText(2):match('21032'))
        assert.truthy(rt:rowText(3):match('32103'))
        assert.truthy(rt:rowText(4):match('03210'))
        -- move left again (does nothing)
        rt:keyPress(cursesConsts.KEY_LEFT)
        sleep()
        rt:update()
        assert.truthy(rt:rowText(0):match('03210'))
        assert.truthy(rt:rowText(1):match('10321'))
        assert.truthy(rt:rowText(2):match('21032'))
        assert.truthy(rt:rowText(3):match('32103'))
        assert.truthy(rt:rowText(4):match('03210'))
        -- quit
        rt:write('q')
    end)

    it("prints #headers", function()
        local rote = require 'rote'
        local cursesConsts = require 'rote.cursesConsts'
        local rt = rote.RoteTerm(6, 20)
        startCode(rt, function()
            local runAlnbox = require 'alnbox.runAlnbox'
            local navigate = require 'alnbox.navigate'
            runAlnbox {rows = 6, cols = 50,
                getCell = function(row, col)
                    return (row + 3 * col) % 4
                end,
                top_headers = 2,
                getTopHeader = function(row, col)
                    if row == 0 then
                        return string.byte('A') + col
                    else
                        return col % 2
                    end
                end,
                left_headers = 1,
                getLeftHeader = function(row, col)
                    return {character = '*',
                        foreground = row + 1,
                        background = row,
                    }
                end,
                right_headers = 2,
                getRightHeader = function(row, col)
                    if col == 0 then
                        return string.byte('a') + row
                    else
                        return {character = '|',
                            background = row + 1,
                            foreground = row,
                        }
                    end
                end,
                bottom_headers = 1,
                getBottomHeader = function(row, col)
                    return '-'
                end,
                -- custom binding:
                -- key "1" results in moving to (1, 1)
                navigate = function(aw, refresh, getch,
                                    _, curses)
                    return navigate(aw, refresh, getch,
                        {[string.byte('1')] = function()
                            aw:moveTo(1, 1)
                        end}, curses)
                end,
            }
        end)
        sleep()
        rt:update()
        assert.truthy(rt:rowText(0):match( 'ABCDEFGHIJKLMNOPQ'))
        assert.truthy(rt:rowText(1):match( '01010101010101010'))
        assert.truthy(rt:rowText(2):match('*03210321032103210a|'))
        assert.truthy(rt:rowText(3):match('*10321032103210321b|'))
        assert.truthy(rt:rowText(4):match('*21032103210321032c|'))
        assert.truthy(rt:rowText(5):match( '-----------------'))
        local attr = rt:cellAttr(2, 0)
        local fg, bg, bold, blink = rote.fromAttr(attr)
        assert.equal(0, bg)
        assert.equal(1, fg)
        -- move down
        rt:keyPress(cursesConsts.KEY_DOWN)
        sleep()
        rt:update()
        assert.truthy(rt:rowText(0):match( 'ABCDEFGHIJKLMNOPQ'))
        assert.truthy(rt:rowText(1):match( '01010101010101010'))
        assert.truthy(rt:rowText(2):match('*10321032103210321b|'))
        assert.truthy(rt:rowText(3):match('*21032103210321032c|'))
        assert.truthy(rt:rowText(4):match('*32103210321032103d|'))
        assert.truthy(rt:rowText(5):match( '-----------------'))
        local attr = rt:cellAttr(2, 0)
        local fg, bg, bold, blink = rote.fromAttr(attr)
        assert.equal(1, bg)
        assert.equal(2, fg)
        -- move right
        rt:keyPress(cursesConsts.KEY_RIGHT)
        sleep()
        rt:update()
        assert.truthy(rt:rowText(0):match( 'BCDEFGHIJKLMNOPQR'))
        assert.truthy(rt:rowText(1):match( '10101010101010101'))
        assert.truthy(rt:rowText(2):match('*03210321032103210b|'))
        assert.truthy(rt:rowText(3):match('*10321032103210321c|'))
        assert.truthy(rt:rowText(4):match('*21032103210321032d|'))
        assert.truthy(rt:rowText(5):match( '-----------------'))
        local attr = rt:cellAttr(2, 0)
        local fg, bg, bold, blink = rote.fromAttr(attr)
        assert.equal(1, bg)
        assert.equal(2, fg)
        -- move right again
        rt:keyPress(cursesConsts.KEY_RIGHT)
        sleep()
        rt:update()
        assert.truthy(rt:rowText(0):match( 'CDEFGHIJKLMNOPQRS'))
        assert.truthy(rt:rowText(1):match( '01010101010101010'))
        assert.truthy(rt:rowText(2):match('*32103210321032103b|'))
        assert.truthy(rt:rowText(3):match('*03210321032103210c|'))
        assert.truthy(rt:rowText(4):match('*10321032103210321d|'))
        assert.truthy(rt:rowText(5):match( '-----------------'))
        local attr = rt:cellAttr(2, 0)
        local fg, bg, bold, blink = rote.fromAttr(attr)
        assert.equal(1, bg)
        assert.equal(2, fg)
        -- move to top left corner (original)
        rt:keyPress(cursesConsts.KEY_HOME)
        rt:keyPress(cursesConsts.KEY_PPAGE)
        sleep()
        rt:update()
        assert.truthy(rt:rowText(0):match( 'ABCDEFGHIJKLMNOPQ'))
        assert.truthy(rt:rowText(1):match( '01010101010101010'))
        assert.truthy(rt:rowText(2):match('*03210321032103210a|'))
        assert.truthy(rt:rowText(3):match('*10321032103210321b|'))
        assert.truthy(rt:rowText(4):match('*21032103210321032c|'))
        assert.truthy(rt:rowText(5):match( '-----------------'))
        local attr = rt:cellAttr(2, 0)
        local fg, bg, bold, blink = rote.fromAttr(attr)
        assert.equal(0, bg)
        assert.equal(1, fg)
        -- move to bottom right corner (opposite)
        rt:keyPress(cursesConsts.KEY_END)
        rt:keyPress(cursesConsts.KEY_NPAGE)
        sleep()
        rt:update()
        assert.truthy(rt:rowText(0):match( 'bcdefghijklmnopqr'))
        assert.truthy(rt:rowText(1):match( '10101010101010101'))
        assert.truthy(rt:rowText(2):match('*21032103210321032d|'))
        assert.truthy(rt:rowText(3):match('*32103210321032103e|'))
        assert.truthy(rt:rowText(4):match('*03210321032103210f|'))
        assert.truthy(rt:rowText(5):match( '-----------------'))
        local attr = rt:cellAttr(2, 0)
        local fg, bg, bold, blink = rote.fromAttr(attr)
        assert.equal(3, bg)
        assert.equal(4, fg)
        -- move to position (1, 1)
        rt:write('1')
        sleep()
        rt:update()
        assert.truthy(rt:rowText(0):match( 'BCDEFGHIJKLMNOPQR'))
        assert.truthy(rt:rowText(1):match( '10101010101010101'))
        assert.truthy(rt:rowText(2):match('*03210321032103210b|'))
        assert.truthy(rt:rowText(3):match('*10321032103210321c|'))
        assert.truthy(rt:rowText(4):match('*21032103210321032d|'))
        assert.truthy(rt:rowText(5):match( '-----------------'))
        local attr = rt:cellAttr(2, 0)
        local fg, bg, bold, blink = rote.fromAttr(attr)
        assert.equal(1, bg)
        assert.equal(2, fg)
        -- quit
        rt:write('q')
    end)
end)
