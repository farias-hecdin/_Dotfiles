local a=require"fzf-lua.core"local b=require"fzf-lua.shell"local c=require"fzf-lua.utils"local d=require"fzf-lua.config"local e={}e.buffers=function(f)f=d.normalize_opts(f,d.globals.tmux.buffers)if not f then return end;f.fn_transform=function(g)local h,i=g:match([[^(.-):%s+%d+%s+bytes: "(.*)"$]])return string.format("[%s] %s",c.ansi_codes.yellow(h),i)end;f.fzf_opts["--no-multi"]=""f.fzf_opts["--delimiter"]="'[:]'"f.fzf_opts["--preview"]=b.preview_action_cmd(function(j)local h=j[1]:match("^%[(.-)%]")return string.format("tmux show-buffer -b %s",h)end,f.debug)a.fzf_exec(f.cmd,f)end;return e
