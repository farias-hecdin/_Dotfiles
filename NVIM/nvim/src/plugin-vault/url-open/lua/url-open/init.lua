local a={}local b=require("url-open.modules.commands")local c=require("url-open.modules.options")local d=require("url-open.modules.autocmd")a.setup=function(e)local f=c.apply_user_options(e)b.setup(f)d.setup(f)end;return a
