local a=require("which-key.mappings")local b={}function b.migrate(c)c=vim.deepcopy(c)local d=a.parse(c,{version=1,notify=false})local e={}for f,g in ipairs(d)do g.preset=nil;g[1]=g.lhs:gsub("<lt>","<")g[2]=g.rhs;g.lhs=nil;g.rhs=nil;local h=g.mode;g.mode=nil;if g.silent then g.silent=nil end;if g.group then g.group=g.desc;g.desc=nil end;local i=vim.inspect(g)e[i]=e[i]or{m=g,mode={}}table.insert(e[i].mode,h)end;d=vim.tbl_map(function(j)local g=j.m;if not vim.deep_equal(j.mode,{"n"})then g.mode=j.mode end;return g end,vim.tbl_values(e))table.sort(d,function(k,l)return k[1]<l[1]end)local m={}for f,g in pairs(d)do local h=g.mode or{}table.sort(h)local i=table.concat(h)m[i]=m[i]or{}table.insert(m[i],g)end;local n={}for h,o in pairs(m)do if#o>2 and h~=""then n[#n+1]="  {"n[#n+1]="    mode = "..vim.inspect(o[1].mode)..","for f,g in ipairs(o)do g.mode=nil;n[#n+1]="    "..vim.inspect(g):gsub("%s+"," ")..","end;n[#n+1]="  },"else for f,g in ipairs(o)do if g.mode and#g.mode==1 then g.mode=g.mode[1]end;n[#n+1]="  "..vim.inspect(g):gsub("%s+"," ")..","end end end;return"{\n"..table.concat(n,"\n").."\n}"end;return b