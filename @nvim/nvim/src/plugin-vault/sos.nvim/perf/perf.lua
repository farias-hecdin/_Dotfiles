local a=vim.api;local function b(c)local d=vim.loop.hrtime()c()return vim.loop.hrtime()-d end;local function e(c)local f={}local g=0;while g<100 do table.insert(f,b(c))g=g+1 end;local h=0;g=0;for i,j in ipairs(f)do h=h+j;g=g+1 end;return h/g end;local function k(l,c)local g=0;while g<l do c()g=g+1 end end;local m={bufmodified=1}local function n()return vim.fn.getbufinfo(m)end;local function o()local p={}for i,q in ipairs(a.nvim_list_bufs())do if vim.bo[q].mod then table.insert(p,q)end end;return p end;local function r(s,t)print(s.." took "..t.."ns on avg")end;k(1e3,n)r("getbufinfo()",e(n))k(1e3,o)r("manual()",e(n))
