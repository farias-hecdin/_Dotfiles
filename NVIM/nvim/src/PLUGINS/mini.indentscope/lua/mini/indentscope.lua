local a={}local b={}a.setup=function(c)if vim.fn.has('nvim-0.7')==0 then vim.notify('(mini.indentscope) Neovim<0.7 is soft deprecated (module works but not supported).'..' It will be deprecated after Neovim 0.9.0 release (module will not work).'..' Please update your Neovim version.')end;_G.MiniIndentscope=a;c=b.setup_config(c)b.apply_config(c)vim.api.nvim_exec([[augroup MiniIndentscope
        au!
        au CursorMoved,CursorMovedI                          * lua MiniIndentscope.auto_draw({ lazy = true })
        au TextChanged,TextChangedI,TextChangedP,WinScrolled * lua MiniIndentscope.auto_draw()
      augroup END]],false)if vim.fn.exists('##ModeChanged')==1 then vim.api.nvim_exec([[augroup MiniIndentscope
          au ModeChanged *:* lua MiniIndentscope.auto_draw({ lazy = true })
        augroup END]],false)end;vim.api.nvim_exec([[hi default link MiniIndentscopeSymbol Delimiter
      hi default link MiniIndentscopeSymbolOff MiniIndentscopeSymbol]],false)end;a.config={draw={delay=100,animation=function(d,e)return 20 end,priority=2},mappings={object_scope='ii',object_scope_with_border='ai',goto_top='[i',goto_bottom=']i'},options={border='both',indent_at_cursor=true,try_as_border=false},symbol='╎'}a.get_scope=function(f,g,h)h=b.get_config({options=h}).options;if not(f and g)then local i=vim.fn.getcurpos()f=f or i[2]f=h.try_as_border and b.border_correctors[h.border](f,h)or f;g=g or(h.indent_at_cursor and i[5]or math.huge)end;local j=b.get_line_indent(f,h)local k=math.min(g,j)local l={indent=k}if k<=0 then l.top,l.bottom,l.indent=1,vim.fn.line('$'),j else local m,n;l.top,m=b.cast_ray(f,k,'up',h)l.bottom,n=b.cast_ray(f,k,'down',h)l.indent=math.min(j,m,n)end;return{body=l,border=b.border_from_body[h.border](l,h),buf_id=vim.api.nvim_get_current_buf(),reference={line=f,column=g,indent=k}}end;a.auto_draw=function(h)if b.is_disabled()then b.undraw_scope()return end;h=h or{}local o=a.get_scope()if h.lazy and b.current.draw_status~='none'and b.scope_is_equal(o,b.current.scope)then return end;local p=b.current.event_id+1;b.current.event_id=p;local q=b.make_autodraw_opts(o)if q.delay>0 then b.undraw_scope(q)end;vim.defer_fn(function()if b.current.event_id~=p then return end;b.undraw_scope(q)b.current.scope=o;b.draw_scope(o,q)end,q.delay)end;a.draw=function(o,h)o=o or a.get_scope()local c=b.get_config()local q=vim.tbl_deep_extend('force',{animation_fun=c.draw.animation,priority=c.draw.priority},h or{})b.undraw_scope()b.current.scope=o;b.draw_scope(o,q)end;a.undraw=function()b.undraw_scope()end;a.gen_animation={}a.gen_animation.none=function()return function()return 0 end end;a.gen_animation.linear=function(h)return b.animation_arithmetic_powers(0,b.normalize_animation_opts(h))end;a.gen_animation.quadratic=function(h)return b.animation_arithmetic_powers(1,b.normalize_animation_opts(h))end;a.gen_animation.cubic=function(h)return b.animation_arithmetic_powers(2,b.normalize_animation_opts(h))end;a.gen_animation.quartic=function(h)return b.animation_arithmetic_powers(3,b.normalize_animation_opts(h))end;a.gen_animation.exponential=function(h)return b.animation_geometrical_powers(b.normalize_animation_opts(h))end;a.move_cursor=function(r,s,o)o=o or a.get_scope()local t=s and o.border[r]or o.body[r]t=math.min(math.max(t,1),vim.fn.line('$'))vim.api.nvim_win_set_cursor(0,{t,0})vim.cmd('normal! ^')end;a.operator=function(r,u)local o=a.get_scope()if b.scope_get_draw_indent(o)<0 then return end;local v=vim.v.count1;if u then vim.cmd('normal! m`')end;for w=1,v do a.move_cursor(r,true,o)o=a.get_scope(nil,nil,{try_as_border=false})if b.scope_get_draw_indent(o)<0 then return end end end;a.textobject=function(s)local o=a.get_scope()if b.scope_get_draw_indent(o)<0 then return end;local v=s and vim.v.count1 or 1;for w=1,v do local x,y='top','bottom'if s and o.border.bottom==nil then x,y='bottom','top'end;b.exit_visual_mode()a.move_cursor(x,s,o)vim.cmd('normal! V')a.move_cursor(y,s,o)o=a.get_scope(nil,nil,{try_as_border=false})if b.scope_get_draw_indent(o)<0 then return end end end;b.default_config=a.config;b.ns_id=vim.api.nvim_create_namespace('MiniIndentscope')b.timer=vim.loop.new_timer()b.current={event_id=0,scope={},draw_status='none'}b.indent_funs={['min']=function(z,A)return math.min(z,A)end,['max']=function(z,A)return math.max(z,A)end,['top']=function(z,A)return z end,['bottom']=function(z,A)return A end}b.blank_indent_funs={['none']=b.indent_funs.min,['top']=b.indent_funs.bottom,['bottom']=b.indent_funs.top,['both']=b.indent_funs.max}b.border_from_body={['none']=function(l,h)return{}end,['top']=function(l,h)return{top=l.top-1,indent=b.get_line_indent(l.top-1,h)}end,['bottom']=function(l,h)return{bottom=l.bottom+1,indent=b.get_line_indent(l.bottom+1,h)}end,['both']=function(l,h)return{top=l.top-1,bottom=l.bottom+1,indent=math.max(b.get_line_indent(l.top-1,h),b.get_line_indent(l.bottom+1,h))}end}b.border_correctors={['none']=function(f,h)return f end,['top']=function(f,h)local B,C=b.get_line_indent(f,h),b.get_line_indent(f+1,h)return B<C and f+1 or f end,['bottom']=function(f,h)local D,B=b.get_line_indent(f-1,h),b.get_line_indent(f,h)return B<D and f-1 or f end,['both']=function(f,h)local D,B,C=b.get_line_indent(f-1,h),b.get_line_indent(f,h),b.get_line_indent(f+1,h)if D<=B and C<=B then return f end;if D<=C then return f+1 end;return f-1 end}b.setup_config=function(c)vim.validate({config={c,'table',true}})c=vim.tbl_deep_extend('force',b.default_config,c or{})vim.validate({draw={c.draw,'table'},mappings={c.mappings,'table'},options={c.options,'table'},symbol={c.symbol,'string'}})vim.validate({['draw.delay']={c.draw.delay,'number'},['draw.animation']={c.draw.animation,'function'},['draw.priority']={c.draw.priority,'number'},['mappings.object_scope']={c.mappings.object_scope,'string'},['mappings.object_scope_with_border']={c.mappings.object_scope_with_border,'string'},['mappings.goto_top']={c.mappings.goto_top,'string'},['mappings.goto_bottom']={c.mappings.goto_bottom,'string'},['options.border']={c.options.border,'string'},['options.indent_at_cursor']={c.options.indent_at_cursor,'boolean'},['options.try_as_border']={c.options.try_as_border,'boolean'}})return c end;b.apply_config=function(c)a.config=c;local E=c.mappings;b.map('n',E.goto_top,[[<Cmd>lua MiniIndentscope.operator('top', true)<CR>]],{desc='Go to indent scope top'})b.map('n',E.goto_bottom,[[<Cmd>lua MiniIndentscope.operator('bottom', true)<CR>]],{desc='Go to indent scope bottom'})b.map('x',E.goto_top,[[<Cmd>lua MiniIndentscope.operator('top')<CR>]],{desc='Go to indent scope top'})b.map('x',E.goto_bottom,[[<Cmd>lua MiniIndentscope.operator('bottom')<CR>]],{desc='Go to indent scope bottom'})b.map('x',E.object_scope,'<Cmd>lua MiniIndentscope.textobject(false)<CR>',{desc='Object scope'})b.map('x',E.object_scope_with_border,'<Cmd>lua MiniIndentscope.textobject(true)<CR>',{desc='Object scope with border'})b.map('o',E.goto_top,[[<Cmd>lua MiniIndentscope.operator('top')<CR>]],{desc='Go to indent scope top'})b.map('o',E.goto_bottom,[[<Cmd>lua MiniIndentscope.operator('bottom')<CR>]],{desc='Go to indent scope bottom'})b.map('o',E.object_scope,'<Cmd>lua MiniIndentscope.textobject(false)<CR>',{desc='Object scope'})b.map('o',E.object_scope_with_border,'<Cmd>lua MiniIndentscope.textobject(true)<CR>',{desc='Object scope with border'})end;b.is_disabled=function()return vim.g.miniindentscope_disable==true or vim.b.miniindentscope_disable==true end;b.get_config=function(c)return vim.tbl_deep_extend('force',a.config,vim.b.miniindentscope_config or{},c or{})end;b.get_line_indent=function(f,h)local F=vim.fn.prevnonblank(f)local G=vim.fn.indent(F)if f~=F then local C=vim.fn.indent(vim.fn.nextnonblank(f))local H=b.blank_indent_funs[h.border]G=H(G,C)end;return G end;b.cast_ray=function(f,k,I,h)local J,K=1,-1;if I=='down'then J,K=vim.fn.line('$'),1 end;local L=math.huge;for M=f,J,K do local N=b.get_line_indent(M+K,h)if N<k then return M,L end;if N<L then L=N end end;return J,L end;b.scope_get_draw_indent=function(o)return o.border.indent or o.body.indent-1 end;b.scope_is_equal=function(O,P)if type(O)~='table'or type(P)~='table'then return false end;return O.buf_id==P.buf_id and b.scope_get_draw_indent(O)==b.scope_get_draw_indent(P)and O.body.top==P.body.top and O.body.bottom==P.body.bottom end;b.scope_has_intersect=function(O,P)if type(O)~='table'or type(P)~='table'then return false end;if O.buf_id~=P.buf_id or b.scope_get_draw_indent(O)~=b.scope_get_draw_indent(P)then return false end;local Q,R=O.body,P.body;return R.top<=Q.top and Q.top<=R.bottom or Q.top<=R.top and R.top<=Q.bottom end;b.indicator_compute=function(o)o=o or b.current.scope;local k=b.scope_get_draw_indent(o)if k<0 then return{}end;local g=k-vim.fn.winsaveview().leftcol;if g<0 then return{}end;local S=k%vim.fn.shiftwidth()==0 and'MiniIndentscopeSymbol'or'MiniIndentscopeSymbolOff'local T={{b.get_config().symbol,S}}return{buf_id=vim.api.nvim_get_current_buf(),virt_text=T,virt_text_win_col=g,top=o.body.top,bottom=o.body.bottom}end;b.draw_scope=function(o,h)o=o or{}h=h or{}local U=b.indicator_compute(o)if U.virt_text==nil or#U.virt_text==0 then b.current.draw_status='finished'return end;local V=b.make_draw_function(U,h)b.current.draw_status='drawing'b.draw_indicator_animation(U,V,h.animation_fun)end;b.draw_indicator_animation=function(U,V,W)local X,Y=U.top,U.bottom;local Z=math.min(math.max(vim.fn.line('.'),X),Y)local _=0;local a0=math.max(Z-X,Y-Z)local a1=0;local a2;a2=vim.schedule_wrap(function()local a3=V(Z-_)if _>0 then a3=a3 and V(Z+_)end;if not a3 or _==a0 then b.current.draw_status=_==a0 and'finished'or b.current.draw_status;b.timer:stop()return end;_=_+1;a1=a1+W(_,a0)if a1<1 then b.timer:set_repeat(0)return a2()else b.timer:set_repeat(a1)a1=a1-b.timer:get_repeat()b.timer:again()end end)b.timer:start(10000000,0,a2)a2()end;b.undraw_scope=function(h)h=h or{}if h.event_id and h.event_id~=b.current.event_id then return end;pcall(vim.api.nvim_buf_clear_namespace,b.current.scope.buf_id or 0,b.ns_id,0,-1)b.current.draw_status='none'b.current.scope={}end;b.make_autodraw_opts=function(o)local c=b.get_config()local G={event_id=b.current.event_id,type='animation',delay=c.draw.delay,animation_fun=c.draw.animation,priority=c.draw.priority}if b.current.draw_status=='none'then return G end;if b.scope_has_intersect(o,b.current.scope)then G.type='immediate'G.delay=0;G.animation_fun=a.gen_animation.none()return G end;return G end;b.make_draw_function=function(U,h)local a4={hl_mode='combine',priority=h.priority,right_gravity=false,virt_text=U.virt_text,virt_text_win_col=U.virt_text_win_col,virt_text_pos='overlay'}local a5=h.event_id;return function(M)if b.current.event_id~=a5 and a5~=nil then return false end;if b.is_disabled()then return false end;if not(U.top<=M and M<=U.bottom)then return true end;return pcall(vim.api.nvim_buf_set_extmark,U.buf_id,b.ns_id,M-1,0,a4)end end;b.animation_arithmetic_powers=function(a6,h)local a7=({[0]=function(a0)return a0 end,[1]=function(a0)return a0*(a0+1)/2 end,[2]=function(a0)return a0*(a0+1)*(2*a0+1)/6 end,[3]=function(a0)return a0^2*(a0+1)^2/4 end})[a6]local a8,a9=h.unit,h.duration;local aa=function(a0,ab)local ac=a8=='total'and a9 or a9*a0;local ad;if ab then ad=2*a7(math.ceil(0.5*a0))-(a0%2==1 and 1 or 0)else ad=a7(a0)end;return ac/ad end;return({['in']=function(d,e)return aa(e)*(e-d+1)^a6 end,['out']=function(d,e)return aa(e)*d^a6 end,['in-out']=function(d,e)local ae=math.ceil(0.5*e)local af;if e%2==0 then af=d<=ae and ae-d+1 or d-ae else af=d<ae and ae-d+1 or d-ae+1 end;return aa(e,true)*af^a6 end})[h.easing]end;b.animation_geometrical_powers=function(h)local a8,a9=h.unit,h.duration;local aa=function(a0,ab)local ac=a8=='step'and a9*a0 or a9;if a0==1 then return ac+1 end;if ab then local ae=math.ceil(0.5*a0)if a0%2==1 then ac=ac+math.pow(0.5*ac+1,1/ae)-1 end;return math.pow(0.5*ac+1,1/ae)end;return math.pow(ac+1,1/a0)end;return({['in']=function(d,e)local ag=aa(e)return(ag-1)*ag^(e-d)end,['out']=function(d,e)local ag=aa(e)return(ag-1)*ag^(d-1)end,['in-out']=function(d,e)local ae,ag=math.ceil(0.5*e),aa(e,true)local af;if e%2==0 then af=d<=ae and ae-d or d-ae-1 else af=d<ae and ae-d or d-ae end;return(ag-1)*ag^af end})[h.easing]end;b.normalize_animation_opts=function(ah)ah=vim.tbl_deep_extend('force',{easing='in-out',duration=20,unit='step'},ah or{})if not vim.tbl_contains({'in','out','in-out'},ah.easing)then b.error([[In `gen_animation` option `easing` should be one of 'in', 'out', or 'in-out'.]])end;if type(ah.duration)~='number'or ah.duration<0 then b.error([[In `gen_animation` option `duration` should be a positive number.]])end;if not vim.tbl_contains({'total','step'},ah.unit)then b.error([[In `gen_animation` option `unit` should be one of 'step' or 'total'.]])end;return ah end;b.error=function(ai)error(('(mini.indentscope) %s'):format(ai))end;b.map=function(aj,ak,al,h)if ak==''then return end;h=vim.tbl_deep_extend('force',{noremap=true,silent=true},h or{})if vim.fn.has('nvim-0.7')==0 then h.desc=nil end;vim.api.nvim_set_keymap(aj,ak,al,h)end;b.exit_visual_mode=function()local am=vim.api.nvim_replace_termcodes('<C-v>',true,true,true)local an=vim.fn.mode()if an=='v'or an=='V'or an==am then vim.cmd('normal! '..an)end end;return a