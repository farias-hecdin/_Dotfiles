local a=vim.api;local b=vim.o;local c=vim.loop;local d=vim.cmd;local e=vim.fn;local f=vim.schedule;local g=math.min;local h=math.max;local i=math.floor;local j,k,l,m,n,o,p;local q={win=a.nvim_get_current_win(),buf=a.nvim_get_current_buf()}local r={explorer={},picker={}}local s={builtin={}}local t=e.tempname().."-picker"local u=e.tempname().."-explorer"local v=os.getenv("NNN_OPTS")local w=os.getenv("XDG_CONFIG_HOME")or os.getenv("HOME").."/.config"local x=os.getenv("NNN_TMPFILE")or w.."/nnn/.lastd"local y=os.getenv("TMPDIR")or"/tmp"local z=os.getenv("TERM")local A=v and v:gsub("a","")or""local B={explorer={cmd="nnn",width=24,side="topleft",session="",tabs=true,fullscreen=true},picker={cmd="nnn",style={width=0.9,height=0.8,xoffset=0.5,yoffset=0.5,border="single"},session="",tabs=true,fullscreen=true},auto_open={setup=nil,tabpage=nil,empty=false,ft_ignore={"gitcommit"}},auto_close=false,replace_netrw=nil,mappings={},windownav={left="<C-w>h",right="<C-w>l",next="<C-w>w",prev="<C-w>W"},buflisted=false,quitcd=nil,offset=false}local C={foldcolumn="0",number=false,relativenumber=false,spell=false,wrap=false,winfixwidth=true,winfixheight=true,winhighlight="Normal:NnnNormal,NormalNC:NnnNormalNC,FloatBorder:NnnBorder"}local D={filetype="nnn"}local function E(F,G)if a.nvim_win_get_buf(r[F][G].win)~=r[F][G].buf then a.nvim_win_set_buf(r[F][G].win,r[F][G].buf)return end;if#a.nvim_tabpage_list_wins(0)==1 then a.nvim_win_set_buf(r[F][G].win,a.nvim_create_buf(false,false))else a.nvim_win_hide(r[F][G].win)end;r[F][G].win=nil;if q.win then a.nvim_set_current_win(q.win)end end;local function H(I,F)local J={}local K,L;local G=a.nvim_get_current_tabpage()local M,N=pcall(a.nvim_win_get_tabpage,q.win)if not q.win or G~=N then q.win=nil;for M,O in pairs(a.nvim_tabpage_list_wins(0))do if a.nvim_buf_get_name(a.nvim_win_get_buf(O))==""then K=O;break end;if a.nvim_buf_get_option(0,"filetype")~="nnn"then L=O end end;if not K and not L then d(("%s %svsplit"):format(m,b.columns-B.explorer.width-1))q.win=a.nvim_get_current_win()end end;a.nvim_set_current_win(q.win or K or L)for P in I do if j then J[#J+1]=e.fnameescape(P)else pcall(d,"edit "..e.fnameescape(P))end end;if F=="explorer"and r[F][G].fs then a.nvim_win_close(r[F][G].win,{force=true})s.toggle("explorer",false,false)d("vert resize +1 | vert resize -1 | wincmd p")end;if j then f(function()j(J)j=nil end)end end;local function Q()c.fs_open(u,"r+",438,function(R,S)if R then f(function()print(R)end)else local T=c.new_pipe(false)if not T then f(function()print("nnn.nvim: creating new explorer pipe failed")end)return end;T:open(S)T:read_start(function(U,V)if not U and V then f(function()H(V:gmatch("[^\n]+"),"explorer")end)else T:close()end end)end end)end;local function W(X,Y)local Z=c.fs_stat(X)return Z and Z.type==Y end;local function _(a0,F)for G,a1 in pairs(r[F])do if a1.id==a0 then return G,a1.win end end end;local function a2(a0,a3)local F="explorer"local G,O=_(a0,F)if not G then F="picker"G,O=_(a0,F)end;if not G then return end;r[F][G]={}if a3>0 then f(function()print(k and k[1]:sub(1,-2))end)else if B.quitcd then local S,M=io.open(x,"r")if S then d(B.quitcd..e.fnameescape(S:read():sub(5,-2)))S:close()os.remove(x)end end;if a.nvim_win_is_valid(O)then if#a.nvim_tabpage_list_wins(0)==1 then d("split")end;a.nvim_win_hide(O)local a4=a.nvim_list_bufs()if a.nvim_buf_get_name(a4[#a4])==""then a.nvim_buf_delete(a4[#a4],{})end end;if F=="picker"and W(t,"file")then H(io.lines(t),"picker")end end;if q then a.nvim_set_current_win(q.win)end end;local function a5(M,a6,M)k=a6 end;local function a7(a8)a.nvim_feedkeys(a.nvim_replace_termcodes(a8,true,true,true),"n",true)end;local function a9()for aa,ab in pairs(D)do a.nvim_buf_set_option(0,aa,ab)end;local ac={noremap=true}for ad,ae in ipairs(B.mappings)do a.nvim_buf_set_keymap(0,"t",ae[1],"<C-\\><C-n><cmd>lua require('nnn').handle_mapping("..ad..")<CR>",ac)end;a.nvim_buf_set_keymap(0,"t",B.windownav.left,"<C-\\><C-n><C-w>h",ac)a.nvim_buf_set_keymap(0,"t",B.windownav.right,"<C-\\><C-n><C-w>l",ac)a.nvim_buf_set_keymap(0,"t",B.windownav.next,"<C-\\><C-n><C-w>w",ac)a.nvim_buf_set_keymap(0,"t",B.windownav.prev,"<C-\\><C-n><C-w>W",ac)end;local function af(O,ag)a.nvim_win_call(O,function()d(a.nvim_buf_is_valid(q.buf)and q.buf~=ag and q.buf.."buffer"or"enew")end)end;local function ah(ai)local aj=b.lines;local ak=b.columns;local al={relative="editor",style="minimal",height=aj,width=ak,row=0,col=0}local am=B.picker.style;if ai then al.height=al.height-b.cmdheight else al.height=g(h(0,i(am.height>1 and am.height or aj*am.height)),aj)-1;al.width=g(h(0,i(am.width>1 and am.width or ak*am.width)),ak)-1;local an=i(am.yoffset>1 and am.yoffset or am.yoffset*(aj-al.height))-1;local ao=i(am.xoffset>1 and am.xoffset or am.xoffset*(ak-al.width))-1;al.row=g(h(0,an),aj-al.height)al.col=g(h(0,ao),ak-al.width)al.border=B.picker.style.border end;if B.offset then local P=io.open(y.."/nnn-preview-tui-posoffset","w")if P then P:write(al.col+1 .." "..al.row+1 .."\n")P:close()end end;return al end;local function ap(F,G)if B[F].tabs then return r[F][G]and r[F][G].buf end;for M,a1 in pairs(r[F])do if a1.buf then return a1.buf end end end;local function aq(F,G,ar,ai)local ag=ap(F,G)local as=not ag;local O,al;if as then ag=ar and a.nvim_get_current_buf()or a.nvim_create_buf(B.buflisted,false)end;if F=="picker"or ai then al=ah(ai)O=a.nvim_open_win(ag,true,al)else d(B.explorer.side.." "..B.explorer.width.."vsplit")O=a.nvim_get_current_win()end;a.nvim_win_set_buf(O,ag)return O,ag,as end;local function at(F,G,ar,K)local a0=r[F][G]and r[F][G].id;local au=a.nvim_get_current_win()local av=B[F].fullscreen and#a.nvim_tabpage_list_wins(0)==1 and K;local O,ag,as=aq(F,G,ar,av)if as then local aw=p and p or B[F].cmd;if l then aw=aw.." "..e.shellescape(l)end;a0=e.termopen(aw,{cwd=not l and e.getcwd()or nil,env=F=="picker"and{TERM=z}or{TERM=z,NNN_OPTS=A,NNN_FIFO=u},on_exit=a2,on_stdout=a5,stdout_buffered=true})p=nil;a9()if F=="explorer"then Q(G)end else a.nvim_win_set_buf(O,ag)end;for aa,ab in pairs(C)do a.nvim_win_set_option(0,aa,ab)end;r[F][G]={win=O,buf=ag,id=a0,fs=av}d("startinsert")if ar then af(au,ag)end end;function s.toggle(F,ax,ay)local az;local aA=a.nvim_buf_get_name(0)local ar=W(aA,"directory")local K=(ar and e.bufname("#")or aA)==""local G=a.nvim_get_current_tabpage()if ax then for M,aB in ipairs(ax)do if aB:find("^cmd=")then p=aB:sub(5)..(F=="picker"and" -p "..t..n or" -F1 "..o)else az=aB end end end;if ay=="netrw"then if not ar then return end;if r[F][G]and r[F][G].buf then a.nvim_buf_delete(r[F][G].buf,{force=true})r[F][G]={}end elseif(ay=="setup"or ay=="tab")and(B.auto_open.empty and(not K and not ar)or vim.tbl_contains(B.auto_open.ft_ignore,a.nvim_buf_get_option(0,"filetype")))then return end;l=az and e.expand(az)or ar and aA;local O=r[F][G]and r[F][G].win;if O and a.nvim_win_is_valid(O)then E(F,G)else at(F,G,ar,K)end end;function s.handle_mapping(aC)j=B.mappings[aC][2]a7("i<CR>")end;function s.win_enter()f(function()if a.nvim_buf_get_option(a.nvim_win_get_buf(0),"filetype")~="nnn"then q.win=a.nvim_get_current_win()q.buf=a.nvim_get_current_buf()elseif#a.nvim_tabpage_list_wins(0)==1 then q.win=nil end end)end;function s.win_closed()if a.nvim_win_get_config(0).zindex then return end;f(function()if a.nvim_buf_get_option(0,"filetype")~="nnn"then return end;local aD=0;for M,O in ipairs(a.nvim_tabpage_list_wins(0))do if not a.nvim_win_get_config(O).zindex then aD=aD+1 end end;if aD==1 then a7("<C-\\><C-n><cmd>q<CR>")end end)end;function s.tab_closed(G)local ag=r.explorer[G]and r.explorer[G].buf;if ag and a.nvim_buf_is_valid(ag)then a.nvim_buf_delete(ag,{force=true})end end;function s.vim_resized()local O,av;local G=a.nvim_get_current_tabpage()if r.picker[G]then av=r.picker[G].fs;O=r.picker[G].win else av=r.explorer[G]and r.explorer[G].fs;O=av and r.explorer[G]and r.explorer[G].win or nil end;if O and a.nvim_win_is_valid(O)then a.nvim_win_set_config(O,ah(av))end end;local function aE(J,aF)for M,P in ipairs(J)do d(aF.." "..P)end end;function s.builtin.open_in_split(J)aE(J,"split")end;function s.builtin.open_in_vsplit(J)aE(J,"vsplit")end;function s.builtin.open_in_tab(J)d("tabnew")aE(J,"edit")a7("<C-\\><C-n><C-w>h")end;function s.builtin.open_in_preview(J)local aG=a.nvim_get_current_buf()local aH=a.nvim_buf_get_name(aG)if aH==J[1]then return end;d("edit "..J[1])if aH~=""then a.nvim_buf_delete(aG,{})end;d("wincmd p")end;function s.builtin.copy_to_clipboard(J)J=table.concat(J,"\n")e.setreg("+",J)vim.defer_fn(function()print(J:gsub("\n",", ").." copied to register")end,0)end;function s.builtin.cd_to_path(J)local az=J[1]:match(".*/"):sub(0,-2)local aI=io.open(az:gsub("\\",""),"r")if aI~=nil then io.close(aI)e.execute("cd "..az)vim.defer_fn(function()print("working directory changed to: "..az)end,0)end end;function s.builtin.populate_cmdline(J)a7(": "..table.concat(J,"\n"):gsub("\n"," ").."<C-b>")end;function s.setup(aJ)if aJ then B=vim.tbl_deep_extend("force",B,aJ)end;if B.replace_netrw then vim.g.loaded_netrw=1;vim.g.loaded_netrwPlugin=1;vim.g.loaded_netrwSettings=1;vim.g.loaded_netrwFileHandlers=1;pcall(a.nvim_clear_autocmds,{group="FileExplorer"})f(function()s.toggle(B.replace_netrw,nil,"netrw")a.nvim_create_autocmd({"BufEnter","BufNewFile"},{callback=function()require("nnn").toggle(B.replace_netrw,nil,"netrw")end})end)end;local aK="nnn.nvim-"..os.date("%Y-%m-%d_%H-%M-%S")local aL=e.fnameescape(w.."/nnn/sessions/"..aK)if B.picker.session=="shared"or B.explorer.session=="shared"then n=" -S -s "..aK;o=n;a.nvim_create_autocmd("VimLeavePre",{command="call delete('"..aL.."')"})else if B.picker.session=="global"then n=" -S "elseif B.picker.session=="local"then n=" -S -s "..aK.."-picker"a.nvim_create_autocmd("VimLeavePre",{command="call delete('"..aL.."-picker')"})else n=" "end;if B.explorer.session=="global"then o=" -S "elseif B.explorer.session=="local"then o=" -S -s "..aK.."-explorer "a.nvim_create_autocmd("VimLeavePre",{command="call delete('"..aL.."-explorer')"})else o=" "end end;if not W(u,"fifo")then os.execute("mkfifo "..u)end;m=B.explorer.side:match("to")and"botright "or"topleft "B.picker.cmd=B.picker.cmd.." -p "..t..n;B.explorer.cmd=B.explorer.cmd.." -F1 "..o;if B.auto_open.setup and not(B.replace_netrw and W(a.nvim_buf_get_name(0),"directory"))then f(function()s.toggle(B.auto_open.setup,nil,"setup")end)end;if B.auto_close then a.nvim_create_autocmd("WinClosed",{callback=function()require("nnn").win_closed()end})end;if B.auto_open.tabpage then a.nvim_create_autocmd("TabNewEntered",{callback=function()vim.schedule(function()require("nnn").toggle(B.auto_open.tabpage,nil,"tab")end)end})end;a.nvim_create_user_command("NnnPicker",function(ac)require("nnn").toggle("picker",ac.fargs)end,{nargs="*"})a.nvim_create_user_command("NnnExplorer",function(ac)require("nnn").toggle("explorer",ac.fargs)end,{nargs="*"})local aM=a.nvim_create_augroup("nnn",{clear=true})a.nvim_create_autocmd("WinEnter",{group=aM,callback=function()require("nnn").win_enter()end})a.nvim_create_autocmd("TermClose",{group=aM,callback=function()if a.nvim_buf_get_option(0,"filetype")=="nnn"then a.nvim_buf_delete(0,{force=true})end end})a.nvim_create_autocmd("BufEnter",{group=aM,callback=function()if a.nvim_buf_get_option(0,"filetype")=="nnn"then vim.cmd("startinsert")end end})a.nvim_create_autocmd("VimResized",{group=aM,callback=function()if a.nvim_buf_get_option(0,"filetype")=="nnn"then require("nnn").vim_resized()end end})a.nvim_create_autocmd("TabClosed",{group=aM,callback=function(aN)require("nnn").tab_closed(tonumber(aN.file))end})a.nvim_set_hl(0,"NnnBorder",{link="FloatBorder",default=true})a.nvim_set_hl(0,"NnnNormal",{link="Normal",default=true})a.nvim_set_hl(0,"NnnNormalNC",{link="Normal",default=true})end;return s
