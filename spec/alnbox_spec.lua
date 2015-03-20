local function sleep()
    local duration = os.getenv('TEST_SLEEP') or 5
    os.execute('sleep ' .. duration)
end

describe("alnbox.alnbox", function()
    it("draws simple alignment", function()
        local rote = require 'rote'
        local rt = rote.RoteTerm(24, 80)
        local startCode = require 'alnbox.util'.startCode
        startCode(rt, function()
            local alnbox = require 'alnbox.alnbox'
            alnbox {rows = 1, cols = 1,
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
        local startCode = require 'alnbox.util'.startCode
        startCode(rt, function()
            local alnbox = require 'alnbox.alnbox'
            alnbox {rows = 1, cols = 1,
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

    it("moves with arrow buttons", function()
        local rote = require 'rote'
        local cursesConsts = require 'alnbox.cursesConsts'
        local rt = rote.RoteTerm(5, 5)
        local startCode = require 'alnbox.util'.startCode
        startCode(rt, function()
            local alnbox = require 'alnbox.alnbox'
            alnbox {rows = 6, cols = 6,
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
end)
