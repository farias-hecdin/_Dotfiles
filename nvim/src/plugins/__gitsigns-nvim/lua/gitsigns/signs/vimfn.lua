local a=vim.fn;local b=require('gitsigns.config').Config.SignsConfig;local c=require('gitsigns.config').config;local d=require('gitsigns.util').emptytable;local e=require('gitsigns.signs.base')local f={}local function g(h)return h:sub(1,1):upper()..h:sub(2)end;local i={}local j={}local function k(l)if not j[l]then j[l]=string.format('%s%s','GitSigns',g(l))end;return j[l]end;local function m(n)if not i[n]then local o=a.sign_getdefined(n)if not vim.tbl_isempty(o)then i[n]=o end end;return i[n]end;local function p(n,q,r)if r then i[n]=nil;a.sign_undefine(n)a.sign_define(n,q)elseif not m(n)then a.sign_define(n,q)end end;local function s(t,r)for l,u in pairs(t.config)do p(k(l),{texthl=u.hl,text=c.signcolumn and u.text or nil,numhl=c.numhl and u.numhl or nil,linehl=c.linehl and u.linehl or nil},r)end end;local v='gitsigns_vimfn_signs_'function f.new(w,n)local self=setmetatable({},{__index=f})self.group=v..(n or'')self.config=w;self.placed=d()s(self,false)return self end;function f:on_lines(x,x,x,x)end;function f:remove(y,z,A)A=A or z;if z then for B=z,A do self.placed[y][B]=nil;a.sign_unplace(self.group,{buffer=y,id=B})end else self.placed[y]=nil;a.sign_unplace(self.group,{buffer=y})end end;function f:add(y,C)if not c.signcolumn and not c.numhl and not c.linehl then return end;local D={}local w=self.config;for x,o in ipairs(C)do local E=k(o.type)local u=w[o.type]if c.signcolumn and u.show_count and o.count then local F=o.count;local G=c.count_chars;local H=G[F]and tostring(F)or G['+']and'Plus'or''local I=G[F]or G['+']or''E=E..H;p(E,{texthl=u.hl,text=c.signcolumn and u.text..I or'',numhl=c.numhl and u.numhl or nil,linehl=c.linehl and u.linehl or nil})end;if not self.placed[y][o.lnum]then local J={id=o.lnum,group=self.group,name=E,buffer=y,lnum=o.lnum,priority=c.sign_priority}self.placed[y][o.lnum]=o;D[#D+1]=J end end;if#D>0 then a.sign_placelist(D)end end;function f:contains(y,K,L)for M=K+1,L+1 do if self.placed[y][M]then return true end end;return false end;function f:reset()self.placed=d()a.sign_unplace(self.group)s(self,true)end;return f
