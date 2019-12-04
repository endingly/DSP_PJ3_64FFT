`timescale 1ns/1ps

`define IM_DATA_WID 10
`define RE_DATA_WID 10

`define LOG2(x)    ( ((x) <= ('d1<<'d01)) ? 'd01    \
                   : ((x) <= ('d1<<'d02)) ? 'd02    \
                   : ((x) <= ('d1<<'d03)) ? 'd03    \
                   : ((x) <= ('d1<<'d04)) ? 'd04    \
                   : ((x) <= ('d1<<'d05)) ? 'd05    \
                   : ((x) <= ('d1<<'d06)) ? 'd06    \
                   : ((x) <= ('d1<<'d07)) ? 'd07    \
                   : ((x) <= ('d1<<'d08)) ? 'd08    \
                   : ((x) <= ('d1<<'d09)) ? 'd09    \
                   : ((x) <= ('d1<<'d10)) ? 'd10    \
                   : ((x) <= ('d1<<'d11)) ? 'd11    \
                   : ((x) <= ('d1<<'d12)) ? 'd12    \
                   : ((x) <= ('d1<<'d13)) ? 'd13    \
                   : ((x) <= ('d1<<'d14)) ? 'd14    \
                   : ((x) <= ('d1<<'d15)) ? 'd15    \
                   : ((x) <= ('d1<<'d16)) ? 'd16    \
                   : ((x) <= ('d1<<'d17)) ? 'd17    \
                   : ((x) <= ('d1<<'d18)) ? 'd18    \
                   : ((x) <= ('d1<<'d19)) ? 'd19    \
                   : ((x) <= ('d1<<'d20)) ? 'd20    \
                   : -1)
