local a='[%t] %. %f:%l:%c %m, [%t] %. %f:%l %m'return{cmd='mix',stdin=true,args={'credo','list','--format=oneline','--read-from-stdin','--strict'},stream='stdout',ignore_exitcode=true,parser=require('lint.parser').from_errorformat(a,{['source']='credo'})}