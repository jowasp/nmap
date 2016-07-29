--
-- Created by IntelliJ IDEA.
-- User: johannacuriel
-- Date: 7/18/16
-- Time: 4:55 PM
-- To change this template use File | Settings | File Templates.
--
local stdnse = require "stdnse"
local string = require "string"
local table = require "table"
local lpeg = require "lpeg"
local unicode = require "unicode"


function Utf8to32(utf8str)
    assert(type(utf8str) == "string")
    local res, seq, val = {}, 0, nil
    for i = 1, #utf8str do
        local c = string.byte(utf8str, i)
        if seq == 0 then
            table.insert(res, val)
            seq = c < 0x80 and 1 or c < 0xE0 and 2 or c < 0xF0 and 3 or
                    c < 0xF8 and 4 or --c < 0xFC and 5 or c < 0xFE and 6 or
                    error("invalid UTF-8 character sequence")
            val = bit32.band(c, 2^(8-seq) - 1)
        else
            val = bit32.bor(bit32.lshift(val, 6), bit32.band(c, 0x3F))
        end
        seq = seq - 1
    end
    table.insert(res, val)
    table.insert(res, 0)
    return res
end