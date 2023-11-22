local a=require('gitsigns.async')local b=require('gitsigns.cache')local c=b.cache;local d=require('gitsigns.signs')local e=require('gitsigns.status')local f=require('gitsigns.debounce').debounce_trailing;local g=require('gitsigns.debounce').throttle_by_id;local h=require('gitsigns.debug.log')local i=h.dprint;local j=h.dprintf;local k=require('gitsigns.system')local l=require('gitsigns.util')local m=require('gitsigns.diff')local n=require('gitsigns.hunks')local o=require('gitsigns.config').config;local p=vim.api;local q;local r;local s={}local function t(u,v,w,x,y,z,A)if z then v:remove(u)end;for B,C in ipairs(w or{})do if z and B==1 then v:add(u,n.calc_signs(C,C.added.start,C.added.start,A))end;if x<=C.vend and y>=C.added.start then v:add(u,n.calc_signs(C,x,y,A))end;if C.added.start>y then break end end end;local function D(u,x,y,z)local E=c[u]if not E then return end;local A=E.git_obj.object_name==nil and not E.base;t(u,q,E.hunks,x,y,z,A)if r then t(u,r,E.hunks_staged,x,y,z,false)end end;local function F(G,H,I,J)if not G then return end;if J~=I then if J<I then l.list_remove(G,J,I)else l.list_insert(G,I,J)end end;for B=math.min(H+1,J),math.max(H+1,J)do G[B]=nil end end;function s.on_lines(K,H,I,J)local E=c[K]if not E then i('Cache for buffer was nil. Detaching')return true end;F(E.blame,H,I,J)q:on_lines(K,H,I,J)if r then r:on_lines(K,H,I,J)end;if E.hunks and q:contains(K,H,J)then E.force_next_update=true end;if r then if E.hunks_staged and r:contains(K,H,J)then E.force_next_update=true end end;s.update_debounced(K)end;local L=p.nvim_create_namespace('gitsigns')local function M(u,N)if vim.fn.foldclosed(N+1)~=-1 then return end;local E=c[u]if not E or not E.hunks then return end;local O=p.nvim_buf_get_lines(u,N,N+1,false)[1]if not O then return end;local P=N+1;local C=n.find_hunk(P,E.hunks)if not C then return end;if C.added.count~=C.removed.count then return end;local Q=P-C.added.start+1;local R=C.added.lines[Q]local S=C.removed.lines[Q]local T,U=require('gitsigns.diff_int').run_word_diff({S},{R})local V=#O;for T,W in ipairs(U)do local X,Y,Z=W[2],W[3]-1,W[4]-1;if Z==Y then Z=Y+1 end;local _=X=='add'and'GitSignsAddLnInline'or X=='change'and'GitSignsChangeLnInline'or'GitSignsDeleteLnInline'local a0={ephemeral=true,priority=1000}if Z>V and Z==Y+1 then a0.virt_text={{' ',_}}a0.virt_text_pos='overlay'else a0.end_col=Z;a0.hl_group=_ end;p.nvim_buf_set_extmark(u,L,N,Y,a0)p.nvim__buf_redraw_range(u,N,N+1)end end;local a1=p.nvim_create_namespace('gitsigns_removed')local a2=300;local function a3(u)local a4=p.nvim_buf_get_extmarks(u,a1,0,-1,{})for T,a5 in ipairs(a4)do p.nvim_buf_del_extmark(u,a1,a5[1])end end;function s.show_deleted(u,a6,C)local a7={}for B,O in ipairs(C.removed.lines)do local a8={}local a9=1;if o.word_diff then local aa=require('gitsigns.diff_int').run_word_diff({C.removed.lines[B]},{C.added.lines[B]})for T,W in ipairs(aa)do local ab,Y,Z=W[1],W[3],W[4]if ab>1 then break end;a8[#a8+1]={O:sub(a9,Y-1),'GitSignsDeleteVirtLn'}a8[#a8+1]={O:sub(Y,Z-1),'GitSignsDeleteVirtLnInline'}a9=Z end end;if#O>0 then a8[#a8+1]={O:sub(a9,-1),'GitSignsDeleteVirtLn'}end;local ac=string.rep(' ',a2-#O)a8[#a8+1]={ac,'GitSignsDeleteVirtLn'}a7[B]=a8 end;local ad=C.added.start==0 and C.type=='delete'local N=ad and 0 or C.added.start-1;p.nvim_buf_set_extmark(u,a6,N,-1,{virt_lines=a7,virt_lines_above=C.type~='delete'or ad})end;local function ae(af,P,ag)local ah,ai=pcall(p.nvim_get_option_value,'statuscolumn',{win=af,scope='local'})if ah and ai and ai~=''then local aj,ak=pcall(p.nvim_eval_statusline,ai,{winid=af,use_statuscol_lnum=P,highlights=true})if aj then return ak.str,ak.highlights end end;return string.format('%'..ag..'d',P)end;function s.show_deleted_in_float(u,a6,C)local al=p.nvim_get_current_win()local a7={}local am=vim.fn.getwininfo(al)[1].textoff;for B=1,C.removed.count do local an=ae(al,C.removed.start+B,am-1)a7[B]={{an,'LineNr'}}end;local ad=C.added.start==0 and C.type=='delete'local ao=C.type~='delete'or ad;local N=ad and 0 or C.added.start-1;p.nvim_buf_set_extmark(u,a6,N,-1,{virt_lines=a7,virt_lines_above=ao,virt_lines_leftcol=true})local E=c[u]local ap=p.nvim_create_buf(false,true)p.nvim_buf_set_lines(ap,0,-1,false,E.compare_text)local ag=p.nvim_win_get_width(0)local aq=ao and not ad and 1 or 0;local ar=p.nvim_open_win(ap,false,{relative='win',win=al,width=ag-am,height=C.removed.count,anchor='SW',bufpos={C.added.start-aq,0},style='minimal'})vim.bo[ap].filetype=vim.bo[u].filetype;vim.bo[ap].bufhidden='wipe'vim.wo[ar].scrolloff=0;p.nvim_win_call(ar,function()vim.cmd('normal '..'zR')vim.cmd('normal '..tostring(C.removed.start)..'gg')vim.cmd('normal '..vim.api.nvim_replace_termcodes('z<CR>',true,false,true))end)local as=p.nvim_buf_line_count(u)for B=C.removed.start,C.removed.start+C.removed.count do p.nvim_buf_set_extmark(ap,a6,B-1,0,{hl_group='GitSignsDeleteVirtLn',hl_eol=true,end_row=B,strict=B==as,priority=1000})end;local at=require('gitsigns.diff_int').run_word_diff(C.removed.lines,C.added.lines)for T,W in ipairs(at)do local au=C.removed.start-1+W[1]-1;local av=W[3]-1;local aw=W[4]-1;p.nvim_buf_set_extmark(ap,a6,au,av,{hl_group='GitSignsDeleteVirtLnInline',end_col=aw,end_row=au,priority=1001})end;return ar end;function s.show_added(u,ax,C)local au=C.added.start-1;for ay=0,C.added.count-1 do local N=au+ay;p.nvim_buf_set_extmark(u,ax,N,0,{end_row=N+1,hl_group='GitSignsAddPreview',hl_eol=true,priority=1000})end;local T,U=require('gitsigns.diff_int').run_word_diff(C.removed.lines,C.added.lines)for T,W in ipairs(U)do local ay,X,Y,Z=W[1]-1,W[2],W[3]-1,W[4]-1;local az=X=='change'and vim.endswith(C.added.lines[ay+1],'\r')p.nvim_buf_set_extmark(u,ax,au+ay,Y,{end_col=Z,strict=not az,hl_group=X=='add'and'GitSignsAddInline'or X=='change'and'GitSignsChangeInline'or'GitSignsDeleteInline',priority=1001})end end;local function aA(u)local E=c[u]a3(u)if o.show_deleted then for T,C in ipairs(E.hunks or{})do s.show_deleted(u,a1,C)end end end;s.buf_check=a.wrap(function(u,aB,aC)vim.schedule(function()if u then if not p.nvim_buf_is_valid(u)then i('Buffer not valid, aborting')return end;if not c[u]then i('Has detached, aborting')return end;if aB and not c[u].compare_text then i('compare_text was invalid, aborting')return end end;aC()end)end,3)local aD=0;s.update=g(function(u)local aE='update's.buf_check(u)local E=c[u]local aF,aG=E.hunks,E.hunks_staged;E.hunks,E.hunks_staged=nil,nil;local aH=E.git_obj;local aI=E:get_compare_rev()local aJ=aI=='FILE'if not E.compare_text or o._refresh_staged_on_update or aJ then E.compare_text=aH:get_show_text(aI)s.buf_check(u,true)end;local aK=l.buf_lines(u)E.hunks=m(E.compare_text,aK)s.buf_check(u)if o._signs_staged_enable and not aJ then if not E.compare_text_head or o._refresh_staged_on_update then local aL=E.commit and string.format('%s^',E.commit)or'HEAD'E.compare_text_head=aH:get_show_text(aL)s.buf_check(u,true)end;local aM=m(E.compare_text_head,aK)s.buf_check(u)E.hunks_staged=n.filter_common(aM,E.hunks)end;if E.force_next_update or n.compare_heads(E.hunks,aF)or n.compare_heads(E.hunks_staged,aG)then D(u,vim.fn.line('w0'),vim.fn.line('w$'),true)aA(u)E.force_next_update=false;p.nvim_exec_autocmds('User',{pattern='GitSignsUpdate',modeline=false})end;local aN=n.get_summary(E.hunks)aN.head=aH.repo.abbrev_head;e:update(u,aN)aD=aD+1;j('updates: %s, jobs: %s',aD,k.job_cnt)end,true)function s.detach(u,aO)if not aO then q:remove(u)if r then r:remove(u)end end end;function s.reset_signs()if q then q:reset()end;if r then r:reset()end end;local function aP(aQ,aR,u,aS,aT)local E=c[u]if not E or not E.hunks then return false end;local aU=math.min(aT,p.nvim_buf_line_count(u))D(u,aS+1,aU+1,false)if not(o.word_diff and o.diff_opts.internal)then return false end end;local function aV(aQ,aR,u,N)M(u,N)end;function s.setup()p.nvim_set_decoration_provider(L,{on_win=aP,on_line=aV})q=d.new(o.signs)if o._signs_staged_enable then r=d.new(o._signs_staged,'staged')end;s.update_debounced=f(o.update_debounce,a.void(s.update))end;return s