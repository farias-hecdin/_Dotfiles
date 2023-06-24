local a={}local b={}a.setup=function(c)if vim.fn.has('nvim-0.7')==0 then vim.notify('(mini.starter) Neovim<0.7 is soft deprecated (module works but not supported).'..' It will be deprecated after Neovim 0.9.0 release (module will not work).'..' Please update your Neovim version.')end;_G.MiniStarter=a;c=b.setup_config(c)b.apply_config(c)vim.api.nvim_exec([[augroup MiniStarter
        au!
        au VimEnter * ++nested ++once lua MiniStarter.on_vimenter()
      augroup END]],false)vim.api.nvim_exec([[hi default link MiniStarterCurrent    NONE
      hi default link MiniStarterFooter     Title
      hi default link MiniStarterHeader     Title
      hi default link MiniStarterInactive   Comment
      hi default link MiniStarterItem       Normal
      hi default link MiniStarterItemBullet Delimiter
      hi default link MiniStarterItemPrefix WarningMsg
      hi default link MiniStarterSection    Delimiter
      hi default link MiniStarterQuery      MoreMsg]],false)end;a.config={autoopen=true,evaluate_single=false,items=nil,header=nil,footer=nil,content_hooks=nil,query_updaters='abcdefghijklmnopqrstuvwxyz0123456789_-.',silent=false}a.on_vimenter=function()if a.config.autoopen and not b.is_something_shown()then b.is_in_vimenter=true;a.open()end end;a.open=function(d)if b.is_disabled()then return end;if b.is_in_vimenter then d=vim.api.nvim_get_current_buf()end;if d==nil or not vim.api.nvim_buf_is_valid(d)then d=vim.api.nvim_create_buf(false,true)end;b.buffer_data[d]={current_item_id=1,query=''}local e=vim.b.ministarter_config;vim.api.nvim_set_current_buf(d)vim.b.ministarter_config=e;b.make_buffer_autocmd(d)b.apply_buffer_options(d)b.apply_buffer_mappings(d)a.refresh()vim.cmd('doautocmd User MiniStarterOpened')b.is_in_vimenter=false end;a.refresh=function(d)d=d or vim.api.nvim_get_current_buf()if not b.validate_starter_buf_id(d,'refresh()')then return end;local f=b.buffer_data[d]local c=b.get_config()f.header=b.normalize_header_footer(c.header or b.default_header)local g=b.normalize_items(c.items or b.default_items)f.footer=b.normalize_header_footer(c.footer or b.default_footer)local h=b.make_initial_content(f.header,g,f.footer)local i=c.content_hooks or b.default_content_hooks;for j,k in ipairs(i)do h=k(h,d)end;f.content=h;local l=f.items;f.items=a.content_to_items(h)if not vim.deep_equal(f.items,l)then f.current_item_id=1 end;vim.api.nvim_buf_set_option(d,'modifiable',true)vim.api.nvim_buf_set_lines(d,0,-1,false,a.content_to_lines(h))vim.api.nvim_buf_set_option(d,'modifiable',false)b.content_highlight(d)b.items_highlight(d)b.position_cursor_on_current_item(d)b.add_hl_current_item(d)b.make_query(d)end;a.close=function(d)d=d or vim.api.nvim_get_current_buf()if not b.validate_starter_buf_id(d,'close()')then return end;pcall(vim.api.nvim_buf_delete,d,{})end;a.sections={}a.sections.builtin_actions=function()return{{name='Edit new buffer',action='enew',section='Builtin actions'},{name='Quit Neovim',action='qall',section='Builtin actions'}}end;a.sections.sessions=function(m,n)m=m or 5;if n==nil then n=true end;return function()if _G.MiniSessions==nil then return{{name=[['mini.sessions' is not set up]],action='',section='Sessions'}}end;local g={}for o,p in pairs(_G.MiniSessions.detected)do table.insert(g,{_session=p,name=('%s%s'):format(o,p.type=='local'and' (local)'or''),action=([[lua _G.MiniSessions.read('%s')]]):format(o),section='Sessions'})end;if vim.tbl_count(g)==0 then return{{name=[[There are no detected sessions in 'mini.sessions']],action='',section='Sessions'}}end;local q;if n then q=function(r,s)local t=r._session.type=='local'and math.huge or r._session.modify_time;local u=s._session.type=='local'and math.huge or s._session.modify_time;return t>u end else q=function(r,s)local v=r._session.type=='local'and''or r.name;local w=s._session.type=='local'and''or s.name;return v<w end end;table.sort(g,q)return vim.tbl_map(function(x)x._session=nil;return x end,vim.list_slice(g,1,m))end end;a.sections.recent_files=function(m,y,z)m=m or 5;if y==nil then y=false end;if z==nil then z=true end;return function()local A=('Recent files%s'):format(y and' (current directory)'or'')local B=vim.tbl_filter(function(k)return vim.fn.filereadable(k)==1 end,vim.v.oldfiles or{})if#B==0 then return{{name='There are no recent files (`v:oldfiles` is empty)',action='',section=A}}end;if y then local C='^'..vim.pesc(vim.fn.getcwd())..'%/'B=vim.tbl_filter(function(k)return vim.fn.fnamemodify(k,':p'):find(C)~=nil end,B)end;if#B==0 then return{{name='There are no recent files in current directory',action='',section=A}}end;local g={}local D=vim.fn.fnamemodify;for j,k in ipairs(vim.list_slice(B,1,m))do local E=z and(' (%s)'):format(D(k,':~:.'))or''local F=('%s%s'):format(D(k,':t'),E)table.insert(g,{action=('edit %s'):format(D(k,':p')),name=F,section=A})end;return g end end;a.sections.telescope=function()return function()return{{action='Telescope file_browser',name='Browser',section='Telescope'},{action='Telescope command_history',name='Command history',section='Telescope'},{action='Telescope find_files',name='Files',section='Telescope'},{action='Telescope help_tags',name='Help tags',section='Telescope'},{action='Telescope live_grep',name='Live grep',section='Telescope'},{action='Telescope oldfiles',name='Old files',section='Telescope'}}end end;a.gen_hook={}a.gen_hook.padding=function(G,H)G=math.max(G or 0,0)H=math.max(H or 0,0)return function(h,j)local I=string.rep(' ',G)for j,J in ipairs(h)do local K=#J==0 or#J==1 and J[1].string==''if not K then table.insert(J,1,b.content_unit(I,'empty',nil))end end;local L={}for j=1,H do table.insert(L,{b.content_unit('','empty',nil)})end;h=vim.list_extend(L,h)return h end end;a.gen_hook.adding_bullet=function(M,N)M=M or'░ 'if N==nil then N=true end;return function(h)local O=a.content_coords(h,'item')for P=#O,1,-1 do local Q,R=O[P].line,O[P].unit;local S={string=M,type='item_bullet',hl='MiniStarterItemBullet',_item=h[Q][R].item,_place_cursor=N}table.insert(h[Q],R,S)end;return h end end;a.gen_hook.indexing=function(T,U)T=T or'all'U=U or{}local V=T=='section'return function(h,j)local W,X,Y=nil,0,0;local O=a.content_coords(h,'item')for j,Z in ipairs(O)do local _=h[Z.line][Z.unit]local a0=_.item;if not vim.tbl_contains(U,a0.section)then Y=Y+1;if W~=a0.section then W=a0.section;X=math.fmod(X,26)+1;Y=V and 1 or Y end;local a1=V and string.char(96+X)or''_.string=('%s%s. %s'):format(a1,Y,_.string)end end;return h end end;a.gen_hook.aligning=function(a2,a3)a2=a2 or'left'a3=a3 or'top'local a4=({left=0,center=0.5,right=1.0})[a2]local a5=({top=0,center=0.5,bottom=1.0})[a3]return function(h,d)local a6=vim.fn.bufwinid(d)if a6<0 then return end;local a7=a.content_to_lines(h)local a8=vim.tbl_map(function(a9)return vim.fn.strdisplaywidth(a9)end,a7)local aa=vim.api.nvim_win_get_width(a6)-math.max(unpack(a8))local I=math.max(math.floor(a4*aa),0)local ab=vim.api.nvim_win_get_height(a6)-#a7;local ac=math.max(math.floor(a5*ab),0)return a.gen_hook.padding(I,ac)(h)end end;a.get_content=function(d)d=d or vim.api.nvim_get_current_buf()if not b.validate_starter_buf_id(d,'get_content()','error')then return end;return b.buffer_data[d].content end;a.content_coords=function(h,ad)h=h or a.get_content()if ad==nil then ad=function(j)return true end end;if type(ad)=='string'then local ae=ad;ad=function(_)return _.type==ae end end;local af={}for Q,J in ipairs(h)do for R,_ in ipairs(J)do if ad(_)then table.insert(af,{line=Q,unit=R})end end end;return af end;a.content_to_lines=function(h)return vim.tbl_map(function(ag)return table.concat(vim.tbl_map(function(x)return x.string:gsub('\n',' ')end,ag),'')end,h or a.get_content())end;a.content_to_items=function(h)h=h or a.get_content()local g={}for Q,J in ipairs(h)do local ah=0;for j,_ in ipairs(J)do local ai={Q,ah}if _.type=='item'then local a0=_.item;a0.name=_.string:gsub('\n',' ')a0._line=Q-1;a0._start_col=ah;a0._end_col=ah+_.string:len()a0._cursorpos=a0._cursorpos or ai;table.insert(g,a0)end;if _.type=='item_bullet'and _._place_cursor then _._item._cursorpos=ai end;ah=ah+_.string:len()end end;local aj=vim.tbl_map(function(x)return x.name:lower()end,g)local ak=b.unique_nprefix(aj)for P,m in ipairs(ak)do g[P]._nprefix=m end;return g end;a.eval_current_item=function(d)d=d or vim.api.nvim_get_current_buf()if not b.validate_starter_buf_id(d,'eval_current_item()')then return end;b.make_query(vim.api.nvim_get_current_buf(),'',false)local f=b.buffer_data[d]b.eval_fun_or_string(f.items[f.current_item_id].action,true)end;a.update_current_item=function(al,d)d=d or vim.api.nvim_get_current_buf()if not b.validate_starter_buf_id(d,'update_current_item()')then return end;local f=b.buffer_data[d]local am=f.current_item_id;f.current_item_id=b.next_active_item_id(d,f.current_item_id,al)if f.current_item_id==am then return end;b.position_cursor_on_current_item(d)vim.api.nvim_buf_clear_namespace(d,b.ns.current_item,0,-1)b.add_hl_current_item(d)end;a.add_to_query=function(an,d)d=d or vim.api.nvim_get_current_buf()if not b.validate_starter_buf_id(d,'add_to_query()')then return end;local f=b.buffer_data[d]local ao;if an==nil then ao=f.query:sub(0,f.query:len()-1)else ao=('%s%s'):format(f.query,an)end;b.make_query(d,ao)end;a.set_query=function(ap,d)ap=ap or''if type(ap)~='string'then error('`query` should be either `nil` or string.')end;d=d or vim.api.nvim_get_current_buf()if not b.validate_starter_buf_id(d,'add_to_query()')then return end;b.make_query(d,ap)end;a.on_cursormoved=function(d)d=d or vim.api.nvim_get_current_buf()if not b.validate_starter_buf_id(d,'on_cursormoved()')then return end;b.position_cursor_on_current_item(d)end;b.default_config=a.config;b.default_items={function()if _G.MiniSessions==nil then return{}end;return a.sections.sessions(5,true)()end,a.sections.recent_files(5,false,false),a.sections.builtin_actions()}b.default_header=function()local aq=tonumber(vim.fn.strftime('%H'))local ar=math.floor((aq+4)/8)+1;local as=({'evening','morning','afternoon','evening'})[ar]local at=vim.loop.os_get_passwd()['username']or'USERNAME'return('Good %s, %s'):format(as,at)end;b.default_footer=[[
Type query to filter items
<BS> deletes latest character from query
<Esc> resets current query
<Down/Up>, <C-n/p>, <M-j/k> move current item
<CR> executes action of current item
<C-c> closes this buffer]]b.default_content_hooks={a.gen_hook.adding_bullet(),a.gen_hook.aligning('center','center')}b.buffer_data={}b.buffer_number=0;b.ns={activity=vim.api.nvim_create_namespace(''),current_item=vim.api.nvim_create_namespace(''),general=vim.api.nvim_create_namespace('')}b.setup_config=function(c)vim.validate({config={c,'table',true}})c=vim.tbl_deep_extend('force',b.default_config,c or{})vim.validate({autoopen={c.autoopen,'boolean'},evaluate_single={c.evaluate_single,'boolean'},items={c.items,'table',true},content_hooks={c.content_hooks,'table',true},query_updaters={c.query_updaters,'string'},silent={c.silent,'boolean'}})return c end;b.apply_config=function(c)a.config=c end;b.is_disabled=function()return vim.g.ministarter_disable==true or vim.b.ministarter_disable==true end;b.get_config=function(c)return vim.tbl_deep_extend('force',a.config,vim.b.ministarter_config or{},c or{})end;b.normalize_items=function(g)local af=b.items_flatten(g)if#af==0 then return{{name='`config.items` is empty',action='',section=''}}end;return b.items_sort(af)end;b.normalize_header_footer=function(x)if type(x)=='function'then x=x()end;local af=tostring(x)if af==''then return{}end;return vim.split(af,'\n')end;b.make_initial_content=function(au,g,av)local h={}for j,a9 in ipairs(au)do b.content_add_line(h,{b.content_unit(a9,'header','MiniStarterHeader')})end;b.content_add_empty_lines(h,#au>0 and 1 or 0)b.content_add_items(h,g)b.content_add_empty_lines(h,#av>0 and 1 or 0)for j,a9 in ipairs(av)do b.content_add_line(h,{b.content_unit(a9,'footer','MiniStarterFooter')})end;return h end;b.content_unit=function(string,type,aw,ax)return vim.tbl_extend('force',{string=string,type=type,hl=aw},ax or{})end;b.content_add_line=function(h,ag)table.insert(h,ag)end;b.content_add_empty_lines=function(h,m)for j=1,m do b.content_add_line(h,{b.content_unit('','empty',nil)})end end;b.content_add_items=function(h,g)local W;for j,a0 in ipairs(g)do if W~=a0.section then b.content_add_empty_lines(h,W==nil and 0 or 1)b.content_add_line(h,{b.content_unit(a0.section,'section','MiniStarterSection')})W=a0.section end;b.content_add_line(h,{b.content_unit(a0.name,'item','MiniStarterItem',{item=a0})})end end;b.content_highlight=function(d)for Q,ag in ipairs(a.get_content(d))do local ah=0;for j,_ in ipairs(ag)do if _.hl~=nil then b.buf_hl(d,b.ns.general,_.hl,Q-1,ah,ah+_.string:len(),50)end;ah=ah+_.string:len()end end end;b.items_flatten=function(g)local af,k={},nil;k=function(x)local ay=0;while type(x)=='function'and ay<=100 do ay=ay+1;if ay>100 then b.message('Too many nested functions in `config.items`.')end;x=x()end;if b.is_item(x)then table.insert(af,vim.deepcopy(x))return end;if type(x)~='table'then return end;return vim.tbl_map(k,x)end;k(g)return af end;b.items_sort=function(g)local az,aA={},{}for j,a0 in ipairs(g)do local aB=a0.section;if aA[aB]==nil then table.insert(az,{})aA[aB]=#az end;table.insert(az[aA[aB]],a0)end;local af={}for j,aC in ipairs(az)do for j,a0 in ipairs(aC)do table.insert(af,a0)end end;return af end;b.items_highlight=function(d)for j,a0 in ipairs(b.buffer_data[d].items)do b.buf_hl(d,b.ns.general,'MiniStarterItemPrefix',a0._line,a0._start_col,a0._start_col+a0._nprefix,51)end end;b.next_active_item_id=function(d,aD,al)local g=b.buffer_data[d].items;local aE=aD;local aF=vim.tbl_count(g)local aG=al=='next'and 1 or aF-1;aE=math.fmod(aE+aG-1,aF)+1;while not(g[aE]._active or aE==aD)do aE=math.fmod(aE+aG-1,aF)+1 end;return aE end;b.position_cursor_on_current_item=function(d)local f=b.buffer_data[d]local ai=f.items[f.current_item_id]._cursorpos;for j,a6 in ipairs(b.get_buffer_windows(d))do vim.api.nvim_win_set_cursor(a6,ai)end end;b.item_is_active=function(a0,ap)return vim.startswith(a0.name:lower(),ap)and a0.action~=''end;b.make_query=function(d,ap,aH)if aH==nil then aH=true end;local f=b.buffer_data[d]ap=(ap or f.query):lower()local aI=0;for j,a0 in ipairs(f.items)do aI=aI+(b.item_is_active(a0,ap)and 1 or 0)end;if aI==0 and ap~=''then b.message(('Query %s results into no active items. Current query: %s'):format(vim.inspect(ap),f.query))return end;f.query=ap;for j,a0 in ipairs(f.items)do a0._active=b.item_is_active(a0,ap)end;if not f.items[f.current_item_id]._active then a.update_current_item('next',d)end;vim.api.nvim_buf_clear_namespace(d,b.ns.activity,0,-1)b.add_hl_activity(d,ap)if b.get_config().evaluate_single and aI==1 then a.eval_current_item(d)return end;if aH and not b.is_in_vimenter and vim.o.cmdheight>0 then vim.cmd('redraw')b.echo(('Query: %s'):format(ap))end end;b.make_buffer_autocmd=function(d)local aJ=string.format([[augroup MiniStarterBuffer
        au!
        au VimResized <buffer=%s> lua MiniStarter.refresh()
        au CursorMoved <buffer=%s> lua MiniStarter.on_cursormoved()
        au BufLeave <buffer=%s> if &cmdheight > 0 | echo '' | endif
        au BufLeave <buffer=%s> if &showtabline==1 | set showtabline=%s | endif
      augroup END]],d,d,d,d,vim.o.showtabline)vim.cmd(aJ)end;b.apply_buffer_options=function(d)vim.api.nvim_feedkeys('\28\14','nx',false)b.buffer_number=b.buffer_number+1;local F=b.buffer_number<=1 and'Starter'or'Starter_'..b.buffer_number;vim.api.nvim_buf_set_name(d,F)vim.cmd('noautocmd silent! set filetype=starter')local aK={'bufhidden=wipe','colorcolumn=','foldcolumn=0','matchpairs=','nobuflisted','nocursorcolumn','nocursorline','nolist','nonumber','noreadonly','norelativenumber','nospell','noswapfile','signcolumn=no','synmaxcol&','buftype=nofile','nomodeline','nomodifiable','foldlevel=999','nowrap'}vim.cmd(('silent! noautocmd setlocal %s'):format(table.concat(aK,' ')))vim.o.showtabline=1;vim.b.minicursorword_disable=true;vim.b.minitrailspace_disable=true;if _G.MiniTrailspace~=nil then _G.MiniTrailspace.unhighlight()end end;b.apply_buffer_mappings=function(d)b.buf_keymap(d,'<CR>','MiniStarter.eval_current_item()')b.buf_keymap(d,'<Up>',[[MiniStarter.update_current_item('prev')]])b.buf_keymap(d,'<C-p>',[[MiniStarter.update_current_item('prev')]])b.buf_keymap(d,'<M-k>',[[MiniStarter.update_current_item('prev')]])b.buf_keymap(d,'<Down>',[[MiniStarter.update_current_item('next')]])b.buf_keymap(d,'<C-n>',[[MiniStarter.update_current_item('next')]])b.buf_keymap(d,'<M-j>',[[MiniStarter.update_current_item('next')]])for j,aL in ipairs(vim.split(b.get_config().query_updaters,''))do local aM=vim.inspect(tostring(aL))b.buf_keymap(d,aL,('MiniStarter.add_to_query(%s)'):format(aM))end;b.buf_keymap(d,'<Esc>',[[MiniStarter.set_query('')]])b.buf_keymap(d,'<BS>','MiniStarter.add_to_query()')b.buf_keymap(d,'<C-c>','MiniStarter.close()')end;b.add_hl_activity=function(d,ap)for j,a0 in ipairs(b.buffer_data[d].items)do local a9=a0._line;local aN=a0._start_col;local aO=a0._end_col;if a0._active then b.buf_hl(d,b.ns.activity,'MiniStarterQuery',a9,aN,aN+ap:len(),53)else b.buf_hl(d,b.ns.activity,'MiniStarterInactive',a9,aN,aO,53)end end end;b.add_hl_current_item=function(d)local f=b.buffer_data[d]local aP=f.items[f.current_item_id]b.buf_hl(d,b.ns.current_item,'MiniStarterCurrent',aP._line,aP._start_col,aP._end_col,52)end;b.is_fun_or_string=function(x,aQ)if aQ==nil then aQ=true end;return aQ and x==nil or type(x)=='function'or type(x)=='string'end;b.is_item=function(x)return type(x)=='table'and b.is_fun_or_string(x['action'],false)and type(x['name'])=='string'and type(x['section'])=='string'end;b.is_something_shown=function()local aR=vim.api.nvim_buf_get_lines(0,0,-1,true)if#aR>1 or#aR==1 and aR[1]:len()>0 then return true end;local aS=vim.tbl_filter(function(d)return vim.fn.buflisted(d)==1 end,vim.api.nvim_list_bufs())if#aS>1 then return true end;if vim.fn.argc()>0 then return true end;return false end;b.echo=function(aT,aU)if b.get_config().silent then return end;aT=type(aT)=='string'and{{aT}}or aT;table.insert(aT,1,{'(mini.starter) ','WarningMsg'})local aV=vim.o.columns*math.max(vim.o.cmdheight-1,0)+vim.v.echospace;local aW,aX={},0;for j,aY in ipairs(aT)do local aZ={vim.fn.strcharpart(aY[1],0,aV-aX),aY[2]}table.insert(aW,aZ)aX=aX+vim.fn.strdisplaywidth(aZ[1])if aX>=aV then break end end;vim.cmd([[echo '' | redraw]])vim.api.nvim_echo(aW,aU,{})end;b.message=function(aT)b.echo(aT,true)end;b.error=function(aT)error(string.format('(mini.starter) %s',aT))end;b.validate_starter_buf_id=function(d,a_,b0)local b1=type(d)=='number'and vim.tbl_contains(vim.tbl_keys(b.buffer_data),d)and vim.api.nvim_buf_is_valid(d)if b1 then return true end;local aT=string.format('`buf_id` in `%s` is not an identifier of valid Starter buffer.',a_)if b0=='error'then b.error(aT)end;b.message(aT)return false end;b.eval_fun_or_string=function(x,b2)if type(x)=='function'then return x()end;if type(x)=='string'then if b2 then vim.cmd(x)else return x end end end;b.buf_keymap=function(d,aL,b3)vim.api.nvim_buf_set_keymap(d,'n',aL,('<Cmd>lua %s<CR>'):format(b3),{nowait=true,silent=true})end;if vim.fn.has('nvim-0.7')==1 then b.buf_hl=function(d,b4,b5,J,b6,b7,b8)vim.highlight.range(d,b4,b5,{J,b6},{J,b7},{priority=b8})end else b.buf_hl=function(d,b4,b5,J,b6,b7)vim.highlight.range(d,b4,b5,{J,b6},{J,b7})end end;b.get_buffer_windows=function(d)return vim.tbl_filter(function(a6)return vim.api.nvim_win_get_buf(a6)==d end,vim.api.nvim_list_wins())end;b.unique_nprefix=function(aj)local b9=vim.deepcopy(aj)local af,ba={},0;while vim.tbl_count(b9)>0 do ba=ba+1;local bb,bc={},true;for aE,aN in pairs(b9)do bc=bc and#aN<ba;local bd=aN:sub(1,ba)bb[bd]=bb[bd]==nil and{}or bb[bd]table.insert(bb[bd],aE)end;if bc then for be,aN in pairs(b9)do af[be]=#aN end;break end;for j,bf in pairs(bb)do if#bf==1 then local be=bf[1]af[be]=math.min(#b9[be],ba)b9[be]=nil end end end;return af end;return a