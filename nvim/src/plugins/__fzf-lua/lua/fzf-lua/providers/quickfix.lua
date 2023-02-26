local a=require"fzf-lua.core"local b=require"fzf-lua.utils"local c=require"fzf-lua.config"local d=require"fzf-lua.make_entry"local e={}local f=function(g,h,i)if not i then return{}end;local j={}g=c.normalize_opts(g,h)if not g then return end;if not g.cwd then g.cwd=vim.loop.cwd()end;for k,l in ipairs(i)do table.insert(j,d.lcol(l,g))end;local m=function(n)for k,o in ipairs(j)do o=d.file(o,g)if o then n(o,function(p)if p then return end;n(nil,function()end)end)end end;n(nil)end;g=a.set_fzf_field_index(g)return a.fzf_exec(m,g)end;e.quickfix=function(g)local i=vim.fn.getqflist()if vim.tbl_isempty(i)then b.info("Quickfix list is empty.")return end;return f(g,c.globals.quickfix,i)end;e.loclist=function(g)local i=vim.fn.getloclist(0)for k,q in pairs(i)do q.filename=vim.api.nvim_buf_get_name(q.bufnr)end;if vim.tbl_isempty(i)then b.info("Location list is empty.")return end;return f(g,c.globals.loclist,i)end;return e
