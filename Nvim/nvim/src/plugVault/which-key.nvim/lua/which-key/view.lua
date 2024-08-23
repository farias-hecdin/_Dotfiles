local a=require("which-key.buf")local b=require("which-key.config")local c=require("which-key.icons")local d=require("which-key.layout")local e=require("which-key.plugins")local f=require("which-key.state")local g=require("which-key.text")local h=require("which-key.tree")local i=require("which-key.util")local j=require("which-key.win")local k={}k.view=nil;k.footer=nil;k.timer=(vim.uv or vim.loop).new_timer()k.fields={order=function(l)return l.order and l.order or 1000 end,["local"]=function(l)return l.keymap and l.keymap.buffer~=0 and 0 or 1000 end,manual=function(l)return l.mapping and l.mapping.idx or 10000 end,desc=function(l)return l.desc or"~"end,group=function(l)return l.group and 1 or 0 end,alphanum=function(l)return l.key:find("^%w+$")and 0 or 1 end,mod=function(l)return l.key:find("^<.*>$")and 0 or 1 end,case=function(l)return l.key:lower()==l.key and 0 or 1 end,natural=function(l)local m=l.key:gsub("%d+",function(n)return("%09d"):format(tonumber(n))end)return m:lower()end}function k.format(o)local p=i.keys(o)local m=vim.tbl_map(function(q)local r=q:match("^<(.*)>$")if not r then return q end;if r=="NL"then r="C-J"end;local s=vim.split(r,"-",{plain=true})for t,u in ipairs(s)do if t==1 or t~=#s or not u:match("^%w$")then s[t]=b.icons.keys[u]or s[t]end end;return table.concat(s,"")end,p)return table.concat(m,"")end;function k.sort(v,w)w=vim.deepcopy(w or b.sort)vim.list_extend(w,{"natural","case"})table.sort(v,function(x,y)for z,A in ipairs(w)do local B=type(A)=="function"and A or k.fields[A]if B then local C=B(x)local D=B(y)if C~=D then return C<D end end end;return x.raw_key<y.raw_key end)end;function k.valid()return k.view and k.view:valid()end;function k.update(E)local F=f.state;if not F then k.hide()return end;E=E or{}if k.valid()then k.show()elseif E.schedule~=false then local G=E.delay or f.delay({mode=F.mode.mode,keys=F.node.keys,plugin=F.node.plugin,waited=E.waited})k.timer:start(G,0,vim.schedule_wrap(function()i.try(k.show)end))end end;function k.hide()if k.view then k.view:hide()k.view=nil end;if k.footer then k.footer:hide()k.footer=nil end end;function k.opts()return vim.tbl_deep_extend("force",{col=0,row=math.huge},b.win,{relative="editor",style="minimal",focusable=false,noautocmd=true,wo={scrolloff=0,foldenable=false,winhighlight="Normal:WhichKeyNormal,FloatBorder:WhichKeyBorder,FloatTitle:WhichKeyTitle",winbar="",statusline="",wrap=false},bo={buftype="nofile",bufhidden="wipe",filetype="wk"}})end;function k.replace(B,H)for z,I in pairs(b.replace[B])do H=type(I)=="function"and(I(H)or H)or H:gsub(I[1],I[2])end;return H end;function k.item(J,E)E=E or{}E.default=E.default or"count"local K=(J.plugin or E.group==false)and 0 or h.count(J)local L=J.desc;if not L and J.keymap and J.keymap.rhs~=""and type(J.keymap.rhs)=="string"then L=J.keymap.rhs end;if not L and E.default=="count"and K>0 then L=K.." keymap"..(K>1 and"s"or"")end;if not L and E.default=="path"then L=J.keys end;L=k.replace("desc",L or"")local M,N;if J.mapping and J.mapping.icon then M,N=c.get(J.mapping.icon)end;if not M and not(J.parent and J.parent.plugin)then M,N=c.get({keymap=J.keymap,desc=J.desc})end;if not M then local O=J.parent;while O do if O.mapping and O.mapping.icon then M,N=c.get(O.mapping.icon)break end;O=O.parent end end;local P=E.parent_key and k.replace("key",E.parent_key)or""return setmetatable({node=J,icon=M,icon_hl=N,key=P..k.replace("key",J.key),raw_key=(E.parent_key or"")..J.key,desc=K>0 and b.icons.group..L or L,group=K>0},{__index=J})end;function k.trail(J,E)E=E or{}local function Q(R)return E.title and"WhichKeyTitle"or(R and"WhichKey"..R or"WhichKeyGroup")end;local S={}local T=false;while J do local L=J.desc and b.icons.group..k.replace("desc",J.desc)or J.key and k.replace("key",J.key)or""J=J.parent;if L~=""then if J and#S>0 then table.insert(S,1,{" "..b.icons.breadcrumb.." ",Q("Separator")})end;table.insert(S,1,{L,Q()})end;local U=f.state.mode.mode;if not T and not J and(U=="x"or U=="o")then T=true;local V=a.get({buf=f.state.mode.buf.buf,mode="n"})if V then J=V.tree:find(U=="x"and"v"or vim.v.operator)end end end;if#S>0 then table.insert(S,1,{" ",Q()})table.insert(S,{" ",Q()})return S end end;function k.show()local F=f.state;if not F or not h.is_group(F.node)then k.hide()return end;local W=g.new()local X=vim.tbl_values(F.node.children or{})local function Y(J)return not(F.filter.global==false and J.global)and not(F.filter["local"]==false and not J.global)end;local Z={}for z,J in ipairs(X)do if Y(J)then local _=type(b.expand)=="function"and b.expand or function()local K=h.count(J)return K>0 and K<=b.expand end;if not J.plugin and _(J)then for z,a0 in ipairs(vim.tbl_values(J.children or{}))do if Y(a0)then table.insert(Z,k.item(a0,{parent_key=J.key}))end end;if J.keymap then table.insert(Z,k.item(J,{group=false}))end else table.insert(Z,k.item(J))end end end;k.sort(Z)local a1={{key="key",hl="WhichKey",align="right"},{key="sep",hl="WhichKeySeparator",default=b.icons.separator},{key="icon",padding={0,0}}}if F.node.plugin then vim.list_extend(a1,e.cols(F.node.plugin))end;a1[#a1+1]={key="desc",width=math.huge}local a2=d.new({cols=a1,rows=Z})local E=j.defaults(b.win)local a3={width=d.dim(vim.o.columns,vim.o.columns,E.width),height=d.dim(vim.o.lines,vim.o.lines,E.height)}local z,z,a4=a2:cells()local a5=d.dim(a4,a3.width,b.layout.width)local a6=math.max(math.floor(a3.width/(a5+b.layout.spacing)),1)a5=math.floor(a3.width/a6)local a7=math.max(math.ceil(#Z/a6),2)local a8=a2:layout({width=a5-b.layout.spacing})for z=1,b.win.padding[1]+1 do W:nl()end;for a9=1,a7 do W:append(string.rep(" ",b.win.padding[2]))for y=1,a6 do local t=(y-1)*a7+a9;local l=Z[t]local aa=a8[t]if y~=1 or a6>1 then W:append(string.rep(" ",b.layout.spacing))end;if l then for ab,ac in ipairs(aa)do local Q=ac.hl;if a1[ab].key=="desc"then Q=l.group and"WhichKeyGroup"or"WhichKeyDesc"end;if a1[ab].key=="icon"then Q=l.icon_hl end;W:append(ac.value,Q)end end end;W:append(string.rep(" ",b.win.padding[2]))W:nl()end;W:trim()for z=1,b.win.padding[1]do W:nl()end;local ad=b.show_keys;local ae=E.border and E.border~="none"if not ae then E.footer=nil;E.title=nil end;if E.title==true then E.title=k.trail(F.node,{title=true})ad=false end;if E.footer==true then E.footer=k.trail(F.node,{title=true})ad=false end;if not E.title then E.title=""E.title_pos=nil end;if not E.footer then E.footer=""E.footer_pos=nil end;local af=ae and 2 or 0;E.width=d.dim(W:width()+af,vim.o.columns,E.width)E.height=d.dim(W:height()+af,vim.o.lines,E.height)if b.show_help then E.height=E.height+1 end;E.col=d.dim(E.col,vim.o.columns-E.width)E.row=d.dim(E.row,vim.o.lines-E.height-vim.o.cmdheight)E.width=E.width-af;E.height=E.height-af;k.check_overlap(E)k.view=k.view or j.new(E)k.view:show(E)if b.show_help or ad then W:nl()local ag=g.new()if ad then ag:append(" ")for z,ah in ipairs(k.trail(F.node)or{})do ag:append(ah[1],ah[2])end end;if b.show_help then local p={{key="<esc>",desc="close"}}if F.node.parent then p[#p+1]={key="<bs>",desc="back"}end;if E.height<W:height()then p[#p+1]={key="<c-d>/<c-u>",desc="scroll"}end;local ai=g.new()for aj,q in ipairs(p)do ai:append(k.replace("key",i.norm(q.key)),"WhichKey"):append(" "..q.desc,"WhichKeySeparator")if aj<#p then ai:append("  ")end end;local ac=ag:col({display=true})local ak=string.rep(" ",math.floor((E.width-ai:width())/2)-ac)ag:append(ak)ag:append(ai._lines[1])end;ag:trim()k.footer=k.footer or j.new()k.footer:show({relative="win",win=k.view.win,col=0,row=E.height-1,width=E.width,height=1,zindex=k.view.opts.zindex+1})ag:render(k.footer.buf)end;W:render(k.view.buf)vim.api.nvim_win_call(k.view.win,function()vim.fn.winrestview({topline=1})end)vim.cmd.redraw()end;function k.check_overlap(E)if b.win.no_overlap==false then return end;local aa,ac=vim.fn.screenrow(),vim.fn.screencol()local al=aa>=E.row and aa<=E.row+E.height and(ac>=E.col and ac<=E.col+E.width)if al then E.row=aa+1;E.height=math.max(vim.o.lines-E.row,4)end end;function k.scroll(am)return k.view and k.view:scroll(am)end;return k