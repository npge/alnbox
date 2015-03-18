local function startScript(rt, lua_fname, remove)
    local cmd
    if remove then
        cmd = 'lua -lluacov %s; rm %s'
        cmd = cmd:format(lua_fname, lua_fname)
    else
        cmd = 'lua -lluacov %s'
        cmd = cmd:format(lua_fname)
    end
    rt:forkPty(cmd)
end

local function startCode(rt, code)
    if type(code) == 'function' then
        code = string.dump(code)
    end
    local fname = os.tmpname()
    local f = io.open(fname, 'w')
    f:write(code)
    f:close()
    local remove = true
    startScript(rt, fname, remove)
end

describe("alnbox.alnbox", function()
    it("draws simple alignment", function()
        local rote = require 'rote'
        local rt = rote.RoteTerm(24, 80)
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
