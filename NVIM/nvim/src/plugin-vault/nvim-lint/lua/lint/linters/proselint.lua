local a='([^:]+):(%d+):(%d+): ([^ ]+) (.*)'local b={'file','lnum','col','code','message'}return{cmd='proselint',stdin=false,args={},ignore_exitcode=true,parser=require('lint.parser').from_pattern(a,b,nil,{['source']='proselint',['severity']=vim.diagnostic.severity.INFO})}