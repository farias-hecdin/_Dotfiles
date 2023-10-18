local a=require("which-key.keys")local b=require("which-key.config")local c=require("which-key.layout")local d=require("which-key.util")local e=vim.api.nvim_buf_add_highlight;local f={}f.keys=""f.mode="n"f.reg=nil;f.auto=false;f.count=0;f.buf=nil;f.win=nil;function f.is_valid()return f.buf and f.win and vim.api.nvim_buf_is_valid(f.buf)and vim.api.nvim_buf_is_loaded(f.buf)and vim.api.nvim_win_is_valid(f.win)end;function f.show()if vim.b.visual_multi then vim.b.VM_skip_reset_once_on_bufleave=true end;if f.is_valid()then return end;local g=vim.tbl_filter(function(h)return vim.api.nvim_win_is_valid(h)and vim.api.nvim_win_get_config(h).relative==""end,vim.api.nvim_list_wins())local i={}for j,k in ipairs(b.options.window.margin)do if k>0 and k<1 then if j%2==0 then k=math.floor(vim.o.columns*k)else k=math.floor(vim.o.lines*k)end end;i[j]=k end;local l={relative="editor",width=vim.o.columns-i[2]-i[4]-(vim.fn.has("nvim-0.6")==0 and b.options.window.border~="none"and 2 or 0),height=b.options.layout.height.min,focusable=false,anchor="SW",border=b.options.window.border,row=vim.o.lines-i[3]-(vim.fn.has("nvim-0.6")==0 and b.options.window.border~="none"and 2 or 0)+((vim.o.laststatus==0 or vim.o.laststatus==1 and#g==1)and 1 or 0)-vim.o.cmdheight,col=i[4],style="minimal",noautocmd=true,zindex=b.options.window.zindex}if b.options.window.position=="top"then l.anchor="NW"l.row=i[1]end;f.buf=vim.api.nvim_create_buf(false,true)f.win=vim.api.nvim_open_win(f.buf,false,l)vim.api.nvim_buf_set_option(f.buf,"filetype","WhichKey")vim.api.nvim_buf_set_option(f.buf,"buftype","nofile")vim.api.nvim_buf_set_option(f.buf,"bufhidden","wipe")local m="NormalFloat:WhichKeyFloat"if vim.fn.hlexists("FloatBorder")==1 then m=m..",FloatBorder:WhichKeyBorder"end;vim.api.nvim_win_set_option(f.win,"winhighlight",m)vim.api.nvim_win_set_option(f.win,"foldmethod","manual")vim.api.nvim_win_set_option(f.win,"winblend",b.options.window.winblend)end;function f.read_pending()local n=""while true do local o=vim.fn.getchar(0)if o==0 then break end;local p=type(o)=="number"and vim.fn.nr2char(o)or o;if p==d.t("<esc>")then n=n..p;if#n>10 then return end else if n~=""then f.keys=f.keys..n;n=""end;f.keys=f.keys..p end end;if n~=""then f.keys=f.keys..n;n=""end end;function f.getchar()local q,o=pcall(vim.fn.getchar)if not q then return d.t("<esc>")end;local p=type(o)=="number"and vim.fn.nr2char(o)or o;return p end;function f.scroll(r)local s=vim.api.nvim_win_get_height(f.win)local t=vim.api.nvim_win_get_cursor(f.win)if r then t[1]=math.max(t[1]-s,1)else t[1]=math.min(t[1]+s,vim.api.nvim_buf_line_count(f.buf))end;vim.api.nvim_win_set_cursor(f.win,t)end;function f.on_close()f.hide()end;function f.hide()vim.api.nvim_echo({{""}},false,{})f.hide_cursor()if f.buf and vim.api.nvim_buf_is_valid(f.buf)then vim.api.nvim_buf_delete(f.buf,{force=true})f.buf=nil end;if f.win and vim.api.nvim_win_is_valid(f.win)then vim.api.nvim_win_close(f.win,true)f.win=nil end;vim.cmd("redraw")end;function f.show_cursor()local u=vim.api.nvim_get_current_buf()local t=vim.api.nvim_win_get_cursor(0)vim.api.nvim_buf_add_highlight(u,b.namespace,"Cursor",t[1]-1,t[2],t[2]+1)end;function f.hide_cursor()local u=vim.api.nvim_get_current_buf()vim.api.nvim_buf_clear_namespace(u,b.namespace,0,-1)end;function f.back()local v=a.get_tree(f.mode,f.buf).tree:get(f.keys,-1)or a.get_tree(f.mode).tree:get(f.keys,-1)if v then f.keys=v.prefix_i end end;function f.execute(w,x,u)local y=a.get_tree(x).tree:get(w)local z=u and a.get_tree(x,u).tree:get(w)or nil;if y and y.mapping and a.is_hook(w,y.mapping.cmd)then return end;if z and z.mapping and a.is_hook(w,z.mapping.cmd)then return end;local A={}local function B(C,D)for E,v in pairs(C)do if a.is_hooked(v.mapping.prefix,x,D)then table.insert(A,{v.mapping.prefix,D})a.hook_del(v.mapping.prefix,x,D)end end end;B(a.get_tree(x).tree:path(w))if u then B(a.get_tree(x,u).tree:path(w),u)end;local F=d.get_mode()if F=="nii"or F=="nir"or F=="niv"or F=="vs"then vim.api.nvim_feedkeys(d.t("<C-O>"),"n",false)end;if f.reg~='"'and f.mode~="i"and f.mode~="c"then vim.api.nvim_feedkeys('"'..f.reg,"n",false)end;if f.count and f.count~=0 then w=f.count..w end;vim.api.nvim_feedkeys(w,"m",true)vim.defer_fn(function()for E,G in pairs(A)do a.hook_add(G[1],x,G[2])end end,0)end;function f.open(H,l)l=l or{}f.keys=H or""f.mode=l.mode or d.get_mode()f.count=vim.api.nvim_get_vvar("count")f.reg=vim.api.nvim_get_vvar("register")if string.find(vim.o.clipboard,"unnamedplus")and f.reg=="+"then f.reg='"'end;if string.find(vim.o.clipboard,"unnamed")and f.reg=="*"then f.reg='"'end;f.show_cursor()f.on_keys(l)end;function f.is_enabled(u)local I=vim.api.nvim_buf_get_option(u,"buftype")for E,J in ipairs(b.options.disable.buftypes)do if J==I then return false end end;local K=vim.api.nvim_buf_get_option(u,"filetype")for E,J in ipairs(b.options.disable.filetypes)do if J==K then return false end end;return true end;function f.on_keys(l)local u=vim.api.nvim_get_current_buf()while true do f.read_pending()local L=a.get_mappings(f.mode,f.keys,u)if L.mapping and not L.mapping.group and#L.mappings==0 then f.hide()if L.mapping.fn then L.mapping.fn()else f.execute(f.keys,f.mode,u)end;return end;if#L.mappings==0 then f.hide()if l.auto then f.execute(f.keys,f.mode,u)end;return end;local M=c:new(L)if f.is_enabled(u)then if not f.is_valid()then f.show()end;f.render(M:layout(f.win))end;vim.cmd([[redraw]])local p=f.getchar()if p==d.t("<esc>")then f.hide()break elseif p==d.t(b.options.popup_mappings.scroll_down)then f.scroll(false)elseif p==d.t(b.options.popup_mappings.scroll_up)then f.scroll(true)elseif p==d.t("<bs>")then f.back()else f.keys=f.keys..p end end end;function f.render(N)vim.api.nvim_buf_set_lines(f.buf,0,-1,false,N.lines)local s=#N.lines;if s>b.options.layout.height.max then s=b.options.layout.height.max end;vim.api.nvim_win_set_height(f.win,s)if vim.api.nvim_buf_is_valid(f.buf)then vim.api.nvim_buf_clear_namespace(f.buf,b.namespace,0,-1)end;for E,O in ipairs(N.hl)do e(f.buf,b.namespace,O.group,O.line,O.from,O.to)end end;return f