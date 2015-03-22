#!/usr/bin/env lua

-- alnbox, alignment viewer based on the curses library
-- Copyright (C) 2015 Boris Nagaev
-- See the LICENSE file for terms of use

local alnbox = require 'alnbox'

local fasta_fname = assert(arg[1])
local fasta_f = io.open(fasta_fname, 'r')
local aln = alnbox.readFasta(fasta_f)
fasta_f:close()
local parameters = alnbox.alignmentParameters(aln)
alnbox.alnbox(parameters)
