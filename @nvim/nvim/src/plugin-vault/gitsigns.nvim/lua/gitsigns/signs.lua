local a=require('gitsigns.config').config;local b=require('gitsigns.debug.log').dprint;local c={Sign={},HlDef={}}function c.new(d,e)local f='signs.init'local g;if a._extmark_signs then b('Using extmark signs')g=require('gitsigns.signs.extmarks')else b('Using vimfn signs')g=require('gitsigns.signs.vimfn')end;local h=e=='staged'and a._signs_staged or a.signs;return g._new(d,h,e)end;return c
