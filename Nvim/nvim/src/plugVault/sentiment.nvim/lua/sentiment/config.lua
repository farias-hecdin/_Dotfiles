local a=require("sentiment.config.default")local b={}local c=a;local d={}local e={}function b.set(f)c=f;for g,h in ipairs(c.pairs)do d[h[1]]=h[2]e[h[2]]=h[1]end end;function b.is_buffer_included(i)local j=vim.bo[i].buftype;local k=vim.bo[i].filetype;return c.included_buftypes[j]and not c.excluded_filetypes[k]end;function b.is_current_mode_included()local l=vim.fn.mode()return c.included_modes[l]end;function b.get_delay()return c.delay end;function b.get_limit()return c.limit end;function b.get_right_by_left(m)return d[m]end;function b.get_left_by_right(n)return e[n]end;return b