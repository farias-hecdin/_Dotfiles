local a={}local function b(c,d)local e=vim.fn.sockconnect("pipe",c,{rpc=true})vim.fn.rpcnotify(e,"nvim_exec_lua","vim.cmd('qa!')",{})vim.fn.chanclose(e)for f,g in ipairs(d)do vim.api.nvim_del_autocmd(g)end end;local function h(i,j,k,l)local m;local n;local o;m=vim.api.nvim_create_autocmd("QuitPre",{buffer=j,once=true,callback=function()b(i,{n,o})k(l)end})n=vim.api.nvim_create_autocmd("BufUnload",{buffer=j,once=true,callback=function()b(i,{m,o})k(l)end})o=vim.api.nvim_create_autocmd("BufDelete",{buffer=j,once=true,callback=function()b(i,{m,n})k(l)end})end;a.edit_files=function(p)local q=p.files;local r=p.response_pipe;local s=p.guest_cwd;local t=p.stdin;local u=p.force_block;local v=p.argv;local w=require("flatten").config;local x=w.callbacks;local y=w.window.focus=="first"local z=w.window.open;local A=#q;local B=#t;local C={}if A==0 and B==0 then return false end;local D=false;if w.allow_cmd_passthrough then for f,E in ipairs(v)do if D then D=false;if vim.api.nvim_exec2 then vim.api.nvim_exec2(E,{})else vim.api.nvim_exec(E,false)end elseif E:sub(1,1)=="+"then local g=string.sub(E,2,-1)table.insert(C,g)elseif E=="--cmd"then D=true end end end;x.pre_open()if A>0 then local F=""for G,H in ipairs(q)do local I=string.find(H,"^/")local J=vim.fn.fnameescape(I and H or s.."/"..H)q[G]=J;if F==""or F==nil then F=J else F=F.." "..J end end;local K=vim.o.wildignore;vim.o.wildignore=""vim.cmd("0argadd "..F)vim.o.wildignore=K end;local L=nil;if B>0 then L=vim.api.nvim_create_buf(true,false)vim.api.nvim_buf_set_lines(L,0,0,true,t)local M=t[1]:sub(1,12):gsub("[^%w%.]","")if vim.fn.bufname(M)~=""or M==""then local G=1;local N=M..G;while vim.fn.bufname(N)~=""do G=G+1;N=M..G end;M=N end;vim.api.nvim_buf_set_name(L,M)end;local O;local j;if type(z)=="function"then j=z(q,v,L)if j~=nil then O=vim.fn.bufwinid(j)end elseif type(z)=="string"then local P=vim.fn.argv(y and 0 or#q-1)O=vim.api.nvim_get_current_win()if L then P=vim.api.nvim_buf_get_name(L)end;if z=="current"then vim.cmd("edit "..P)elseif z=="alternate"then O=vim.fn.win_getid(vim.fn.winnr("#"))vim.api.nvim_win_set_buf(O,vim.fn.bufnr(P))vim.api.nvim_set_current_win(O)elseif z=="split"then vim.cmd("split "..P)elseif z=="vsplit"then vim.cmd("vsplit "..P)else vim.cmd("tabedit "..P)end;j=vim.api.nvim_get_current_buf()else vim.api.nvim_err_writeln("Flatten: 'config.open.focus' expects a function or string, got "..type(z))return false end;local l;if j~=nil then l=vim.api.nvim_buf_get_option(j,'filetype')end;local Q=w.block_for[l]or u;for f,g in ipairs(C)do if vim.api.nvim_exec2 then vim.api.nvim_exec2(g,{})else vim.api.nvim_exec(g,false)end end;x.post_open(j,O,l,Q)if Q then h(r,j,x.block_end,l)end;return Q end;return a
