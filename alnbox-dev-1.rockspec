package = "alnbox"
version = "dev-1"
source = {
    url = "git://github.com/starius/alnbox.git"
}
description = {
    summary = "Alignment viewer based on the curses library",
    homepage = "https://github.com/starius/alnbox",
    license = "MIT",
}
dependencies = {
    "lua >= 5.1",
    "luaposix",
    "lua-rote",
}
build = {
    type = "builtin",
    modules = {
        ['alnbox.init'] = 'src/alnbox/init.lua',
        ['alnbox.alnbox'] = 'src/alnbox/alnbox.lua',
        ['alnbox.alnwindow'] = 'src/alnbox/alnwindow.lua',
        ['alnbox.cursesConsts'] = 'src/alnbox/cursesConsts.lua',
        ['alnbox.util'] = 'src/alnbox/util.lua',
        ['alnbox.makePair'] = 'src/alnbox/makePair.lua',
        ['alnbox.initializeColors'] = 'src/alnbox/initializeColors.lua',
    },
}
