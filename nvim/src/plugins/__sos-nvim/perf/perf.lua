local function a(b)local c=vim.loop.hrtime()b()return vim.loop.hrtime()-c end;local function d(b)local e={}local f=0;while f<100 do table.insert(e,a(b))f=f+1 end;local g=0;f=0;for h,i in ipairs(e)do g=g+i;f=f+1 end;return g/f end;local function j(k,b)local f=0;while f<k do b()f=f+1 end end;local l={bufmodified=1}local function m()return vim.fn.getbufinfo(l)end;local function n()local o={}for h,p in ipairs(vim.api.nvim_list_bufs())do if vim.bo[p].mod then table.insert(o,p)end end;return o end;local function q(r,s)print(r.." took "..s.."ns on avg")end;j(1e3,m)q("getbufinfo()",d(m))j(1e3,n)q("manual()",d(m))
