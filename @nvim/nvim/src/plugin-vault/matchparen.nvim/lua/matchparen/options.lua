local a={on_startup=true,hl_group='MatchParen',augroup_name='matchparen',debounce_time=100}local b={opts=a}function b:update(c)if not c then return end;local d=vim.tbl_keys(a)for e,f in pairs(c)do if vim.tbl_contains(d,e)then self.opts[e]=f else vim.notify('matchparen.nvim: Invalid option `'..e..'`.',vim.log.levels.WARN)end end end;return b
