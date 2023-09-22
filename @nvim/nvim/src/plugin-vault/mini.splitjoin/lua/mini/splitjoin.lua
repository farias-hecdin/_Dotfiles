local a={}local b={}a.setup=function(c)_G.MiniSplitjoin=a;c=b.setup_config(c)b.apply_config(c)end;a.config={mappings={toggle='gS',split='',join=''},detect={brackets=nil,separator=',',exclude_regions=nil},split={hooks_pre={},hooks_post={}},join={hooks_pre={},hooks_post={}}}a.toggle=function(d)if b.is_disabled()then return end;d=b.get_opts(d)local e=d.region or b.find_smallest_bracket_region(d.position,d.detect.brackets)if e==nil then return end;d.region=e;if e.from.line==e.to.line then return a.split(d)else return a.join(d)end end;a.split=function(d)if b.is_disabled()then return end;d=b.get_opts(d)local e=d.region or b.find_smallest_bracket_region(d.position,d.detect.brackets)if e==nil then return nil end;local f=b.find_split_positions(e,d.detect.separator,d.detect.exclude_regions)if#f==0 then return nil end;for g,h in ipairs(d.split.hooks_pre)do f=h(f)end;local i=a.split_at(f)local j=i[#i]local k=vim.fn.getline(j.line+1)local l=a.get_indent_part(k):len()+1;table.insert(i,{line=j.line+1,col=l})for g,h in ipairs(d.split.hooks_post)do i=h(i)end;return i end;a.join=function(d)if b.is_disabled()then return end;d=b.get_opts(d)local e=d.region or b.find_smallest_bracket_region(d.position,d.detect.brackets)if e==nil then return nil end;local f=b.find_join_positions(e)if#f==0 then return nil end;for g,h in ipairs(d.join.hooks_pre)do f=h(f)end;local m=a.join_at(f)local j=m[#m]table.insert(m,{line=j.line,col=j.col+1})for g,h in ipairs(d.join.hooks_post)do m=h(m)end;return m end;a.gen_hook={}a.gen_hook.pad_brackets=function(d)d=d or{}local n=d.pad or' 'local o=d.brackets or b.get_opts(d).detect.brackets;local p=n:len()return function(m)local q=#m;if q==0 or n==''then return m end;local r,j=m[1],m[q]local s=b.is_positions_inside_brackets(r,j,o)if not s then return m end;if r.line==j.line and j.col-r.col<=1 then return m end;b.set_text(r.line-1,j.col-1,r.line-1,j.col-1,{n})b.set_text(r.line-1,r.col,r.line-1,r.col,{n})for t=2,q do m[t].col=m[t].col+p end;m[q].col=m[q].col+p;return m end end;a.gen_hook.add_trailing_separator=function(d)d=d or{}local u=d.sep or','local o=d.brackets or b.get_opts(d).detect.brackets;return function(i)local q=#i;if q<3 then return i end;local r,j=i[1],i[q]local s=b.is_positions_inside_brackets(r,j,o)if not s then return i end;local v=vim.fn.getline(j.line-1)local w=v:find(vim.pesc(u)..'$')if w~=nil then return i end;local x=v:len()b.set_text(j.line-2,x,j.line-2,x,{u})return i end end;a.gen_hook.del_trailing_separator=function(d)d=d or{}local u=d.sep or','local o=d.brackets or b.get_opts(d).detect.brackets;local y=u:len()return function(m)local q=#m;if q==0 then return m end;local r,j=m[1],m[q]local s=b.is_positions_inside_brackets(r,j,o)if not s then return m end;local v=vim.fn.getline(j.line):sub(1,j.col-1)local w=v:find(vim.pesc(u)..'%s*$')if w==nil then return m end;b.set_text(j.line-1,w-1,j.line-1,w-1+y,{})m[q]={line=j.line,col=j.col-y}return m end end;a.split_at=function(f)local q=#f;if q==0 then return{}end;local z=b.put_extmark_at_positions({b.get_cursor_pos()})[1]local A=b.put_extmark_at_positions(f)for t=1,q do b.split_at_extmark(A[t])end;local B=b.get_extmark_pos(A[1])local C=b.get_extmark_pos(A[q])b.increase_indent(B.line+1,C.line)b.put_cursor_at_extmark(z)local D=vim.tbl_map(b.get_extmark_pos,A)vim.api.nvim_buf_clear_namespace(0,b.ns_id,0,-1)return D end;a.join_at=function(f)local q=#f;if q==0 then return{}end;local z=b.put_extmark_at_positions({b.get_cursor_pos()})[1]local A=b.put_extmark_at_positions(f)for t=1,q do local E=(t==1 or t==q)and''or' 'b.join_at_extmark(A[t],E)end;b.put_cursor_at_extmark(z)local D=vim.tbl_map(b.get_extmark_pos,A)vim.api.nvim_buf_clear_namespace(0,b.ns_id,0,-1)return D end;a.get_visual_region=function()local F,G=vim.fn.getpos("'<"),vim.fn.getpos("'>")local H,I={line=F[2],col=F[3]},{line=G[2],col=G[3]}if vim.fn.visualmode()=='V'then H.col,I.col=1,vim.fn.col({I.line,'$'})-1 end;return{from=H,to=I}end;a.get_indent_part=function(J,K)if K==nil then K=true end;if not K then return J:match('^%s*')end;local L=b.get_comment_indent(J,b.get_comment_leaders())if L~=''then return L end;return J:match('^%s*')end;a.operator=function(M)local N=M=='toggle'or M=='split'or M=='join'if not N then a[b.cache.operator_task]()return''end;if b.is_disabled()then return[[\<Esc>]]end;b.cache.operator_task=M;vim.o.operatorfunc='v:lua.MiniSplitjoin.operator'return'g@'end;b.default_config=a.config;b.ns_id=vim.api.nvim_create_namespace('MiniSplitjoin')b.cache={operator_task=nil}b.setup_config=function(c)vim.validate({config={c,'table',true}})c=vim.tbl_deep_extend('force',b.default_config,c or{})vim.validate({mappings={c.mappings,'table'},detect={c.detect,'table'},split={c.split,'table'},join={c.join,'table'}})vim.validate({['mappings.toggle']={c.mappings.toggle,'string',true},['mappings.split']={c.mappings.split,'string'},['mappings.join']={c.mappings.join,'string',true},['detect.brackets']={c.detect.brackets,'table',true},['detect.separator']={c.detect.separator,'string'},['detect.exclude_regions']={c.detect.exclude_regions,'table',true},['split.hooks_pre']={c.split.hooks_pre,'table'},['split.hooks_post']={c.split.hooks_post,'table'},['join.hooks_pre']={c.join.hooks_pre,'table'},['join.hooks_post']={c.join.hooks_post,'table'}})return c end;b.apply_config=function(c)a.config=c;local O=c.mappings;b.map('n',O.toggle,'v:lua.MiniSplitjoin.operator("toggle") . " "',{expr=true,desc='Toggle arguments'})b.map('n',O.split,'v:lua.MiniSplitjoin.operator("split") . " "',{expr=true,desc='Split arguments'})b.map('n',O.join,'v:lua.MiniSplitjoin.operator("join") . " "',{expr=true,desc='Join arguments'})b.map('x',O.toggle,':<C-u>lua MiniSplitjoin.toggle({ region = MiniSplitjoin.get_visual_region() })<CR>',{desc='Toggle arguments'})b.map('x',O.split,':<C-u>lua MiniSplitjoin.split({ region = MiniSplitjoin.get_visual_region() })<CR>',{desc='Split arguments'})b.map('x',O.join,':<C-u>lua MiniSplitjoin.join({ region = MiniSplitjoin.get_visual_region() })<CR>',{desc='Join arguments'})end;b.is_disabled=function()return vim.g.minisplitjoin_disable==true or vim.b.minisplitjoin_disable==true end;b.get_config=function(c)return vim.tbl_deep_extend('force',a.config,vim.b.minisplitjoin_config or{},c or{})end;b.get_opts=function(d)d=d or{}local P={brackets={'%b()','%b[]','%b{}'},separator=',',exclude_regions={'%b()','%b[]','%b{}','%b""',"%b''"}}local c=b.get_config()return{position=d.position or b.get_cursor_pos(),region=d.region,detect=vim.tbl_extend('force',P,c.detect,d.detect or{}),split=vim.tbl_deep_extend('force',c.split,d.split or{}),join=vim.tbl_deep_extend('force',c.join,d.join or{})}end;b.split_at_extmark=function(Q)local R=b.get_extmark_pos(Q)b.set_text(R.line-1,R.col,R.line-1,R.col,{'',''})local S=vim.fn.getline(R.line)local T=S:find('%s*$')b.set_text(R.line-1,T-1,R.line-1,S:len(),{})local U=a.get_indent_part(vim.fn.getline(R.line+1))local V=a.get_indent_part(S)b.set_text(R.line,0,R.line,U:len(),{V})end;b.find_split_positions=function(e,W,X)local Y=b.find_separator_positions(e,W,X)local q=#Y;Y[q].col=Y[q].col-1;return Y end;b.join_at_extmark=function(Q,n)local Z=b.get_extmark_pos(Q).line;if vim.api.nvim_buf_line_count(0)<=Z then return end;local _=vim.api.nvim_buf_get_lines(0,Z-1,Z+1,true)local a0=_[1]:len()-_[1]:match('%s*$'):len()local a1=a.get_indent_part(_[2]):len()b.set_text(Z-1,a0,Z,a1,{n})end;b.find_join_positions=function(e,W,X)local _=vim.api.nvim_buf_get_lines(0,e.from.line-1,e.to.line,true)local D={}local a2=e.from.line-1;for t=1,#_-1 do table.insert(D,{line=a2+t,col=_[t]:len()})end;return D end;b.find_smallest_bracket_region=function(a3,o)local a4=b.get_neighborhood()local a5=a4.pos_to_offset(a3)local a6=b.find_smallest_covering(a4['1d'],a5,o)if a6==nil then return nil end;return a4.span_to_region(a6)end;b.find_smallest_covering=function(J,a7,a8)local D,a9=nil,math.huge;for g,aa in ipairs(a8)do local ab=0;local ac,ad=string.find(J,aa,ab)while ac do if ac<=a7 and a7<=ad and ad-ac<a9 then D,a9={from=ac,to=ad},ad-ac end;ab=ac+1;ac,ad=string.find(J,aa,ab)end end;return D end;b.find_separator_positions=function(e,W,X)if W==''then return{e.from,e.to}end;local a4=b.get_neighborhood()local ae=a4.region_to_span(e)local af=a4['1d']:sub(ae.from,ae.to)local ag={}af:gsub(W..'()',function(ah)table.insert(ag,ah-1)end)local ai,aj=af:sub(2,-2),{}local ak=function(al,ah)table.insert(aj,{from=al+1,to=ah})end;for g,am in ipairs(X)do ai:gsub('()'..am..'()',ak)end;ai:gsub('()'..W..'%s*()$',ak)local an=vim.tbl_filter(function(ao)return not b.is_offset_inside_spans(ao,aj)end,ag)if af:len()>2 then table.insert(an,1,1)end;table.insert(an,af:len())local ap=ae.from;return vim.tbl_map(function(aq)return a4.offset_to_pos(ap+aq-1)end,an)end;b.is_offset_inside_spans=function(ar,as)for g,at in ipairs(as)do if at.from<=ar and ar<=at.to then return true end end;return false end;b.is_positions_inside_brackets=function(F,G,o)local au=vim.api.nvim_buf_get_text(0,F.line-1,F.col-1,G.line-1,G.col,{})local av=table.concat(au,'\n')for g,aw in ipairs(o)do if av:find('^'..aw..'$')~=nil then return true end end;return false end;b.is_char_at_position=function(a3,ax)local ay=vim.fn.getline(a3.line):sub(a3.col,a3.col)return ay==ax end;b.get_neighborhood=function()local az=vim.api.nvim_buf_get_lines(0,0,-1,false)for aA,aB in pairs(az)do az[aA]=aB..'\n'end;local aC=table.concat(az,'')local aD=#az;local aE={}local a5=0;for t=1,aD do aE[t]=a5;a5=a5+az[t]:len()end;local aF=function(R)return aE[R.line]+R.col end;local aG=function(aH)for t=1,aD-1 do if aE[t]<aH and aH<=aE[t+1]then return{line=t,col=aH-aE[t]}end end;return{line=aD,col=aH-aE[aD]}end;local aI=function(e)return{from=aF(e.from),to=aF(e.to)}end;local aJ=function(at)return{from=aG(at.from),to=aG(at.to)}end;return{['1d']=aC,['2d']=az,pos_to_offset=aF,offset_to_pos=aG,region_to_span=aI,span_to_region=aJ}end;b.put_extmark_at_positions=function(f)return vim.tbl_map(function(R)return vim.api.nvim_buf_set_extmark(0,b.ns_id,R.line-1,R.col-1,{})end,f)end;b.get_extmark_pos=function(Q)local D=vim.api.nvim_buf_get_extmark_by_id(0,b.ns_id,Q,{})return{line=D[1]+1,col=D[2]+1}end;b.get_cursor_pos=function()local aK=vim.api.nvim_win_get_cursor(0)return{line=aK[1],col=aK[2]+1}end;b.put_cursor_at_extmark=function(aL)local aM=vim.api.nvim_buf_get_extmark_by_id(0,b.ns_id,aL,{})vim.api.nvim_win_set_cursor(0,{aM[1]+1,aM[2]})vim.api.nvim_buf_del_extmark(0,b.ns_id,aL)end;b.increase_indent=function(aN,aO)local _=vim.api.nvim_buf_get_lines(0,aN-1,aO,true)local aP=b.get_comment_leaders()local K=b.is_comment_block(_,aP)local n=vim.bo.expandtab and string.rep(' ',vim.fn.shiftwidth())or'\t'for t,al in ipairs(_)do local aQ=a.get_indent_part(al,K):len()local aR=al:len()==aQ and''or n;local Z=aN+t-1;b.set_text(Z-1,aQ,Z-1,aQ,{aR})end end;b.get_comment_indent=function(J,aP)local D=''for g,aS in ipairs(aP)do local aT=J:match('^%s*'..vim.pesc(aS)..'%s*')if type(aT)=='string'and D:len()<aT:len()then D=aT end end;return D end;b.get_comment_leaders=function()local D={}local aU=vim.split(vim.bo.commentstring,'%%s')[1]table.insert(D,vim.trim(aU))for g,aV in ipairs(vim.opt_local.comments:get())do local aW,aX=aV:match('^(.*):(.*)$')aX=vim.trim(aX)if aW:find('b')then table.insert(D,aX..' ')table.insert(D,aX..'\t')elseif aW:find('f')==nil then table.insert(D,aX)end end;return D end;b.is_comment_block=function(_,aP)for g,al in ipairs(_)do if not b.is_commented(al,aP)then return false end end;return true end;b.is_commented=function(J,aP)for g,aS in ipairs(aP)do if J:find('^%s*'..vim.pesc(aS)..'%s*')~=nil then return true end end;return false end;b.error=function(aY)error(string.format('(mini.splitjoin) %s',aY),0)end;b.map=function(aZ,a_,b0,d)if a_==''then return end;d=vim.tbl_deep_extend('force',{silent=true},d or{})vim.keymap.set(aZ,a_,b0,d)end;b.set_text=function(b1,b2,b3,b4,b5)local b6=pcall(vim.api.nvim_buf_set_text,0,b1,b2,b3,b4,b5)if not b6 or#b5==0 then return end;local b7=vim.api.nvim_win_get_cursor(0)if b1+1==b7[1]and b2==b7[2]then vim.api.nvim_win_set_cursor(0,{b7[1],b7[2]+b5[1]:len()})end end;return a
