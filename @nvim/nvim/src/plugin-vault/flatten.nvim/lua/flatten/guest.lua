local a={}local function b()return string.sub(package["config"],1,1)=="\\"end;local function c(d)return d:gsub("\\","/")end;local function e(f,g,h)if#g<1 and#h<1 then return end;local i=require("flatten").config;local j=vim.g.flatten_wait~=nil or i.callbacks.should_block(vim.v.argv)local k=vim.fn.fnameescape(vim.v.servername)local l=vim.fn.fnameescape(vim.fn.getcwd(-1,-1))if b()then k=c(k)l=c(l)end;local m=string.format([[return require('flatten.core').edit_files(%s)]],vim.inspect({files=g,response_pipe=k,guest_cwd=l,stdin=h,argv=vim.v.argv,force_block=j}))for n,o in ipairs(vim.api.nvim_list_bufs())do vim.api.nvim_buf_delete(o,{force=true})end;local p=vim.fn.rpcrequest(f,"nvim_exec_lua",m,{})or j;if not p then vim.cmd("qa!")end;vim.fn.chanclose(f)while true do vim.cmd("sleep 1")end end;a.init=function(q)local f=vim.fn.sockconnect("pipe",q,{rpc=true})if f==0 then return end;local g=vim.fn.argv()local r=#g;vim.api.nvim_create_autocmd("StdinReadPost",{pattern="*",callback=function()local s=vim.api.nvim_buf_get_lines(0,0,-1,true)e(f,g,s)end})vim.api.nvim_create_autocmd("BufEnter",{pattern="*",callback=function()if r<1 then if require("flatten").config.nest_if_no_args==true then return end;vim.cmd("qa!")end;e(f,g,{})end})end;return a
