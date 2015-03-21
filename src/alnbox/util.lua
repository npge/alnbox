-- alnbox, alignment viewer based on the curses library
-- Copyright (C) 2015 Boris Nagaev
-- See the LICENSE file for terms of use

local util = {}

function util.startScript(rt, lua_fname, remove)
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

function util.startCode(rt, code)
    if type(code) == 'function' then
        code = string.dump(code)
    end
    local fname = os.tmpname()
    local f = io.open(fname, 'w')
    f:write(code)
    f:close()
    local remove = true
    util.startScript(rt, fname, remove)
end

return util
