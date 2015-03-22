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
        ['alnbox.navigate'] = 'src/alnbox/navigate.lua',
        ['alnbox.cursesConsts'] = 'src/alnbox/cursesConsts.lua',
        ['alnbox.util'] = 'src/alnbox/util.lua',
        ['alnbox.makePair'] = 'src/alnbox/makePair.lua',
        ['alnbox.initializeColors'] = 'src/alnbox/initializeColors.lua',
        ['alnbox.initializeCurses'] = 'src/alnbox/initializeCurses.lua',
        ['alnbox.putCell'] = 'src/alnbox/putCell.lua',
        ['alnbox.cleanChar'] = 'src/alnbox/cleanChar.lua',
        ['alnbox.readFasta'] = 'src/alnbox/readFasta.lua',
        ['alnbox.alignmentParameters'] = 'src/alnbox/alignmentParameters.lua',
        ['alnbox.columnDigit'] = 'src/alnbox/columnDigit.lua',
    },
    install = {
        bin = {
            "src/bin/show-fasta.lua"
        }
    }
}
