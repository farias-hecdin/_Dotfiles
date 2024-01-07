local a=require"plenary.benchmark.stat"local b=function(c)local d={}d.max,d.min=a.maxmin(c)d.mean=a.mean(c)d.median=a.median(c)d.std=a.std_dev(c)return d end;local e=function(f,g,h)local i={"ns","μs","ms"}local j=function(k)k=math.floor(k)local l=0;repeat k=math.floor(k/10)l=l+1 until k<=0;return l end;local m=function(k)for n,o in ipairs(i)do if math.abs(k)<1000.0 then return string.format("%s%3.1f %s",string.rep(" ",3-j(k)),k,o)end;k=k/1000.0 end;return string.format("%.1f %s",k,"s")end;return string.format("Benchmark #%d: '%s'\n  Time(mean ± σ):    %s ± %s\n  Range(min … max):  %s … %s  %d runs\n",f,g.name,m(g.stats.mean),m(g.stats.std),m(g.stats.min),m(g.stats.max),h)end;local p=function(g)if#g==1 then return""end;local q=math.huge;local r=1;for s,t in ipairs(g)do if t.stats.mean<q then q=t.stats.mean;r=s end end;if q==math.huge then return""end;local u={}local v=g[r].stats;for s,t in ipairs(g)do if s~=r then local w=t.stats;local x=w.mean/v.mean;local y=x*math.sqrt(math.pow(w.std/w.mean,2)+math.pow(v.std/v.mean,2))table.insert(u,string.format("  %.1f ± %.1f times faster than '%s'\n",x,y,t.name))end end;return string.format("Summary\n  '%s' ran\n%s",g[r].name,table.concat(u,""))end;local z=function(A,B)vim.validate{opts={B,"table"},fun={B.fun,"table"}}B.warmup=vim.F.if_nil(B.warmup,3)B.runs=vim.F.if_nil(B.runs,5)B.fun=type(B.fun)=="function"and{B.fun}or B.fun;local u={string.format("Benchmark Group: '%s' -----------------------\n",A)}local g={}for s,C in ipairs(B.fun)do g[s]={name=C[1],results={}}for n=1,B.warmup do C[2]()end;for D=1,B.runs do local E=vim.loop.hrtime()C[2]()g[s].results[D]=vim.loop.hrtime()-E end;g[s].stats=b(g[s].results)table.insert(u,e(s,g[s],B.runs))end;print(string.format("%s\n%s",table.concat(u,""),p(g)))return g end;return z