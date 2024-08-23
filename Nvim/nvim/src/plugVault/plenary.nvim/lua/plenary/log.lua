local a=require"plenary.path"local b=vim.fn.getenv"DEBUG_PLENARY"if b==vim.NIL then b=false end;local c={plugin="plenary",use_console="async",highlights=true,use_file=true,outfile=nil,use_quickfix=false,level=b and"debug"or"info",modes={{name="trace",hl="Comment"},{name="debug",hl="Comment"},{name="info",hl="None"},{name="warn",hl="WarningMsg"},{name="error",hl="ErrorMsg"},{name="fatal",hl="ErrorMsg"}},float_precision=0.01,fmt_msg=function(d,e,f,g,h)local i=e:upper()local j=f..":"..g;if d then return string.format("[%-6s%s] %s: %s",i,os.date"%H:%M:%S",j,h)else return string.format("[%-6s%s] %s: %s\n",i,os.date(),j,h)end end}local k={}local unpack=unpack or table.unpack;k.new=function(l,m)l=vim.tbl_deep_extend("force",c,l)local n=vim.F.if_nil(l.outfile,a:new(vim.api.nvim_call_function("stdpath",{"cache"}),l.plugin..".log").filename)local o;if m then o=k else o=l end;local p={}for q,r in ipairs(l.modes)do p[r.name]=q end;local s=function(t,u)if t==0 then return t end;u=u or 1;t=t/u;return(t>0 and math.floor(t+0.5)or math.ceil(t-0.5))*u end;local v=function(...)local w={}for q=1,select("#",...)do local t=select(q,...)if type(t)=="number"and l.float_precision then t=tostring(s(t,l.float_precision))elseif type(t)=="table"then t=vim.inspect(t)else t=tostring(t)end;w[#w+1]=t end;return table.concat(w," ")end;local x=function(y,z,A,...)if y<p[l.level]then return end;local h=A(...)local B=debug.getinfo(l.info_level or 2,"Sl")local f=B.source:sub(2)local g=B.currentline;if l.use_console then local C=function()local D=l.fmt_msg(true,z.name,f,g,h)if l.highlights and z.hl then vim.cmd(string.format("echohl %s",z.hl))end;local E=vim.split(D,"\n")for F,r in ipairs(E)do local G=string.format("[%s] %s",l.plugin,vim.fn.escape(r,[["\]]))local H=pcall(vim.cmd,string.format([[echom "%s"]],G))if not H then vim.api.nvim_out_write(h.."\n")end end;if l.highlights and z.hl then vim.cmd"echohl NONE"end end;if l.use_console=="sync"and not vim.in_fast_event()then C()else vim.schedule(C)end end;if l.use_file then local I=a:new(n):parent()if not I:exists()then I:mkdir{parents=true}end;local J=assert(io.open(n,"a"))local K=l.fmt_msg(false,z.name,f,g,h)J:write(K)J:close()end;if l.use_quickfix then local i=z.name:upper()local G=string.format("[%s] %s",i,h)local L={filename=B.source:sub(2),lnum=B.currentline,col=1,text=G}vim.fn.setqflist({L},"a")end end;for q,t in ipairs(l.modes)do o[t.name]=function(...)return x(q,t,v,...)end;o[("fmt_%s"):format(t.name)]=function(...)return x(q,t,function(...)local M={...}local N=table.remove(M,1)local O={}for F,r in ipairs(M)do table.insert(O,vim.inspect(r))end;return string.format(N,unpack(O))end,...)end;o[("lazy_%s"):format(t.name)]=function()return x(q,t,function(P)return P()end)end;o[("file_%s"):format(t.name)]=function(Q,R)local S=l.use_console;l.use_console=false;l.info_level=R.info_level;x(q,t,v,unpack(Q))l.use_console=S;l.info_level=nil end end;return o end;k.new(c,true)return k