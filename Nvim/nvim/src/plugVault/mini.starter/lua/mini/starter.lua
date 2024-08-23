local a={}local b={}a.setup=function(c)_G.MiniStarter=a;c=b.setup_config(c)b.apply_config(c)b.create_autocommands(c)b.create_default_hl()end;a.config={autoopen=true,evaluate_single=false,items=nil,header=nil,footer=nil,content_hooks=nil,query_updaters='abcdefghijklmnopqrstuvwxyz0123456789_-.',silent=false}a.open=function(d)if b.is_disabled()then return end;if b.is_in_vimenter then d=vim.api.nvim_get_current_buf()end;if d==nil or not vim.api.nvim_buf_is_valid(d)then d=vim.api.nvim_create_buf(false,true)end;b.buffer_data[d]={current_item_id=1,query=''}local e=vim.b.ministarter_config;vim.api.nvim_set_current_buf(d)vim.b.ministarter_config=e;b.make_buffer_autocmd(d)b.apply_buffer_options(d)b.apply_buffer_mappings(d)a.refresh()local f=function()vim.api.nvim_exec_autocmds('User',{pattern='MiniStarterOpened'})end;if b.is_in_vimenter then f=vim.schedule_wrap(f)end;f()b.is_in_vimenter=false end;a.refresh=function(d)d=d or vim.api.nvim_get_current_buf()if not b.validate_starter_buf_id(d,'refresh()')then return end;local g=b.buffer_data[d]local c=b.get_config()g.header=b.normalize_header_footer(c.header or b.default_header)local h=b.normalize_items(c.items or b.default_items)g.footer=b.normalize_header_footer(c.footer or b.default_footer)local i=b.make_initial_content(g.header,h,g.footer)local j=c.content_hooks or b.default_content_hooks;for k,l in ipairs(j)do i=l(i,d)end;g.content=i;local m=g.items;g.items=a.content_to_items(i)if not vim.deep_equal(g.items,m)then g.current_item_id=1 end;vim.api.nvim_buf_set_option(d,'modifiable',true)vim.api.nvim_buf_set_lines(d,0,-1,false,a.content_to_lines(i))vim.api.nvim_buf_set_option(d,'modifiable',false)b.content_highlight(d)b.items_highlight(d)b.position_cursor_on_current_item(d)b.add_hl_current_item(d)b.make_query(d)end;a.close=function(d)d=d or vim.api.nvim_get_current_buf()if not b.validate_starter_buf_id(d,'close()')then return end;pcall(vim.api.nvim_buf_delete,d,{})end;a.sections={}a.sections.builtin_actions=function()return{{name='Edit new buffer',action='enew',section='Builtin actions'},{name='Quit Neovim',action='qall',section='Builtin actions'}}end;a.sections.sessions=function(n,o)n=n or 5;if o==nil then o=true end;return function()if _G.MiniSessions==nil then return{{name=[['mini.sessions' is not set up]],action='',section='Sessions'}}end;local h={}for p,q in pairs(_G.MiniSessions.detected)do table.insert(h,{_session=q,name=('%s%s'):format(p,q.type=='local'and' (local)'or''),action=([[lua _G.MiniSessions.read('%s')]]):format(p),section='Sessions'})end;if vim.tbl_count(h)==0 then return{{name=[[There are no detected sessions in 'mini.sessions']],action='',section='Sessions'}}end;local r;if o then r=function(s,t)local u=s._session.type=='local'and math.huge or s._session.modify_time;local v=t._session.type=='local'and math.huge or t._session.modify_time;return u>v end else r=function(s,t)local w=s._session.type=='local'and''or s.name;local x=t._session.type=='local'and''or t.name;return w<x end end;table.sort(h,r)return vim.tbl_map(function(y)y._session=nil;return y end,vim.list_slice(h,1,n))end end;a.sections.recent_files=function(n,z,A)n=n or 5;if z==nil then z=false end;if A==nil then A=true end;if A==false then A=function()return''end end;if A==true then A=function(B)return string.format(' (%s)',vim.fn.fnamemodify(B,':~:.'))end end;if not vim.is_callable(A)then b.error('`show_path` should be boolean or callable.')end;return function()local C=string.format('Recent files%s',z and' (current directory)'or'')local D=vim.tbl_filter(function(l)return vim.fn.filereadable(l)==1 end,vim.v.oldfiles or{})if#D==0 then return{{name='There are no recent files (`v:oldfiles` is empty)',action='',section=C}}end;if z then local E=vim.loop.os_uname().sysname=='Windows_NT'and[[%\]]or'%/'local F='^'..vim.pesc(vim.fn.getcwd())..E;D=vim.tbl_filter(function(l)return l:find(F)~=nil end,D)end;if#D==0 then return{{name='There are no recent files in current directory',action='',section=C}}end;local h={}for k,l in ipairs(vim.list_slice(D,1,n))do local G=vim.fn.fnamemodify(l,':t')..A(l)table.insert(h,{action='edit '..l,name=G,section=C})end;return h end end;a.sections.pick=function()return function()return{{action='Pick history scope=":"',name='Command history',section='Pick'},{action='Pick explorer',name='Explorer',section='Pick'},{action='Pick files',name='Files',section='Pick'},{action='Pick grep_live',name='Grep live',section='Pick'},{action='Pick help',name='Help tags',section='Pick'},{action='Pick visit_paths',name='Visited paths',section='Pick'}}end end;a.sections.telescope=function()return function()return{{action='Telescope file_browser',name='Browser',section='Telescope'},{action='Telescope command_history',name='Command history',section='Telescope'},{action='Telescope find_files',name='Files',section='Telescope'},{action='Telescope help_tags',name='Help tags',section='Telescope'},{action='Telescope live_grep',name='Live grep',section='Telescope'},{action='Telescope oldfiles',name='Old files',section='Telescope'}}end end;a.gen_hook={}a.gen_hook.padding=function(H,I)H=math.max(H or 0,0)I=math.max(I or 0,0)return function(i,k)local J=string.rep(' ',H)for k,K in ipairs(i)do local L=#K==0 or#K==1 and K[1].string==''if not L then table.insert(K,1,b.content_unit(J,'empty',nil))end end;local M={}for k=1,I do table.insert(M,{b.content_unit('','empty',nil)})end;i=vim.list_extend(M,i)return i end end;a.gen_hook.adding_bullet=function(N,O)N=N or'░ 'if O==nil then O=true end;return function(i)local P=a.content_coords(i,'item')for Q=#P,1,-1 do local R,S=P[Q].line,P[Q].unit;local T={string=N,type='item_bullet',hl='MiniStarterItemBullet',_item=i[R][S].item,_place_cursor=O}table.insert(i[R],S,T)end;return i end end;a.gen_hook.indexing=function(U,V)U=U or'all'V=V or{}local W=U=='section'return function(i,k)local X,Y,Z=nil,0,0;local P=a.content_coords(i,'item')for k,_ in ipairs(P)do local a0=i[_.line][_.unit]local a1=a0.item;if not vim.tbl_contains(V,a1.section)then Z=Z+1;if X~=a1.section then X=a1.section;Y=math.fmod(Y,26)+1;Z=W and 1 or Z end;local a2=W and string.char(96+Y)or''a0.string=('%s%s. %s'):format(a2,Z,a0.string)end end;return i end end;a.gen_hook.aligning=function(a3,a4)a3=a3 or'left'a4=a4 or'top'local a5=({left=0,center=0.5,right=1.0})[a3]local a6=({top=0,center=0.5,bottom=1.0})[a4]return function(i,d)local a7=vim.fn.bufwinid(d)if a7<0 then return end;local a8=a.content_to_lines(i)local a9=vim.tbl_map(function(aa)return vim.fn.strdisplaywidth(aa)end,a8)local ab=vim.api.nvim_win_get_width(a7)-math.max(unpack(a9))local J=math.max(math.floor(a5*ab),0)local ac=vim.api.nvim_win_get_height(a7)-#a8;local ad=math.max(math.floor(a6*ac),0)return a.gen_hook.padding(J,ad)(i)end end;a.get_content=function(d)d=d or vim.api.nvim_get_current_buf()if not b.validate_starter_buf_id(d,'get_content()','error')then return end;return b.buffer_data[d].content end;a.content_coords=function(i,ae)i=i or a.get_content()if ae==nil then ae=function(k)return true end end;if type(ae)=='string'then local af=ae;ae=function(a0)return a0.type==af end end;local ag={}for R,K in ipairs(i)do for S,a0 in ipairs(K)do if ae(a0)then table.insert(ag,{line=R,unit=S})end end end;return ag end;a.content_to_lines=function(i)return vim.tbl_map(function(ah)return table.concat(vim.tbl_map(function(y)return y.string:gsub('\n',' ')end,ah),'')end,i or a.get_content())end;a.content_to_items=function(i)i=i or a.get_content()local h={}for R,K in ipairs(i)do local ai=0;for k,a0 in ipairs(K)do local aj={R,ai}if a0.type=='item'then local a1=a0.item;a1.name=a0.string:gsub('\n',' ')a1._line=R-1;a1._start_col=ai;a1._end_col=ai+a0.string:len()a1._cursorpos=a1._cursorpos or aj;table.insert(h,a1)end;if a0.type=='item_bullet'and a0._place_cursor then a0._item._cursorpos=aj end;ai=ai+a0.string:len()end end;local ak=vim.tbl_map(function(y)return y.name:lower()end,h)local al=b.unique_nprefix(ak)for Q,n in ipairs(al)do h[Q]._nprefix=n end;return h end;a.eval_current_item=function(d)d=d or vim.api.nvim_get_current_buf()if not b.validate_starter_buf_id(d,'eval_current_item()')then return end;b.make_query(vim.api.nvim_get_current_buf(),'',false)local g=b.buffer_data[d]b.eval_fun_or_string(g.items[g.current_item_id].action,true)end;a.update_current_item=function(am,d)d=d or vim.api.nvim_get_current_buf()if not b.validate_starter_buf_id(d,'update_current_item()')then return end;local g=b.buffer_data[d]local an=g.current_item_id;g.current_item_id=b.next_active_item_id(d,g.current_item_id,am)if g.current_item_id==an then return end;b.position_cursor_on_current_item(d)vim.api.nvim_buf_clear_namespace(d,b.ns.current_item,0,-1)b.add_hl_current_item(d)end;a.add_to_query=function(ao,d)d=d or vim.api.nvim_get_current_buf()if not b.validate_starter_buf_id(d,'add_to_query()')then return end;local g=b.buffer_data[d]local ap;if ao==nil then ap=g.query:sub(0,g.query:len()-1)else ap=('%s%s'):format(g.query,ao)end;b.make_query(d,ap)end;a.set_query=function(aq,d)aq=aq or''if type(aq)~='string'then error('`query` should be either `nil` or string.')end;d=d or vim.api.nvim_get_current_buf()if not b.validate_starter_buf_id(d,'add_to_query()')then return end;b.make_query(d,aq)end;b.default_config=vim.deepcopy(a.config)b.default_items={function()if _G.MiniSessions==nil then return{}end;return a.sections.sessions(5,true)()end,a.sections.recent_files(5,false,false),a.sections.builtin_actions()}b.default_header=function()local ar=tonumber(vim.fn.strftime('%H'))local as=math.floor((ar+4)/8)+1;local at=({'evening','morning','afternoon','evening'})[as]local au=vim.loop.os_get_passwd()['username']or'USERNAME'return('Good %s, %s'):format(at,au)end;b.default_footer=[[
Type query to filter items
<BS> deletes latest character from query
<Esc> resets current query
<Down/Up>, <C-n/p>, <M-j/k> move current item
<CR> executes action of current item
<C-c> closes this buffer]]b.default_content_hooks={a.gen_hook.adding_bullet(),a.gen_hook.aligning('center','center')}b.buffer_data={}b.buffer_number=0;b.ns={activity=vim.api.nvim_create_namespace(''),current_item=vim.api.nvim_create_namespace(''),general=vim.api.nvim_create_namespace('')}b.setup_config=function(c)vim.validate({config={c,'table',true}})c=vim.tbl_deep_extend('force',vim.deepcopy(b.default_config),c or{})vim.validate({autoopen={c.autoopen,'boolean'},evaluate_single={c.evaluate_single,'boolean'},items={c.items,'table',true},content_hooks={c.content_hooks,'table',true},query_updaters={c.query_updaters,'string'},silent={c.silent,'boolean'}})return c end;b.apply_config=function(c)a.config=c end;b.create_autocommands=function(c)local av=vim.api.nvim_create_augroup('MiniStarter',{})if c.autoopen then local aw=function()if b.is_something_shown()then return end;b.is_in_vimenter=true;vim.cmd('noautocmd lua MiniStarter.open()')end;vim.api.nvim_create_autocmd('VimEnter',{group=av,nested=true,once=true,callback=aw,desc='Open on VimEnter'})end end;b.create_default_hl=function()local ax=function(G,g)g.default=true;vim.api.nvim_set_hl(0,G,g)end;ax('MiniStarterCurrent',{link='MiniStarterItem'})ax('MiniStarterFooter',{link='Title'})ax('MiniStarterHeader',{link='Title'})ax('MiniStarterInactive',{link='Comment'})ax('MiniStarterItem',{link='Normal'})ax('MiniStarterItemBullet',{link='Delimiter'})ax('MiniStarterItemPrefix',{link='WarningMsg'})ax('MiniStarterSection',{link='Delimiter'})ax('MiniStarterQuery',{link='MoreMsg'})end;b.is_disabled=function()return vim.g.ministarter_disable==true or vim.b.ministarter_disable==true end;b.get_config=function(c)return vim.tbl_deep_extend('force',a.config,vim.b.ministarter_config or{},c or{})end;b.normalize_items=function(h)local ag=b.items_flatten(h)if#ag==0 then return{{name='`config.items` is empty',action='',section=''}}end;return b.items_sort(ag)end;b.normalize_header_footer=function(y)if type(y)=='function'then y=y()end;local ag=tostring(y)if ag==''then return{}end;return vim.split(ag,'\n')end;b.make_initial_content=function(ay,h,az)local i={}for k,aa in ipairs(ay)do b.content_add_line(i,{b.content_unit(aa,'header','MiniStarterHeader')})end;b.content_add_empty_lines(i,#ay>0 and 1 or 0)b.content_add_items(i,h)b.content_add_empty_lines(i,#az>0 and 1 or 0)for k,aa in ipairs(az)do b.content_add_line(i,{b.content_unit(aa,'footer','MiniStarterFooter')})end;return i end;b.content_unit=function(string,type,aA,aB)return vim.tbl_extend('force',{string=string,type=type,hl=aA},aB or{})end;b.content_add_line=function(i,ah)table.insert(i,ah)end;b.content_add_empty_lines=function(i,n)for k=1,n do b.content_add_line(i,{b.content_unit('','empty',nil)})end end;b.content_add_items=function(i,h)local X;for k,a1 in ipairs(h)do if X~=a1.section then b.content_add_empty_lines(i,X==nil and 0 or 1)b.content_add_line(i,{b.content_unit(a1.section,'section','MiniStarterSection')})X=a1.section end;b.content_add_line(i,{b.content_unit(a1.name,'item','MiniStarterItem',{item=a1})})end end;b.content_highlight=function(d)for R,ah in ipairs(a.get_content(d))do local ai=0;for k,a0 in ipairs(ah)do if a0.hl~=nil then b.buf_hl(d,b.ns.general,a0.hl,R-1,ai,ai+a0.string:len(),50)end;ai=ai+a0.string:len()end end end;b.items_flatten=function(h)local ag,l={},nil;l=function(y)local aC=0;while type(y)=='function'and aC<=100 do aC=aC+1;if aC>100 then b.message('Too many nested functions in `config.items`.')end;y=y()end;if b.is_item(y)then table.insert(ag,vim.deepcopy(y))return end;if type(y)~='table'then return end;return vim.tbl_map(l,y)end;l(h)return ag end;b.items_sort=function(h)local aD,aE={},{}for k,a1 in ipairs(h)do local aF=a1.section;if aE[aF]==nil then table.insert(aD,{})aE[aF]=#aD end;table.insert(aD[aE[aF]],a1)end;local ag={}for k,aG in ipairs(aD)do for k,a1 in ipairs(aG)do table.insert(ag,a1)end end;return ag end;b.items_highlight=function(d)for k,a1 in ipairs(b.buffer_data[d].items)do b.buf_hl(d,b.ns.general,'MiniStarterItemPrefix',a1._line,a1._start_col,a1._start_col+a1._nprefix,52)end end;b.next_active_item_id=function(d,aH,am)local h=b.buffer_data[d].items;local aI=aH;local aJ=vim.tbl_count(h)local aK=am=='next'and 1 or aJ-1;aI=math.fmod(aI+aK-1,aJ)+1;while not(h[aI]._active or aI==aH)do aI=math.fmod(aI+aK-1,aJ)+1 end;return aI end;b.position_cursor_on_current_item=function(d)local g=b.buffer_data[d]local aj=g.items[g.current_item_id]._cursorpos;for k,a7 in ipairs(b.get_buffer_windows(d))do vim.api.nvim_win_set_cursor(a7,aj)end end;b.item_is_active=function(a1,aq)return vim.startswith(a1.name:lower(),aq)and a1.action~=''end;b.make_query=function(d,aq,aL)if aL==nil then aL=true end;local g=b.buffer_data[d]aq=(aq or g.query):lower()local aM=0;for k,a1 in ipairs(g.items)do aM=aM+(b.item_is_active(a1,aq)and 1 or 0)end;if aM==0 and aq~=''then b.message(('Query %s results into no active items. Current query: %s'):format(vim.inspect(aq),g.query))return end;g.query=aq;for k,a1 in ipairs(g.items)do a1._active=b.item_is_active(a1,aq)end;if not g.items[g.current_item_id]._active then a.update_current_item('next',d)end;vim.api.nvim_buf_clear_namespace(d,b.ns.activity,0,-1)b.add_hl_activity(d,aq)if b.get_config().evaluate_single and aM==1 then a.eval_current_item(d)return end;if aL and not b.is_in_vimenter and vim.o.cmdheight>0 then vim.cmd('redraw')b.echo(('Query: %s'):format(aq))end end;b.make_buffer_autocmd=function(d)local av=vim.api.nvim_create_augroup('MiniStarterBuffer',{})local aN=function(aO,aP,aQ)vim.api.nvim_create_autocmd(aO,{group=av,buffer=d,callback=aP,desc=aQ})end;aN('VimResized',function()a.refresh(d)end,'Refresh')aN('CursorMoved',function()b.position_cursor_on_current_item(d)end,'Position cursor')local aR=vim.o.showtabline;aN('BufLeave',function()if vim.o.cmdheight>0 then vim.cmd("echo ''")end;if vim.o.showtabline==1 then vim.o.showtabline=aR end end,'On BufLeave')end;b.apply_buffer_options=function(d)vim.api.nvim_feedkeys('\28\14','nx',false)b.buffer_number=b.buffer_number+1;local G=b.buffer_number<=1 and'Starter'or'Starter_'..b.buffer_number;for k,aS in ipairs(vim.api.nvim_list_bufs())do if vim.fn.fnamemodify(vim.api.nvim_buf_get_name(aS),':t')==G then G='ministarter://'..b.buffer_number;break end end;vim.api.nvim_buf_set_name(d,G)vim.cmd('noautocmd silent! set filetype=ministarter')local aT={'bufhidden=wipe','colorcolumn=','foldcolumn=0','matchpairs=','nobuflisted','nocursorcolumn','nocursorline','nolist','nonumber','noreadonly','norelativenumber','nospell','noswapfile','signcolumn=no','synmaxcol&','buftype=nofile','nomodeline','nomodifiable','foldlevel=999','nowrap'}vim.cmd(('silent! noautocmd setlocal %s'):format(table.concat(aT,' ')))vim.o.showtabline=1;vim.b.minicursorword_disable=true;vim.b.minitrailspace_disable=true;if _G.MiniTrailspace~=nil then _G.MiniTrailspace.unhighlight()end end;b.apply_buffer_mappings=function(d)local aU=function(aV,aW)vim.keymap.set('n',aV,('<Cmd>lua %s<CR>'):format(aW),{buffer=d,nowait=true,silent=true})end;aU('<CR>','MiniStarter.eval_current_item()')aU('<Up>',[[MiniStarter.update_current_item('prev')]])aU('<C-p>',[[MiniStarter.update_current_item('prev')]])aU('<M-k>',[[MiniStarter.update_current_item('prev')]])aU('<Down>',[[MiniStarter.update_current_item('next')]])aU('<C-n>',[[MiniStarter.update_current_item('next')]])aU('<M-j>',[[MiniStarter.update_current_item('next')]])for k,aV in ipairs(vim.split(b.get_config().query_updaters,''))do local aX=vim.inspect(tostring(aV))aU(aV,('MiniStarter.add_to_query(%s)'):format(aX))end;aU('<Esc>',[[MiniStarter.set_query('')]])aU('<BS>','MiniStarter.add_to_query()')aU('<C-c>','MiniStarter.close()')end;b.add_hl_activity=function(d,aq)for k,a1 in ipairs(b.buffer_data[d].items)do local aa=a1._line;local aY=a1._start_col;local aZ=a1._end_col;if a1._active then b.buf_hl(d,b.ns.activity,'MiniStarterQuery',aa,aY,aY+aq:len(),53)else b.buf_hl(d,b.ns.activity,'MiniStarterInactive',aa,aY,aZ,53)end end end;b.add_hl_current_item=function(d)local g=b.buffer_data[d]local a_=g.items[g.current_item_id]b.buf_hl(d,b.ns.current_item,'MiniStarterCurrent',a_._line,a_._start_col,a_._end_col,51)end;b.is_fun_or_string=function(y,b0)if b0==nil then b0=true end;return b0 and y==nil or type(y)=='function'or type(y)=='string'end;b.is_item=function(y)return type(y)=='table'and b.is_fun_or_string(y['action'],false)and type(y['name'])=='string'and type(y['section'])=='string'end;b.is_something_shown=function()if vim.fn.argc()>0 then return true end;local b1=vim.tbl_filter(function(d)return vim.fn.buflisted(d)==1 end,vim.api.nvim_list_bufs())if#b1>1 then return true end;if vim.bo.filetype~=''then return true end;local b2=vim.api.nvim_buf_line_count(0)if b2>1 then return true end;local b3=vim.api.nvim_buf_get_lines(0,0,1,true)[1]if string.len(b3)>0 then return true end;return false end;b.echo=function(b4,b5)if b.get_config().silent then return end;b4=type(b4)=='string'and{{b4}}or b4;table.insert(b4,1,{'(mini.starter) ','WarningMsg'})local b6=vim.o.columns*math.max(vim.o.cmdheight-1,0)+vim.v.echospace;local b7,b8={},0;for k,b9 in ipairs(b4)do local ba={vim.fn.strcharpart(b9[1],0,b6-b8),b9[2]}table.insert(b7,ba)b8=b8+vim.fn.strdisplaywidth(ba[1])if b8>=b6 then break end end;vim.cmd([[echo '' | redraw]])vim.api.nvim_echo(b7,b5,{})end;b.message=function(b4)b.echo(b4,true)end;b.error=function(b4)error(string.format('(mini.starter) %s',b4))end;b.validate_starter_buf_id=function(d,bb,bc)local bd=type(d)=='number'and vim.tbl_contains(vim.tbl_keys(b.buffer_data),d)and vim.api.nvim_buf_is_valid(d)if bd then return true end;local b4=string.format('`buf_id` in `%s` is not an identifier of valid Starter buffer.',bb)if bc=='error'then b.error(b4)end;b.message(b4)return false end;b.eval_fun_or_string=function(y,be)if type(y)=='function'then return y()end;if type(y)=='string'then if be then vim.cmd(y)else return y end end end;b.buf_hl=function(d,bf,bg,K,bh,bi,bj)local bk={end_row=K,end_col=bi,hl_group=bg,priority=bj}vim.api.nvim_buf_set_extmark(d,bf,K,bh,bk)end;b.get_buffer_windows=function(d)return vim.tbl_filter(function(a7)return vim.api.nvim_win_get_buf(a7)==d end,vim.api.nvim_list_wins())end;b.unique_nprefix=function(ak)local bl=vim.deepcopy(ak)local ag,bm={},0;while vim.tbl_count(bl)>0 do bm=bm+1;local bn,bo={},true;for aI,aY in pairs(bl)do bo=bo and#aY<bm;local bp=aY:sub(1,bm)bn[bp]=bn[bp]==nil and{}or bn[bp]table.insert(bn[bp],aI)end;if bo then for bq,aY in pairs(bl)do ag[bq]=#aY end;break end;for k,br in pairs(bn)do if#br==1 then local bq=br[1]ag[bq]=math.min(#bl[bq],bm)bl[bq]=nil end end end;return ag end;return a