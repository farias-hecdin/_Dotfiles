local a=require"plenary.async_lib.async"local b=require"plenary.async_lib.util"local c={}c.describe=function(d,e)describe(d,b.will_block(a.future(e)))end;c.it=function(d,e)it(d,b.will_block(a.future(e)))end;return c