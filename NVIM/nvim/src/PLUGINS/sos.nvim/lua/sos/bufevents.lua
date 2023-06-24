local a=require("sos.util").errmsg;local b=vim.api;local c={}function c:new(d,e)local f=false;local g=false;local h={autocmds={},listeners={},pending_detach={},buf_callback={},cfg=d,timer=e}h.on_timer=vim.schedule_wrap(h.cfg.on_timer)function h:on_change(i)if self:should_detach(i)then return true end;local j=self.timer;local k,l,m=j:stop()assert(k==0,l)k,l,m=j:start(self.cfg.timeout,0,self.on_timer)assert(k==0,l)end;h.buf_callback.on_lines=function(m,i)return h:on_change(i)end;h.buf_callback.on_detach=function(m,i)h.listeners[i]=nil;h.pending_detach[i]=nil end;function h:attach(i)self.pending_detach[i]=nil;if self.listeners[i]==nil then assert(b.nvim_buf_attach(i,false,{on_lines=h.buf_callback.on_lines,on_detach=h.buf_callback.on_detach}),"failed to attach to buffer "..i)self.listeners[i]=true end end;function h:should_detach(i)return g or self.pending_detach[i]end;function h:detach(i)if self.listeners[i]then self.pending_detach[i]=true end end;function h:process_buf(i)if i==0 then i=b.nvim_get_current_buf()end;if self.cfg.should_observe_buf(i)then if b.nvim_buf_is_loaded(i)then self:attach(i)end else self:detach(i)end end;function h:destroy()g=true;for m,n in ipairs(self.autocmds)do b.nvim_del_autocmd(n)end;self.autocmds={}self.listeners={}self.pending_detach={}end;function h:start()assert(not f,"unable to start an already running MultiBufObserver")assert(not g,"unable to start a destroyed MultiBufObserver")f=true;vim.list_extend(self.autocmds,{b.nvim_create_autocmd("OptionSet",{pattern={"buftype","readonly","modifiable"},desc="Handle buffer type and option changes",callback=function(o)if not o.buf then a("OptionSet callback: autocmd event info missing `buf` (<abuf>)")return end;self:process_buf(o.buf)end}),b.nvim_create_autocmd("BufModifiedSet",{pattern="*",desc="Attach buffer callbacks to listen for changes",callback=function(o)local i=o.buf;local p=vim.bo[i].mod;if not i then a("BufModifiedSet callback: autocmd event info missing `buf` (<abuf>)")return end;if not b.nvim_buf_is_loaded(i)then a("unexpected BufModifiedSet event on unloaded buffer")return end;if p then self:process_buf(i)self:on_change(i)end end})})for m,q in ipairs(b.nvim_list_bufs())do self:process_buf(q)end end;return h end;return c