local a=require"fzf-lua.path"local b=require"fzf-lua.utils"local c=require"fzf-lua.config"do local d=debug.getinfo(1,"S").source:gsub("^@","")vim.g.fzf_lua_directory=a.parent(d)if not vim.g.loaded_fzf_lua then local e=a.join({a.parent(a.parent(vim.g.fzf_lua_directory)),"plugin","fzf-lua.vim"})if vim.loop.fs_stat(e)then vim.cmd(("source %s"):format(e))end end;if not vim.g.fzf_lua_server then vim.g.fzf_lua_server=vim.fn.serverstart()end end;local f={}function f.setup_highlights()local g={FzfLuaNormal={"winopts.hl.normal","Normal"},FzfLuaBorder={"winopts.hl.border","Normal"},FzfLuaCursor={"winopts.hl.cursor","Cursor"},FzfLuaCursorLine={"winopts.hl.cursorline","CursorLine"},FzfLuaCursorLineNr={"winopts.hl.cursornr","CursorLineNr"},FzfLuaSearch={"winopts.hl.search","IncSearch"},FzfLuaTitle={"winopts.hl.title","FzfLuaNormal"},FzfLuaScrollBorderEmpty={"winopts.hl.scrollborder_e","FzfLuaBorder"},FzfLuaScrollBorderFull={"winopts.hl.scrollborder_f","FzfLuaBorder"},FzfLuaScrollFloatEmpty={"winopts.hl.scrollfloat_e","PmenuSbar"},FzfLuaScrollFloatFull={"winopts.hl.scrollfloat_f","PmenuThumb"},FzfLuaHelpNormal={"winopts.hl.help_normal","FzfLuaNormal"},FzfLuaHelpBorder={"winopts.hl.help_border","FzfLuaBorder"}}for h,i in pairs(g)do local j=c.get_global(i[1])if not j or vim.fn.hlID(j)==0 then j=i[2]end;if vim.fn.has("nvim-0.7")==1 then vim.api.nvim_set_hl(0,h,{default=true,link=j})else vim.cmd(string.format("hi! link %s %s",h,j))end;c.set_global(i[1]:gsub("%.hl%.",".__hl."),h)end;for k,i in pairs(g)do local l=i[1]:gsub("%.hl%.",".__hl.")local m=c.get_global(l)if b.is_hl_cleared(m)then c.set_global(l,"")end end end;f.setup_highlights()function f.load_profile(n)local o=a.join({vim.g.fzf_lua_directory,"profiles",n..".lua"})return b.load_profile(o,nil,true)end;function f.setup(p,q)p=type(p)=="table"and p or{}if type(p[1])=="string"then local r=f.load_profile(p[1])if type(r)=="table"then p=vim.tbl_deep_extend("keep",p,r)end end;if not q then c.reset_defaults()end;local s=vim.tbl_deep_extend("keep",p,c.globals)for t,k in pairs(s.winopts)do if p[t]~=nil then s.winopts[t]=p[t]end end;if p.fzf_binds then b.warn("'fzf_binds' is deprecated, moved under 'keymap.fzf', ".."see ':help fzf-lua-customization'")s.keymap.fzf=p.fzf_binds end;for u,i in pairs({["keymap"]={"fzf","builtin"},["actions"]={"files","buffers"}})do for k,t in ipairs(i)do if p[u]and p[u][t]then s[u][t]=p[u][t]end end end;local v=s.previewers.bat.theme or s.previewers.bat_native.theme;local w=s.previewers.bat.config or s.previewers.bat_native.config;if w then vim.env.BAT_CONFIG_PATH=vim.fn.expand(w)end;if v and#v>0 then vim.env.BAT_THEME=v end;b.set_lua_io(s.lua_io)if s.nbsp then b.nbsp=s.nbsp end;c.globals=s;c.DEFAULTS.globals=s;f.setup_highlights()end;f.defaults=c.globals;f.redraw=function()local x=require"fzf-lua".win.__SELF()if x then x:redraw()end end;do local y={resume={"fzf-lua.core","fzf_resume"},files={"fzf-lua.providers.files","files"},args={"fzf-lua.providers.files","args"},grep={"fzf-lua.providers.grep","grep"},grep_last={"fzf-lua.providers.grep","grep_last"},grep_cword={"fzf-lua.providers.grep","grep_cword"},grep_cWORD={"fzf-lua.providers.grep","grep_cWORD"},grep_visual={"fzf-lua.providers.grep","grep_visual"},grep_curbuf={"fzf-lua.providers.grep","grep_curbuf"},grep_project={"fzf-lua.providers.grep","grep_project"},live_grep={"fzf-lua.providers.grep","live_grep"},live_grep_native={"fzf-lua.providers.grep","live_grep_native"},live_grep_resume={"fzf-lua.providers.grep","live_grep_resume"},live_grep_glob={"fzf-lua.providers.grep","live_grep_glob"},lgrep_curbuf={"fzf-lua.providers.grep","lgrep_curbuf"},tags={"fzf-lua.providers.tags","tags"},btags={"fzf-lua.providers.tags","btags"},tags_grep={"fzf-lua.providers.tags","grep"},tags_grep_cword={"fzf-lua.providers.tags","grep_cword"},tags_grep_cWORD={"fzf-lua.providers.tags","grep_cWORD"},tags_grep_visual={"fzf-lua.providers.tags","grep_visual"},tags_live_grep={"fzf-lua.providers.tags","live_grep"},git_files={"fzf-lua.providers.git","files"},git_status={"fzf-lua.providers.git","status"},git_stash={"fzf-lua.providers.git","stash"},git_commits={"fzf-lua.providers.git","commits"},git_bcommits={"fzf-lua.providers.git","bcommits"},git_branches={"fzf-lua.providers.git","branches"},oldfiles={"fzf-lua.providers.oldfiles","oldfiles"},quickfix={"fzf-lua.providers.quickfix","quickfix"},quickfix_stack={"fzf-lua.providers.quickfix","quickfix_stack"},loclist={"fzf-lua.providers.quickfix","loclist"},loclist_stack={"fzf-lua.providers.quickfix","loclist_stack"},buffers={"fzf-lua.providers.buffers","buffers"},tabs={"fzf-lua.providers.buffers","tabs"},lines={"fzf-lua.providers.buffers","lines"},blines={"fzf-lua.providers.buffers","blines"},help_tags={"fzf-lua.providers.helptags","helptags"},man_pages={"fzf-lua.providers.manpages","manpages"},colorschemes={"fzf-lua.providers.colorschemes","colorschemes"},highlights={"fzf-lua.providers.colorschemes","highlights"},jumps={"fzf-lua.providers.nvim","jumps"},changes={"fzf-lua.providers.nvim","changes"},tagstack={"fzf-lua.providers.nvim","tagstack"},marks={"fzf-lua.providers.nvim","marks"},menus={"fzf-lua.providers.nvim","menus"},keymaps={"fzf-lua.providers.nvim","keymaps"},autocmds={"fzf-lua.providers.nvim","autocmds"},registers={"fzf-lua.providers.nvim","registers"},commands={"fzf-lua.providers.nvim","commands"},command_history={"fzf-lua.providers.nvim","command_history"},search_history={"fzf-lua.providers.nvim","search_history"},spell_suggest={"fzf-lua.providers.nvim","spell_suggest"},filetypes={"fzf-lua.providers.nvim","filetypes"},packadd={"fzf-lua.providers.nvim","packadd"},lsp_finder={"fzf-lua.providers.lsp","finder"},lsp_typedefs={"fzf-lua.providers.lsp","typedefs"},lsp_references={"fzf-lua.providers.lsp","references"},lsp_definitions={"fzf-lua.providers.lsp","definitions"},lsp_declarations={"fzf-lua.providers.lsp","declarations"},lsp_implementations={"fzf-lua.providers.lsp","implementations"},lsp_document_symbols={"fzf-lua.providers.lsp","document_symbols"},lsp_workspace_symbols={"fzf-lua.providers.lsp","workspace_symbols"},lsp_live_workspace_symbols={"fzf-lua.providers.lsp","live_workspace_symbols"},lsp_code_actions={"fzf-lua.providers.lsp","code_actions"},lsp_incoming_calls={"fzf-lua.providers.lsp","incoming_calls"},lsp_outgoing_calls={"fzf-lua.providers.lsp","outgoing_calls"},lsp_document_diagnostics={"fzf-lua.providers.diagnostic","diagnostics"},lsp_workspace_diagnostics={"fzf-lua.providers.diagnostic","all"},diagnostics_document={"fzf-lua.providers.diagnostic","diagnostics"},diagnostics_workspace={"fzf-lua.providers.diagnostic","all"},dap_commands={"fzf-lua.providers.dap","commands"},dap_configurations={"fzf-lua.providers.dap","configurations"},dap_breakpoints={"fzf-lua.providers.dap","breakpoints"},dap_variables={"fzf-lua.providers.dap","variables"},dap_frames={"fzf-lua.providers.dap","frames"},register_ui_select={"fzf-lua.providers.ui_select","register"},deregister_ui_select={"fzf-lua.providers.ui_select","deregister"},tmux_buffers={"fzf-lua.providers.tmux","buffers"},profiles={"fzf-lua.providers.module","profiles"},fzf={"fzf-lua.core","fzf"},fzf_raw={"fzf-lua.fzf","raw_fzf"},fzf_wrap={"fzf-lua.core","fzf_wrap"},fzf_exec={"fzf-lua.core","fzf_exec"},fzf_live={"fzf-lua.core","fzf_live"},fzf_complete={"fzf-lua.complete","fzf_complete"},complete_path={"fzf-lua.complete","path"},complete_file={"fzf-lua.complete","file"},complete_line={"fzf-lua.complete","line"},complete_bline={"fzf-lua.complete","bline"}}for t,i in pairs(y)do f[t]=function(...)f[t]=function(...)f.set_info{cmd=t,mod=i[1],fnc=i[2]}return require(i[1])[i[2]](...)end;return f[t](...)end end end;f.get_info=function(z)if z and z.winobj and type(f.__INFO)=="table"then f.__INFO.winobj=b.fzf_winobj()end;return f.__INFO end;f.set_info=function(A)f.__INFO=A end;f.get_last_query=function()return f.config.__resume_data and f.config.__resume_data.last_query end;f.set_last_query=function(B)f.config.__resume_data=f.config.__resume_data or{}f.config.__resume_data.last_query=B end;f._exported_modules={"win","core","path","utils","libuv","shell","config","actions","make_entry"}f._excluded_meta={"load_profile","setup","fzf","fzf_raw","fzf_wrap","fzf_exec","fzf_live","fzf_complete","complete_path","complete_file","complete_line","complete_bline","defaults","_excluded_meta","_excluded_metamap","_exported_modules","__INFO","get_info","set_info","get_last_query","set_last_query"}for k,C in ipairs(f._exported_modules)do f[C]=require("fzf-lua."..C)end;f._excluded_metamap={}for k,u in pairs({f._excluded_meta,f._exported_modules})do for k,C in ipairs(u)do f._excluded_metamap[C]=true end end;f.builtin=function(p)if not p then p={}end;p.metatable=f;p.metatable_exclude=f._excluded_metamap;return require"fzf-lua.providers.module".metatable(p)end;return f