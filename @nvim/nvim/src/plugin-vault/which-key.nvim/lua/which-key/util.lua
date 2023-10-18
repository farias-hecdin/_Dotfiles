local a={}local b=string.byte;local c=string.sub;local d={}local e={}local f=""function a.check_cache()local g=(vim.g.mapleader or"")..":"..(vim.g.maplocalleader or"")if g~=f then d={}e={}f=g end end;function a.count(h)local i=0;for j,j in pairs(h)do i=i+1 end;return i end;function a.get_mode()local k=vim.api.nvim_get_mode().mode;k=k:gsub(a.t("<C-V>"),"v")k=k:gsub(a.t("<C-S>"),"s")return k:lower()end;function a.is_empty(h)return a.count(h)==0 end;function a.t(l)a.check_cache()if not e[l]then e[l]=vim.api.nvim_replace_termcodes(l,false,true,true):gsub("\128\254X","\128")end;return e[l]end;local m={1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,5,5,5,5,6,6,1,1}local n={["<"]=b("<"),[">"]=b(">"),["-"]=b("-")}function a.parse_keys(o)a.check_cache()if d[o]then return d[o]end;local p=a.t(o)local q=a.parse_internal(p)if#q==0 then local i={keys=p,internal={},notation={}}d[o]=i;return i end;local r=o;o=o:gsub("<lt>","<")local s={}local t=1;local u=t;local v="Character"while u<=#o do local w=b(o,u,u)if v=="Character"then t=u;v=w==n["<"]and q[#s+1]~="<"and"Special"or v elseif v=="Special"then v=w==n["-"]and"SpecialNoClose"or w==n[">"]and"Character"or v else v="Special"end;u=u+m[w+1]if v=="Character"then local x=c(o,t,u-1)s[#s+1]=x==" "and"<space>"or x end end;local y=vim.g.mapleader;y=y and a.t(y)s[1]=q[1]==y and"<leader>"or s[1]if#s~=#q then error(vim.inspect({keystr=o,internal=q,notation=s}))end;local i={keys=p,internal=q,notation=s}d[r]=i;return i end;function a.parse_internal(o)local p={}local v="Character"local t=1;local u=1;while u<=#o do local w=b(o,u,u)if v=="Character"then v=w==128 and"Special"or v;u=u+m[w+1]if v=="Character"then p[#p+1]=c(o,t,u-1)t=u end else if w==252 then u=u+2 else u=u+1 end;v="Character"end end;return p end;function a.warn(z)vim.notify(z,vim.log.levels.WARN,{title="WhichKey"})end;function a.error(z)vim.notify(z,vim.log.levels.ERROR,{title="WhichKey"})end;function a.check_mode(k,A)if not("nvsxoiRct"):find(k)then a.error(string.format("Invalid mode %q for buf %d",k,A or 0))return false end;return true end;return a