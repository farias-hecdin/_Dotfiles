local a={}local b={}a.setup=function(c)_G.MiniStarter=a;c=b.setup_config(c)b.apply_config(c)b.create_autocommands(c)b.create_default_hl()end;a.config={autoopen=true,evaluate_single=false,items=nil,header=nil,footer=nil,content_hooks=nil,query_updaters='abcdefghijklmnopqrstuvwxyz0123456789_-.',silent=false}a.open=function(d)if b.is_disabled()then return end;if b.is_in_vimenter then d=vim.api.nvim_get_current_buf()end;if d==nil or not vim.api.nvim_buf_is_valid(d)then d=vim.api.nvim_create_buf(false,true)end;b.buffer_data[d]={current_item_id=1,query=''}local e=vim.b.ministarter_config;vim.api.nvim_set_current_buf(d)vim.b.ministarter_config=e;b.make_buffer_autocmd(d)b.apply_buffer_options(d)b.apply_buffer_mappings(d)a.refresh()vim.cmd('doautocmd User MiniStarterOpened')b.is_in_vimenter=false end;a.refresh=function(d)d=d or vim.api.nvim_get_current_buf()if not b.validate_starter_buf_id(d,'refresh()')then return end;local f=b.buffer_data[d]local c=b.get_config()f.header=b.normalize_header_footer(c.header or b.default_header)local g=b.normalize_items(c.items or b.default_items)f.footer=b.normalize_header_footer(c.footer or b.default_footer)local h=b.make_initial_content(f.header,g,f.footer)local i=c.content_hooks or b.default_content_hooks;for j,k in ipairs(i)do h=k(h,d)end;f.content=h;local l=f.items;f.items=a.content_to_items(h)if not vim.deep_equal(f.items,l)then f.current_item_id=1 end;vim.api.nvim_buf_set_option(d,'modifiable',true)vim.api.nvim_buf_set_lines(d,0,-1,false,a.content_to_lines(h))vim.api.nvim_buf_set_option(d,'modifiable',false)b.content_highlight(d)b.items_highlight(d)b.position_cursor_on_current_item(d)b.add_hl_current_item(d)b.make_query(d)end;a.close=function(d)d=d or vim.api.nvim_get_current_buf()if not b.validate_starter_buf_id(d,'close()')then return end;pcall(vim.api.nvim_buf_delete,d,{})end;a.sections={}a.sections.builtin_actions=function()return{{name='Edit new buffer',action='enew',section='Builtin actions'},{name='Quit Neovim',action='qall',section='Builtin actions'}}end;a.sections.sessions=function(m,n)m=m or 5;if n==nil then n=true end;return function()if _G.MiniSessions==nil then return{{name=[['mini.sessions' is not set up]],action='',section='Sessions'}}end;local g={}for o,p in pairs(_G.MiniSessions.detected)do table.insert(g,{_session=p,name=('%s%s'):format(o,p.type=='local'and' (local)'or''),action=([[lua _G.MiniSessions.read('%s')]]):format(o),section='Sessions'})end;if vim.tbl_count(g)==0 then return{{name=[[There are no detected sessions in 'mini.sessions']],action='',section='Sessions'}}end;local q;if n then q=function(r,s)local t=r._session.type=='local'and math.huge or r._session.modify_time;local u=s._session.type=='local'and math.huge or s._session.modify_time;return t>u end else q=function(r,s)local v=r._session.type=='local'and''or r.name;local w=s._session.type=='local'and''or s.name;return v<w end end;table.sort(g,q)return vim.tbl_map(function(x)x._session=nil;return x end,vim.list_slice(g,1,m))end end;a.sections.recent_files=function(m,y,z)m=m or 5;if y==nil then y=false end;if z==nil then z=true end;if z==false then z=function()return''end end;if z==true then z=function(A)return string.format(' (%s)',vim.fn.fnamemodify(A,':~:.'))end end;if not vim.is_callable(z)then b.error('`show_path` should be boolean or callable.')end;return function()local B=string.format('Recent files%s',y and' (current directory)'or'')local C=vim.tbl_filter(function(k)return vim.fn.filereadable(k)==1 end,vim.v.oldfiles or{})if#C==0 then return{{name='There are no recent files (`v:oldfiles` is empty)',action='',section=B}}end;if y then local D=vim.loop.os_uname().sysname=='Windows_NT'and[[%\]]or'%/'local E='^'..vim.pesc(vim.fn.getcwd())..D;C=vim.tbl_filter(function(k)return k:find(E)~=nil end,C)end;if#C==0 then return{{name='There are no recent files in current directory',action='',section=B}}end;local g={}for j,k in ipairs(vim.list_slice(C,1,m))do local F=vim.fn.fnamemodify(k,':t')..z(k)table.insert(g,{action='edit '..k,name=F,section=B})end;return g end end;a.sections.telescope=function()return function()return{{action='Telescope file_browser',name='Browser',section='Telescope'},{action='Telescope command_history',name='Command history',section='Telescope'},{action='Telescope find_files',name='Files',section='Telescope'},{action='Telescope help_tags',name='Help tags',section='Telescope'},{action='Telescope live_grep',name='Live grep',section='Telescope'},{action='Telescope oldfiles',name='Old files',section='Telescope'}}end end;a.gen_hook={}a.gen_hook.padding=function(G,H)G=math.max(G or 0,0)H=math.max(H or 0,0)return function(h,j)local I=string.rep(' ',G)for j,J in ipairs(h)do local K=#J==0 or#J==1 and J[1].string==''if not K then table.insert(J,1,b.content_unit(I,'empty',nil))end end;local L={}for j=1,H do table.insert(L,{b.content_unit('','empty',nil)})end;h=vim.list_extend(L,h)return h end end;a.gen_hook.adding_bullet=function(M,N)M=M or'░ 'if N==nil then N=true end;return function(h)local O=a.content_coords(h,'item')for P=#O,1,-1 do local Q,R=O[P].line,O[P].unit;local S={string=M,type='item_bullet',hl='MiniStarterItemBullet',_item=h[Q][R].item,_place_cursor=N}table.insert(h[Q],R,S)end;return h end end;a.gen_hook.indexing=function(T,U)T=T or'all'U=U or{}local V=T=='section'return function(h,j)local W,X,Y=nil,0,0;local O=a.content_coords(h,'item')for j,Z in ipairs(O)do local _=h[Z.line][Z.unit]local a0=_.item;if not vim.tbl_contains(U,a0.section)then Y=Y+1;if W~=a0.section then W=a0.section;X=math.fmod(X,26)+1;Y=V and 1 or Y end;local a1=V and string.char(96+X)or''_.string=('%s%s. %s'):format(a1,Y,_.string)end end;return h end end;a.gen_hook.aligning=function(a2,a3)a2=a2 or'left'a3=a3 or'top'local a4=({left=0,center=0.5,right=1.0})[a2]local a5=({top=0,center=0.5,bottom=1.0})[a3]return function(h,d)local a6=vim.fn.bufwinid(d)if a6<0 then return end;local a7=a.content_to_lines(h)local a8=vim.tbl_map(function(a9)return vim.fn.strdisplaywidth(a9)end,a7)local aa=vim.api.nvim_win_get_width(a6)-math.max(unpack(a8))local I=math.max(math.floor(a4*aa),0)local ab=vim.api.nvim_win_get_height(a6)-#a7;local ac=math.max(math.floor(a5*ab),0)return a.gen_hook.padding(I,ac)(h)end end;a.get_content=function(d)d=d or vim.api.nvim_get_current_buf()if not b.validate_starter_buf_id(d,'get_content()','error')then return end;return b.buffer_data[d].content end;a.content_coords=function(h,ad)h=h or a.get_content()if ad==nil then ad=function(j)return true end end;if type(ad)=='string'then local ae=ad;ad=function(_)return _.type==ae end end;local af={}for Q,J in ipairs(h)do for R,_ in ipairs(J)do if ad(_)then table.insert(af,{line=Q,unit=R})end end end;return af end;a.content_to_lines=function(h)return vim.tbl_map(function(ag)return table.concat(vim.tbl_map(function(x)return x.string:gsub('\n',' ')end,ag),'')end,h or a.get_content())end;a.content_to_items=function(h)h=h or a.get_content()local g={}for Q,J in ipairs(h)do local ah=0;for j,_ in ipairs(J)do local ai={Q,ah}if _.type=='item'then local a0=_.item;a0.name=_.string:gsub('\n',' ')a0._line=Q-1;a0._start_col=ah;a0._end_col=ah+_.string:len()a0._cursorpos=a0._cursorpos or ai;table.insert(g,a0)end;if _.type=='item_bullet'and _._place_cursor then _._item._cursorpos=ai end;ah=ah+_.string:len()end end;local aj=vim.tbl_map(function(x)return x.name:lower()end,g)local ak=b.unique_nprefix(aj)for P,m in ipairs(ak)do g[P]._nprefix=m end;return g end;a.eval_current_item=function(d)d=d or vim.api.nvim_get_current_buf()if not b.validate_starter_buf_id(d,'eval_current_item()')then return end;b.make_query(vim.api.nvim_get_current_buf(),'',false)local f=b.buffer_data[d]b.eval_fun_or_string(f.items[f.current_item_id].action,true)end;a.update_current_item=function(al,d)d=d or vim.api.nvim_get_current_buf()if not b.validate_starter_buf_id(d,'update_current_item()')then return end;local f=b.buffer_data[d]local am=f.current_item_id;f.current_item_id=b.next_active_item_id(d,f.current_item_id,al)if f.current_item_id==am then return end;b.position_cursor_on_current_item(d)vim.api.nvim_buf_clear_namespace(d,b.ns.current_item,0,-1)b.add_hl_current_item(d)end;a.add_to_query=function(an,d)d=d or vim.api.nvim_get_current_buf()if not b.validate_starter_buf_id(d,'add_to_query()')then return end;local f=b.buffer_data[d]local ao;if an==nil then ao=f.query:sub(0,f.query:len()-1)else ao=('%s%s'):format(f.query,an)end;b.make_query(d,ao)end;a.set_query=function(ap,d)ap=ap or''if type(ap)~='string'then error('`query` should be either `nil` or string.')end;d=d or vim.api.nvim_get_current_buf()if not b.validate_starter_buf_id(d,'add_to_query()')then return end;b.make_query(d,ap)end;b.default_config=vim.deepcopy(a.config)b.default_items={function()if _G.MiniSessions==nil then return{}end;return a.sections.sessions(5,true)()end,a.sections.recent_files(5,false,false),a.sections.builtin_actions()}b.default_header=function()local aq=tonumber(vim.fn.strftime('%H'))local ar=math.floor((aq+4)/8)+1;local as=({'evening','morning','afternoon','evening'})[ar]local at=vim.loop.os_get_passwd()['username']or'USERNAME'return('Good %s, %s'):format(as,at)end;b.default_footer=[[
Type query to filter items
<BS> deletes latest character from query
<Esc> resets current query
<Down/Up>, <C-n/p>, <M-j/k> move current item
<CR> executes action of current item
<C-c> closes this buffer]]b.default_content_hooks={a.gen_hook.adding_bullet(),a.gen_hook.aligning('center','center')}b.buffer_data={}b.buffer_number=0;b.ns={activity=vim.api.nvim_create_namespace(''),current_item=vim.api.nvim_create_namespace(''),general=vim.api.nvim_create_namespace('')}b.setup_config=function(c)vim.validate({config={c,'table',true}})c=vim.tbl_deep_extend('force',vim.deepcopy(b.default_config),c or{})vim.validate({autoopen={c.autoopen,'boolean'},evaluate_single={c.evaluate_single,'boolean'},items={c.items,'table',true},content_hooks={c.content_hooks,'table',true},query_updaters={c.query_updaters,'string'},silent={c.silent,'boolean'}})return c end;b.apply_config=function(c)a.config=c end;b.create_autocommands=function(c)local au=vim.api.nvim_create_augroup('MiniStarter',{})if c.autoopen then local av=function()if b.is_something_shown()then return end;b.is_in_vimenter=true;a.open()end;vim.api.nvim_create_autocmd('VimEnter',{group=au,nested=true,once=true,callback=av,desc='Open on VimEnter'})end end;b.create_default_hl=function()local aw=function(F,f)f.default=true;vim.api.nvim_set_hl(0,F,f)end;aw('MiniStarterCurrent',{link='MiniStarterItem'})aw('MiniStarterFooter',{link='Title'})aw('MiniStarterHeader',{link='Title'})aw('MiniStarterInactive',{link='Comment'})aw('MiniStarterItem',{link='Normal'})aw('MiniStarterItemBullet',{link='Delimiter'})aw('MiniStarterItemPrefix',{link='WarningMsg'})aw('MiniStarterSection',{link='Delimiter'})aw('MiniStarterQuery',{link='MoreMsg'})end;b.is_disabled=function()return vim.g.ministarter_disable==true or vim.b.ministarter_disable==true end;b.get_config=function(c)return vim.tbl_deep_extend('force',a.config,vim.b.ministarter_config or{},c or{})end;b.normalize_items=function(g)local af=b.items_flatten(g)if#af==0 then return{{name='`config.items` is empty',action='',section=''}}end;return b.items_sort(af)end;b.normalize_header_footer=function(x)if type(x)=='function'then x=x()end;local af=tostring(x)if af==''then return{}end;return vim.split(af,'\n')end;b.make_initial_content=function(ax,g,ay)local h={}for j,a9 in ipairs(ax)do b.content_add_line(h,{b.content_unit(a9,'header','MiniStarterHeader')})end;b.content_add_empty_lines(h,#ax>0 and 1 or 0)b.content_add_items(h,g)b.content_add_empty_lines(h,#ay>0 and 1 or 0)for j,a9 in ipairs(ay)do b.content_add_line(h,{b.content_unit(a9,'footer','MiniStarterFooter')})end;return h end;b.content_unit=function(string,type,az,aA)return vim.tbl_extend('force',{string=string,type=type,hl=az},aA or{})end;b.content_add_line=function(h,ag)table.insert(h,ag)end;b.content_add_empty_lines=function(h,m)for j=1,m do b.content_add_line(h,{b.content_unit('','empty',nil)})end end;b.content_add_items=function(h,g)local W;for j,a0 in ipairs(g)do if W~=a0.section then b.content_add_empty_lines(h,W==nil and 0 or 1)b.content_add_line(h,{b.content_unit(a0.section,'section','MiniStarterSection')})W=a0.section end;b.content_add_line(h,{b.content_unit(a0.name,'item','MiniStarterItem',{item=a0})})end end;b.content_highlight=function(d)for Q,ag in ipairs(a.get_content(d))do local ah=0;for j,_ in ipairs(ag)do if _.hl~=nil then b.buf_hl(d,b.ns.general,_.hl,Q-1,ah,ah+_.string:len(),50)end;ah=ah+_.string:len()end end end;b.items_flatten=function(g)local af,k={},nil;k=function(x)local aB=0;while type(x)=='function'and aB<=100 do aB=aB+1;if aB>100 then b.message('Too many nested functions in `config.items`.')end;x=x()end;if b.is_item(x)then table.insert(af,vim.deepcopy(x))return end;if type(x)~='table'then return end;return vim.tbl_map(k,x)end;k(g)return af end;b.items_sort=function(g)local aC,aD={},{}for j,a0 in ipairs(g)do local aE=a0.section;if aD[aE]==nil then table.insert(aC,{})aD[aE]=#aC end;table.insert(aC[aD[aE]],a0)end;local af={}for j,aF in ipairs(aC)do for j,a0 in ipairs(aF)do table.insert(af,a0)end end;return af end;b.items_highlight=function(d)for j,a0 in ipairs(b.buffer_data[d].items)do b.buf_hl(d,b.ns.general,'MiniStarterItemPrefix',a0._line,a0._start_col,a0._start_col+a0._nprefix,52)end end;b.next_active_item_id=function(d,aG,al)local g=b.buffer_data[d].items;local aH=aG;local aI=vim.tbl_count(g)local aJ=al=='next'and 1 or aI-1;aH=math.fmod(aH+aJ-1,aI)+1;while not(g[aH]._active or aH==aG)do aH=math.fmod(aH+aJ-1,aI)+1 end;return aH end;b.position_cursor_on_current_item=function(d)local f=b.buffer_data[d]local ai=f.items[f.current_item_id]._cursorpos;for j,a6 in ipairs(b.get_buffer_windows(d))do vim.api.nvim_win_set_cursor(a6,ai)end end;b.item_is_active=function(a0,ap)return vim.startswith(a0.name:lower(),ap)and a0.action~=''end;b.make_query=function(d,ap,aK)if aK==nil then aK=true end;local f=b.buffer_data[d]ap=(ap or f.query):lower()local aL=0;for j,a0 in ipairs(f.items)do aL=aL+(b.item_is_active(a0,ap)and 1 or 0)end;if aL==0 and ap~=''then b.message(('Query %s results into no active items. Current query: %s'):format(vim.inspect(ap),f.query))return end;f.query=ap;for j,a0 in ipairs(f.items)do a0._active=b.item_is_active(a0,ap)end;if not f.items[f.current_item_id]._active then a.update_current_item('next',d)end;vim.api.nvim_buf_clear_namespace(d,b.ns.activity,0,-1)b.add_hl_activity(d,ap)if b.get_config().evaluate_single and aL==1 then a.eval_current_item(d)return end;if aK and not b.is_in_vimenter and vim.o.cmdheight>0 then vim.cmd('redraw')b.echo(('Query: %s'):format(ap))end end;b.make_buffer_autocmd=function(d)local au=vim.api.nvim_create_augroup('MiniStarterBuffer',{})local aM=function(aN,aO,aP)vim.api.nvim_create_autocmd(aN,{group=au,buffer=d,callback=aO,desc=aP})end;aM('VimResized',function()a.refresh(d)end,'Refresh')aM('CursorMoved',function()b.position_cursor_on_current_item(d)end,'Position cursor')local aQ=vim.o.showtabline;aM('BufLeave',function()if vim.o.cmdheight>0 then vim.cmd("echo ''")end;if vim.o.showtabline==1 then vim.o.showtabline=aQ end end,'On BufLeave')end;b.apply_buffer_options=function(d)vim.api.nvim_feedkeys('\28\14','nx',false)b.buffer_number=b.buffer_number+1;local F=b.buffer_number<=1 and'Starter'or'Starter_'..b.buffer_number;vim.api.nvim_buf_set_name(d,F)vim.cmd('noautocmd silent! set filetype=starter')local aR={'bufhidden=wipe','colorcolumn=','foldcolumn=0','matchpairs=','nobuflisted','nocursorcolumn','nocursorline','nolist','nonumber','noreadonly','norelativenumber','nospell','noswapfile','signcolumn=no','synmaxcol&','buftype=nofile','nomodeline','nomodifiable','foldlevel=999','nowrap'}vim.cmd(('silent! noautocmd setlocal %s'):format(table.concat(aR,' ')))vim.o.showtabline=1;vim.b.minicursorword_disable=true;vim.b.minitrailspace_disable=true;if _G.MiniTrailspace~=nil then _G.MiniTrailspace.unhighlight()end end;b.apply_buffer_mappings=function(d)local aS=function(aT,aU)vim.keymap.set('n',aT,('<Cmd>lua %s<CR>'):format(aU),{buffer=d,nowait=true,silent=true})end;aS('<CR>','MiniStarter.eval_current_item()')aS('<Up>',[[MiniStarter.update_current_item('prev')]])aS('<C-p>',[[MiniStarter.update_current_item('prev')]])aS('<M-k>',[[MiniStarter.update_current_item('prev')]])aS('<Down>',[[MiniStarter.update_current_item('next')]])aS('<C-n>',[[MiniStarter.update_current_item('next')]])aS('<M-j>',[[MiniStarter.update_current_item('next')]])for j,aT in ipairs(vim.split(b.get_config().query_updaters,''))do local aV=vim.inspect(tostring(aT))aS(aT,('MiniStarter.add_to_query(%s)'):format(aV))end;aS('<Esc>',[[MiniStarter.set_query('')]])aS('<BS>','MiniStarter.add_to_query()')aS('<C-c>','MiniStarter.close()')end;b.add_hl_activity=function(d,ap)for j,a0 in ipairs(b.buffer_data[d].items)do local a9=a0._line;local aW=a0._start_col;local aX=a0._end_col;if a0._active then b.buf_hl(d,b.ns.activity,'MiniStarterQuery',a9,aW,aW+ap:len(),53)else b.buf_hl(d,b.ns.activity,'MiniStarterInactive',a9,aW,aX,53)end end end;b.add_hl_current_item=function(d)local f=b.buffer_data[d]local aY=f.items[f.current_item_id]b.buf_hl(d,b.ns.current_item,'MiniStarterCurrent',aY._line,aY._start_col,aY._end_col,51)end;b.is_fun_or_string=function(x,aZ)if aZ==nil then aZ=true end;return aZ and x==nil or type(x)=='function'or type(x)=='string'end;b.is_item=function(x)return type(x)=='table'and b.is_fun_or_string(x['action'],false)and type(x['name'])=='string'and type(x['section'])=='string'end;b.is_something_shown=function()local a_=vim.api.nvim_buf_get_lines(0,0,-1,true)if#a_>1 or#a_==1 and a_[1]:len()>0 then return true end;local b0=vim.tbl_filter(function(d)return vim.fn.buflisted(d)==1 end,vim.api.nvim_list_bufs())if#b0>1 then return true end;if vim.fn.argc()>0 then return true end;return false end;b.echo=function(b1,b2)if b.get_config().silent then return end;b1=type(b1)=='string'and{{b1}}or b1;table.insert(b1,1,{'(mini.starter) ','WarningMsg'})local b3=vim.o.columns*math.max(vim.o.cmdheight-1,0)+vim.v.echospace;local b4,b5={},0;for j,b6 in ipairs(b1)do local b7={vim.fn.strcharpart(b6[1],0,b3-b5),b6[2]}table.insert(b4,b7)b5=b5+vim.fn.strdisplaywidth(b7[1])if b5>=b3 then break end end;vim.cmd([[echo '' | redraw]])vim.api.nvim_echo(b4,b2,{})end;b.message=function(b1)b.echo(b1,true)end;b.error=function(b1)error(string.format('(mini.starter) %s',b1))end;b.validate_starter_buf_id=function(d,b8,b9)local ba=type(d)=='number'and vim.tbl_contains(vim.tbl_keys(b.buffer_data),d)and vim.api.nvim_buf_is_valid(d)if ba then return true end;local b1=string.format('`buf_id` in `%s` is not an identifier of valid Starter buffer.',b8)if b9=='error'then b.error(b1)end;b.message(b1)return false end;b.eval_fun_or_string=function(x,bb)if type(x)=='function'then return x()end;if type(x)=='string'then if bb then vim.cmd(x)else return x end end end;b.buf_hl=function(d,bc,bd,J,be,bf,bg)vim.highlight.range(d,bc,bd,{J,be},{J,bf},{priority=bg})end;b.get_buffer_windows=function(d)return vim.tbl_filter(function(a6)return vim.api.nvim_win_get_buf(a6)==d end,vim.api.nvim_list_wins())end;b.unique_nprefix=function(aj)local bh=vim.deepcopy(aj)local af,bi={},0;while vim.tbl_count(bh)>0 do bi=bi+1;local bj,bk={},true;for aH,aW in pairs(bh)do bk=bk and#aW<bi;local bl=aW:sub(1,bi)bj[bl]=bj[bl]==nil and{}or bj[bl]table.insert(bj[bl],aH)end;if bk then for bm,aW in pairs(bh)do af[bm]=#aW end;break end;for j,bn in pairs(bj)do if#bn==1 then local bm=bn[1]af[bm]=math.min(#bh[bm],bi)bh[bm]=nil end end end;return af end;return a