_=[[
exec nvim -l "$0" "$@"
]]local a=vim.inspect;local b=vim.list_extend;local c=vim.startswith;local d=require('lua.gitsigns.config')local function e(f)local g=assert(io.open(f,'r'))local h=g:read('*all')g:close()return h end;local function i()local j=e('lua/gitsigns/config.lua'):gmatch('[^\n\r]+')for k in j do if c(k,'M.schema = {')then break end end;local l={}for k in j do if c(k,'}')then break end;if k:find('^  (%w+).*')then local m=k:gsub('^%s*([%w_]+).*','%1')table.insert(l,m)end end;return l end;local function n(o,p)if type(o)=='table'and o.hard then p('   HARD-DEPRECATED')else p('   DEPRECATED')end;if type(o)=='table'then if o.message then p('      '..o.message)end;if o.new_field then p('')local q,r=o.new_field:match('(.*)%.(.*)')if q and r then p(('   Please instead use the field `%s` in |gitsigns-config-%s|.'):format(r,q))else p(('   Please instead use |gitsigns-config-%s|.'):format(o.new_field))end end end;p('')end;local function s(r,p)local t=d.schema[r]local h=('*gitsigns-config-%s*'):format(r)if#r+#h<80 then p(('%-29s %48s'):format(r,h))else p(('%-29s'):format(r))p(('%78s'):format(h))end;local u=t.deprecated;if u then n(u,p)end;if t.description then local v;if t.default_help~=nil then v=t.default_help else v=a(t.default):gsub('\n','\n    ')v=('`%s`'):format(v)end;local w=(function()if t.type=='table'and t.deep_extend then return'table[extended]'end;local x=t.type;if type(x)=='table'then t.type=table.concat(x,'|')end;return t.type end)()if v:find('\n')then p(('      Type: `%s`'):format(w))p('      Default: >')p('        '..v:gsub('\n([^\n\r])','\n    %1'))p('<')else p(('      Type: `%s`, Default: %s'):format(w,v))p()end;p(t.description:gsub(' +$',''))end end;local function y()local z={}local function p(A)z[#z+1]=A or''end;for _,B in ipairs(i())do s(B,p)end;return table.concat(z,'\n')end;local function C(A)local D=A:match('^%w+%.([%w_]+) =')or A:match('^function %w+%.([%w_]+)%(')if not D then error('Unable to parse: '..A)end;local E=A:match('function%((.*)%)')or A:match('function%s+%w+%.[%w_]+%((.*)%)')local F={}for B in string.gmatch(E,'([%w_]+)')do if B:sub(1,1)~='_'then F[#F+1]=string.format('{%s}',B)end end;return string.format('%-40s%38s',string.format('%s(%s)',D,table.concat(F,', ')),'*gitsigns.'..D..'()*')end;local function G(H)local I,x,J=H:match('([^ ]+) +([^ ]+) *(.*)')return I,x,J end;local function K(H)local L;for _,M in ipairs(H)do local _,N=M:find('^ *')if not L or L>N then L=N end end;local O={}for _,M in ipairs(H)do O[#O+1]=M:sub(L+1)end;return O end;local function P(I,x,Q,R)x=x:gsub('Gitsigns%.%w+','table')R=R and R+3 or 0;local S;if I==':'then S=''else local T='%-'..tostring(R)..'s'S=T:format(string.format('{%s} ',I))end;if#Q==0 then return{string.format('    %s(%s)',S,x)}end;local O={}local U=Q[1]==''and''or' '..Q[1]O[#O+1]=string.format('    %s(%s):%s',S,x,U)local V=K(vim.list_slice(Q,2))for _,v in ipairs(V)do O[#O+1]='    '..string.rep(' ',R)..v end;return O end;local function W(H,X)local Y=string.rep(' ',X)local O={}for _,M in ipairs(H)do O[#O+1]=Y..M end;return O end;local function Z(a0,a1,Q,a2,a3)if a0=='none'then a0='in_block'end;local a4,a5=a1:match(' ?@([a-z]+) (.*)')if a4=='param'then local I,x,a6=G(a5)a2[#a2+1]={I,x,{a6}}return'in_param'end;if a4=='return'then local x,I,a7=G(a5)a3[#a3+1]={I,x,{a7}}return'in_return'end;if a0=='in_param'then local a8=a2[#a2][3]a8[#a8+1]=a1 elseif a0=='in_return'then local a8=a3[#a3][3]a8[#a8+1]=a1 else if a1~=''and a1~='<'then a1=string.rep(' ',16)..a1 end;Q[#Q+1]=a1 end;return a0 end;local function a9(aa,ab,a2,a3)if vim.startswith(aa,'_')then return end;local z={aa}b(z,ab)a2=vim.tbl_filter(function(t)return not c(t[1],'_')end,a2)if#a2>0 then local ac={'Parameters: ~'}local R=0;for _,t in ipairs(a2)do if#t[1]>R then R=#t[1]end end;for _,t in ipairs(a2)do local I,x,Q=t[1],t[2],t[3]b(ac,P(I,x,Q,R))end;b(z,W(ac,16))end;if#a3>0 then z[#z+1]=''local ac={'Returns: ~'}for _,t in ipairs(a3)do local I,x,Q=t[1],t[2],t[3]b(ac,P(I,x,Q))end;b(z,W(ac,16))end;return z end;local function ad(f)local N=e(f):gmatch('([^\n]*)\n?')local ae={}local a0='none'local Q={}local a2={}local a3={}for k in N do local a1=k:match('^%-%-%- ?(.*)')if a1 then a0=Z(a0,a1,Q,a2,a3)elseif a0~='none'then local af,aa=pcall(C,k)if af then ae[#ae+1]=a9(aa,Q,a2,a3)end;a0='none'Q={}a2={}a3={}end end;local z={}for ag=#ae,1,-1 do local ah=ae[ag]for B=1,#ah do z[#z+1]=ah[B]:match('^ *$')and''or ah[B]end;z[#z+1]=''end;return table.concat(z,'\n')end;local function ai(aj)local z={}for _,f in ipairs(aj)do z[#z+1]=ad(f)end;return table.concat(z,'\n')end;local function ak()local z={}local al=require('lua.gitsigns.highlight')local am=0;for _,an in ipairs(al.hls)do for I,_ in pairs(an)do if I:len()>am then am=I:len()end end end;for _,an in ipairs(al.hls)do for I,ao in pairs(an)do if not ao.hidden then local ap={}for _,g in ipairs(ao)do ap[#ap+1]=string.format('`%s`',g)end;local aq=table.concat(ap,', ')z[#z+1]=string.format('%s*hl-%s*',string.rep(' ',56),I)z[#z+1]=string.format('%s',I)if ao.desc then z[#z+1]=string.format('%s%s',string.rep(' ',8),ao.desc)z[#z+1]=''end;z[#z+1]=string.format('%sFallbacks: %s',string.rep(' ',8),aq)end end end;return table.concat(z,'\n')end;local function ar()local as=e('README.md'):gmatch('([^\n]*)\n?')local z={}local function at(A)z[#z+1]=A~=''and'    '..A or''end;for k in as do if k:match("require%('gitsigns'%).setup {")then at(k)break end end;for k in as do at(k)if k=='}'then break end end;return table.concat(z,'\n')end;local function au(av)return({VERSION='0.7-dev',CONFIG=y,FUNCTIONS=function()return ai({'lua/gitsigns.lua','lua/gitsigns/attach.lua','lua/gitsigns/actions.lua'})end,HIGHLIGHTS=ak,SETUP=ar})[av]end;local function aw()local ax=e('etc/doc_template.txt'):gmatch('([^\n]*)\n?')local p=assert(io.open('doc/gitsigns.txt','w'))for k in ax do local av=k:match('{{(.*)}}')if av then local ay=au(av)if ay then if type(ay)=='function'then ay=ay()end;ay=ay:gsub('%%','%%%%')k=k:gsub('{{'..av..'}}',ay)end end;p:write(k or'','\n')end end;aw()