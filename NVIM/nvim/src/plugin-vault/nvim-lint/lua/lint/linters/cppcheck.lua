local a=[[([^:]*):(%d*):([^:]*): %[([^%]\]*)%] ([^:]*): (.*)]]local b={"file","lnum","col","code","severity","message"}local c={["error"]=vim.diagnostic.severity.ERROR,["warning"]=vim.diagnostic.severity.WARN,["performance"]=vim.diagnostic.severity.WARN,["style"]=vim.diagnostic.severity.INFO,["information"]=vim.diagnostic.severity.INFO}return{cmd="cppcheck",stdin=false,args={"--enable=warning,style,performance,information",function()if vim.bo.filetype=="cpp"then return"--language=c++"else return"--language=c"end end,"--inline-suppr","--quiet","--cppcheck-build-dir=build","--template={file}:{line}:{column}: [{id}] {severity}: {message}"},stream="stderr",parser=require("lint.parser").from_pattern(a,b,c,{["source"]="cppcheck"})}