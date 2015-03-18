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
        os.execute('sleep 5')
        rt:update()
        assert.truthy(rt:termText():match('X'))
        rt:write('q')
    end)
end)
