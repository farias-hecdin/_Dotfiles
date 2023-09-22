local a=require('focus.modules.utils')local b=require('focus.modules.split')local vim=vim;local c={}local d=1.618;local e=function()local f=vim.o.columns;return math.floor(f/d)end;local g=function()return math.floor(e()/(3*d))end;local h=function()local i=vim.o.lines;return math.floor(i/d)end;local j=function()return math.floor(h()/(3*d))end;function c.split_resizer(k)if vim.g.enabled_focus_resizing==0 or vim.api.nvim_win_get_option(0,'diff')then return end;local l=vim.bo.ft:lower()local m=vim.bo.buftype:lower()local n=a.to_set(a.to_lower(k.compatible_filetrees))local o=a.to_set(a.to_lower(k.excluded_filetypes))local p=a.to_set(a.to_lower(k.excluded_buftypes))local q=a.to_set(a.to_lower(k.forced_filetypes))local r=a.to_set(k.excluded_windows)local s=vim.api.nvim_get_current_win()if l=='diffviewfiles'then vim.schedule(function()vim.cmd('FocusEqualise')end)elseif n[l]then vim.o.winminwidth=k.minwidth or 0;vim.o.winwidth=k.treewidth;vim.o.winminheight=0;vim.o.winheight=1 elseif p[m]or o[l]or r[s]and not q[l]then vim.o.winminheight=0;vim.o.winheight=1;vim.o.winminwidth=0;vim.o.winwidth=1 elseif l=='qf'then vim.o.winheight=k.height_quickfix or 10 else if k.width>0 then vim.o.winwidth=k.width;if k.minwidth>0 then vim.o.winminwidth=k.minwidth else vim.o.winminwidth=g()end else vim.o.winwidth=e()if k.minwidth>0 then if k.minwidth<e()then print('Focus.nvim: Configured minwidth is less than default golden_ratio_width derived from your display. Please set minwidth to at least '..e())else vim.o.winminwidth=k.minwidth end else vim.o.winminwidth=g()end end;if k.height>0 then vim.o.winheight=k.height;if k.minheight>0 then vim.o.winminheight=k.minheight else vim.o.winminheight=j()end else vim.o.winheight=h()if k.minheight>0 then if k.minheight<h()then print('Focus.nvim: Configured minheight is less than default golden_ratio_height derived from your display. Please set minheight to at least '..h())else vim.o.winminheight=k.minheight end else vim.o.winminheight=j()end end end end;return c
