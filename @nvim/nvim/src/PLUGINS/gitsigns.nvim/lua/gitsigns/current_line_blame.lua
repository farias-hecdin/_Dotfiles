local a=require('gitsigns.async')local b=a.wrap;local c=a.void;local d=a.scheduler;local e=require('gitsigns.cache').cache;local f=require('gitsigns.config').config;local g=require('gitsigns.git').BlameInfo;local h=require('gitsigns.util')local i=require('gitsigns.uv')local j=vim.api;local k=j.nvim_get_current_buf;local l=j.nvim_create_namespace('gitsigns_blame')local m=i.new_timer(true)local n={}local o=b(vim.loop.timer_start,4)local function p(q,r,s)s=s or{}s.id=1;j.nvim_buf_set_extmark(q,l,r-1,0,s)end;local function t(q)local u=j.nvim_buf_get_extmark_by_id(q,l,1,{})if u[1]then return u[1]+1 end;return end;local function v(q)q=q or k()j.nvim_buf_del_extmark(q,l,1)vim.b[q].gitsigns_blame_line_dict=nil end;local w=1000;local x={Elem={}}x.contents={}function x:add(q,y,z)if not f._blame_cache then return end;local A=self.contents[q]if A.size<=w then A.cache[y]=z;A.size=A.size+1 end end;function x:get(q,y)if not f._blame_cache then return end;local B=vim.b[q].changedtick;if not self.contents[q]or self.contents[q].tick~=B then self.contents[q]={tick=B,cache={},size=0}end;return self.contents[q].cache[y]end;local function C(D,E,F)if F.author==E then F.author='You'end;return h.expand_format(D,F,f.current_line_blame_formatter_opts.relative_time)end;local function G(H)local I={}for J,K in ipairs(H)do I[#I+1]=K[1]end;return table.concat(I)end;local L=c(function()local q=k()local y=j.nvim_win_get_cursor(0)[1]local M=t(q)if M and y==M and x:get(q,y)then return end;if j.nvim_get_mode().mode=='i'then v(q)return end;if t(q)then v(q)p(q,y)end;if vim.fn.foldclosed(y)~=-1 then return end;local s=f.current_line_blame_opts;o(m,s.delay,0)d()local N=e[q]if not N or not N.git_obj.object_name then return end;local O=x:get(q,y)if not O then local P=h.buf_lines(q)O=N.git_obj:run_blame(P,y,s.ignore_whitespace)x:add(q,y,O)d()end;local Q=j.nvim_win_get_cursor(0)[1]if q==k()and y~=Q then return end;if not j.nvim_buf_is_loaded(q)then return end;vim.b[q].gitsigns_blame_line_dict=O;if O then local H;local R=O.author=='Not Committed Yet'and f.current_line_blame_formatter_nc or f.current_line_blame_formatter;if type(R)=="string"then H={{C(R,N.git_obj.repo.username,O),'GitSignsCurrentLineBlame'}}else H=R(N.git_obj.repo.username,O,f.current_line_blame_formatter_opts)end;vim.b[q].gitsigns_blame_line=G(H)if s.virt_text then p(q,y,{virt_text=H,virt_text_pos=s.virt_text_pos,priority=s.virt_text_priority,hl_mode='combine'})end end end)n.setup=function()j.nvim_create_augroup('gitsigns_blame',{})for S,J in pairs(e)do v(S)end;if f.current_line_blame then j.nvim_create_autocmd({'FocusGained','BufEnter','CursorMoved','CursorMovedI'},{group='gitsigns_blame',callback=function()L()end})j.nvim_create_autocmd({'InsertEnter','FocusLost','BufLeave'},{group='gitsigns_blame',callback=function()v()end})vim.schedule(L)end end;return n