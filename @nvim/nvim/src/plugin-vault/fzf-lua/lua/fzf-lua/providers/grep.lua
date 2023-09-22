local a=require"fzf-lua.path"local b=require"fzf-lua.core"local c=require"fzf-lua.utils"local d=require"fzf-lua.config"local e=require"fzf-lua.libuv"local f=require"fzf-lua.make_entry"local function g(h)return h:match("^%*")and h or"*"..h end;local i={}function i.get_last_search(j)if j and j.__MODULE__ and j.__MODULE__.get_last_search and c.__FNCREF__()~=j.__MODULE__.get_last_search then return j.__MODULE__.get_last_search(j)end;local k=d.globals.grep._last_search or{}return k.query,k.no_esc end;function i.set_last_search(j,l,m)if j and j.__MODULE__ and j.__MODULE__.set_last_search and c.__FNCREF__()~=j.__MODULE__.set_last_search then j.__MODULE__.set_last_search(j,l,m)return end;d.globals.grep._last_search={query=l,no_esc=m}if d.__resume_data then d.__resume_data.last_query=l end end;local n=function(j,o,m)if j.raw_cmd and#j.raw_cmd>0 then return j.raw_cmd end;local p=nil;if j.cmd and#j.cmd>0 then p=j.cmd elseif vim.fn.executable("rg")==1 then p=string.format("rg %s",j.rg_opts)else p=string.format("grep %s",j.grep_opts)end;if j.rg_glob and not p:match("^rg")then j.rg_glob=false;c.warn("'--glob|iglob' flags require 'rg', ignoring 'rg_glob' option.")end;if j.rg_glob then local q,r=f.glob_parse(o,j)if r then if not(m or j.no_esc)then q=c.rg_escape(q)j.no_esc=true;j.search=("%s%s"):format(q,o:match(j.glob_separator..".*"))end;o=q;p=f.rg_insert_args(p,r)end end;local s=""if j.filespec and#j.filespec>0 then s=j.filespec elseif j.filename and#j.filename>0 then s=e.shellescape(j.filename)end;o=o or""if not(m or j.no_esc)then o=c.rg_escape(o)end;if not j.no_column_hide and#o==0 then p=p:gsub("%s%-%-column","")end;if not(m==2 or j.no_esc==2)then o=e.shellescape(o)end;p=("%s %s %s"):format(p,o,s)if j.filter and#j.filter>0 then p=("%s | %s"):format(p,j.filter)end;return p end;i.grep=function(j)j=d.normalize_opts(j,d.globals.grep)if not j then return end;j.__MODULE__=j.__MODULE__ or i;local m=false;if not j.search and j.resume then j.search,m=i.get_last_search(j)j.search=j.search or j.resume_search_default end;if not j.search and not j.raw_cmd then local t=c.input(j.input_prompt)if t then j.search=t else return end end;j.cmd=n(j,j.search,m)i.set_last_search(j,j.search,m or j.no_esc)local u=b.mt_cmd_wrapper(vim.tbl_deep_extend("force",j,{rg_glob=false}))if type(u)=="string"then u=u.." 2>&1"end;j.fn_post_fzf=function(v,w)local k,w=i.get_last_search(v)local x=d.__resume_data and d.__resume_data.last_query;if not k or#k==0 and(x and#x>0)then i.set_last_search(j,x)end end;j=b.set_header(j,j.headers or{"actions","cwd","search"})j=b.set_fzf_field_index(j)b.fzf_exec(u,j)end;i.live_grep_st=function(j)j=d.normalize_opts(j,d.globals.grep)if not j then return end;j.__MODULE__=j.__MODULE__ or i;j.prompt=g(j.prompt)assert(not j.multiprocess)local m=false;if not j.search and j.resume then j.search,m=i.get_last_search(j)end;j.query=j.search or""if j.search and#j.search>0 then if not(m or j.no_esc)then j.query=c.rg_escape(j.search)end;i.set_last_search(j,j.query,true)end;j.fn_reload=function(l)if l and not(j.save_last_search==false)then i.set_last_search(j,l,true)end;l=l or""j.no_esc=nil;return n(j,l,true)end;if j.requires_processing or j.git_icons or j.file_icons then j.fn_transform=j.fn_transform or function(y)return f.file(y,j)end;j.fn_preprocess=j.fn_preprocess or function(v)return f.preprocess(v)end end;if not j._is_skim then j.fn_post_fzf=function(v,w)local k,w=i.get_last_search(v)local x=d.__resume_data and d.__resume_data.last_query;if not j.exec_empty_query and k~=x then i.set_last_search(j,x or"")end end end;j=b.set_header(j,j.headers or{"actions","cwd"})j=b.set_fzf_field_index(j)b.fzf_exec(nil,j)end;i.live_grep_mt=function(j)j=d.normalize_opts(j,d.globals.grep)if not j then return end;j.__MODULE__=j.__MODULE__ or i;j.__module__=j.__module__ or"grep"j.prompt=g(j.prompt)if j.rg_glob then j.requires_processing=true end;assert(j.multiprocess)local m=false;if not j.search and j.resume then j.search,m=i.get_last_search(j)end;j.query=j.search or""if j.search and#j.search>0 then if not(m or j.no_esc)then j.query=c.rg_escape(j.search)end;i.set_last_search(j,j.query,true)end;j.argv_expr=true;j.cmd=n(j,b.fzf_query_placeholder,2)local p=b.mt_cmd_wrapper(j)if p~=j.cmd then p=p:gsub(b.fzf_query_placeholder,"{argvz}").." -- "..b.fzf_query_placeholder end;j.fn_reload=p;if not j._is_skim then j.fn_post_fzf=function(v,w)local k,w=i.get_last_search(v)local x=d.__resume_data and d.__resume_data.last_query;if not j.exec_empty_query and k~=x or not j.requires_processing and not j.git_icons and not j.file_icons then i.set_last_search(j,x or"",true)end end end;j=b.set_header(j,j.headers or{"actions","cwd"})j=b.set_fzf_field_index(j)b.fzf_exec(nil,j)end;i.live_grep_glob_st=function(j)if vim.fn.executable("rg")~=1 then c.warn("'--glob|iglob' flags requires 'rg' (https://github.com/BurntSushi/ripgrep)")return end;j=j or{}j.rg_glob=true;return i.live_grep_st(j)end;i.live_grep_glob_mt=function(j)if vim.fn.executable("rg")~=1 then c.warn("'--glob|iglob' flags requires 'rg' (https://github.com/BurntSushi/ripgrep)")return end;j=j or{}j.rg_glob=true;return i.live_grep_mt(j)end;i.live_grep_native=function(j)j=j or{}j.git_icons=false;j.file_icons=false;j.path_shorten=false;j.rg_glob=false;return i.live_grep_mt(j)end;i.live_grep=function(j)j=d.normalize_opts(j,d.globals.grep)if not j then return end;if j.multiprocess then return i.live_grep_mt(j)else return i.live_grep_st(j)end end;i.live_grep_glob=function(j)j=d.normalize_opts(j,d.globals.grep)if not j then return end;if j.multiprocess then return i.live_grep_glob_mt(j)else return i.live_grep_glob_st(j)end end;i.live_grep_resume=function(j)if not j then j={}end;j.resume=true;return i.live_grep(j)end;i.grep_last=function(j)if not j then j={}end;j.resume=true;return i.grep(j)end;i.grep_cword=function(j)if not j then j={}end;j.search=vim.fn.expand("<cword>")return i.grep(j)end;i.grep_cWORD=function(j)if not j then j={}end;j.search=vim.fn.expand("<cWORD>")return i.grep(j)end;i.grep_visual=function(j)if not j then j={}end;j.search=c.get_visual_selection()return i.grep(j)end;i.grep_project=function(j)if not j then j={}end;if not j.search then j.search=""end;j.fzf_opts=j.fzf_opts or{}if j.fzf_opts["--delimiter"]==nil then j.fzf_opts["--delimiter"]=":"end;if j.fzf_opts["--nth"]==nil then j.fzf_opts["--nth"]="3.."end;return i.grep(j)end;i.grep_curbuf=function(j)if type(j)=="function"then j=j()elseif not j then j={}end;j.rg_glob=false;j.rg_opts=f.rg_insert_args(d.globals.grep.rg_opts," --with-filename")j.grep_opts=f.rg_insert_args(d.globals.grep.grep_opts," --with-filename")if j.exec_empty_query==nil then j.exec_empty_query=true end;j.fzf_opts=vim.tbl_extend("keep",j.fzf_opts or{},d.globals.blines.fzf_opts)j.filename=vim.api.nvim_buf_get_name(0)if#j.filename>0 and vim.loop.fs_stat(j.filename)then j.filename=a.relative(j.filename,vim.loop.cwd())if j.lgrep then return i.live_grep(j)else j.search=j.search or""return i.grep(j)end else c.info("Rg current buffer requires file on disk")return end end;i.lgrep_curbuf=function(j)if type(j)=="function"then j=j()elseif not j then j={}end;j.lgrep=true;return i.grep_curbuf(j)end;return i
