local a=vim.api;local b=require"bit"local c,d,e=math.floor,math.min,math.max;local f,g,h,i=b.band,b.rshift,b.lshift,b.tohex;local j=require"colorizer.trie"local k=require"colorizer.utils"local l=k.byte_is_alphanumeric;local m=k.byte_is_hex;local n=k.byte_is_valid_colorchar;local o=k.parse_hex;local p=k.percent_or_hex;local q={}local r=#"0xAARRGGBB"-1;function q.argb_hex_parser(s,t)if#s<t+r then return end;local u=t+2;local v=u+8;local w;local x=0;while u<=d(v,#s)do local y=s:byte(u)if not m(y)then break end;if u-t<=3 then w=o(y)+h(w or 0,4)else x=o(y)+h(x,4)end;u=u+1 end;if#s>=u and l(s:byte(u))then return end;local z=u-t;if z~=10 then return end;w=tonumber(w)/255;local A=c(f(g(x,16),0xFF)*w)local B=c(f(g(x,8),0xFF)*w)local y=c(f(x,0xFF)*w)local C=string.format("%02x%02x%02x",A,B,y)return z,C end;function q.hsl_to_rgb(D,E,F)if D>1 or E>1 or F>1 then return end;if E==0 then local A=F*255;return A,A,A end;local G;if F<0.5 then G=F*(1+E)else G=F+E-F*E end;local H=2*F-G;return 255*q.hue_to_rgb(H,G,D+1/3),255*q.hue_to_rgb(H,G,D),255*q.hue_to_rgb(H,G,D-1/3)end;local I=#"hsl(0,0%,0%)"-1;function q.hsl_function_parser(s,t)if#s<t+I then return end;local D,E,F,J=s:sub(t):match"^hsl%(%s*(%d+)%s*,%s*(%d+)%%%s*,%s*(%d+)%%%s*%)()"if not J then D,E,F,J=s:sub(t):match"^hsl%(%s*(%d+)%s+(%d+)%%%s+(%d+)%%%s*%)()"if not J then return end end;D=tonumber(D)if D>360 then return end;E=tonumber(E)if E>100 then return end;F=tonumber(F)if F>100 then return end;local A,B,y=q.hsl_to_rgb(D/360,E/100,F/100)if A==nil or B==nil or y==nil then return end;local C=string.format("%02x%02x%02x",A,B,y)return J-1,C end;local K=#"hsla(0,0%,0%,0)"-1;function q.hsla_function_parser(s,t)if#s<t+K then return end;local D,E,F,L,J=s:sub(t):match"^hsla%(%s*(%d+)%s*,%s*(%d+)%%%s*,%s*(%d+)%%%s*,%s*([.%d]+)%s*%)()"if not J then D,E,F,L,J=s:sub(t):match"^hsla%(%s*(%d+)%s+(%d+)%%%s+(%d+)%%%s+([.%d]+)%s*%)()"if not J then return end end;L=tonumber(L)if not L or L>1 then return end;D=tonumber(D)if D>360 then return end;E=tonumber(E)if E>100 then return end;F=tonumber(F)if F>100 then return end;local A,B,y=q.hsl_to_rgb(D/360,E/100,F/100)if A==nil or B==nil or y==nil then return end;local C=string.format("%02x%02x%02x",A*L,B*L,y*L)return J-1,C end;function q.hue_to_rgb(H,G,M)if M<0 then M=M+1 end;if M>1 then M=M-1 end;if M<1/6 then return H+(G-H)*6*M end;if M<1/2 then return G end;if M<2/3 then return H+(G-H)*(2/3-M)*6 end;return H end;function q.is_bright(A,B,y)local N=(0.299*A+0.587*B+0.114*y)/255;if N>0.5 then return true else return false end end;local O;local P;local Q,R;local S={lowercase=true,strip_digits=false}local T=false;function q.name_parser(s,t,U)if not P or U.tailwind~=T then O={}P=j()for V,x in pairs(a.nvim_get_color_map())do if not(S.strip_digits and V:match"%d+$")then Q=Q and d(#V,Q)or#V;R=R and e(#V,R)or#V;local C=i(x,6)O[V]=C;P:insert(V)if S.lowercase then local W=V:lower()O[W]=C;P:insert(W)end end end;if U and U.tailwind then if U.tailwind==true or U.tailwind=="normal"or U.tailwind=="both"then local X=require"colorizer.tailwind_colors"for V,x in pairs(X.colors)do for Y,Z in ipairs(X.prefixes)do local _=Z.."-"..V;Q=Q and d(#_,Q)or#_;R=R and e(#_,R)or#_;O[_]=x;P:insert(_)end end end end;T=U.tailwind end;if#s<t+Q-1 then return end;if t>1 and n(s:byte(t-1))then return end;local a0=P:longest_prefix(s,t)if a0 then local a1=t+#a0;if#s>=a1 and n(s:byte(a1))then return end;return#a0,O[a0]end end;local a2=#"rgb(0,0,0)"-1;function q.rgb_function_parser(s,t)if#s<t+a2 then return end;local A,B,y,J=s:sub(t):match"^rgb%(%s*(%d+%%?)%s*,%s*(%d+%%?)%s*,%s*(%d+%%?)%s*%)()"if not J then A,B,y,J=s:sub(t):match"^rgb%(%s*(%d+%%?)%s+(%d+%%?)%s+(%d+%%?)%s*%)()"if not J then return end end;A=p(A)if not A then return end;B=p(B)if not B then return end;y=p(y)if not y then return end;local C=string.format("%02x%02x%02x",A,B,y)return J-1,C end;local a3=#"rgba(0,0,0,0)"-1;function q.rgba_function_parser(s,t)if#s<t+a3 then return end;local A,B,y,L,J=s:sub(t):match"^rgba%(%s*(%d+%%?)%s*,%s*(%d+%%?)%s*,%s*(%d+%%?)%s*,%s*([.%d]+)%s*%)()"if not J then A,B,y,L,J=s:sub(t):match"^rgba%(%s*(%d+%%?)%s+(%d+%%?)%s+(%d+%%?)%s+([.%d]+)%s*%)()"if not J then return end end;L=tonumber(L)if not L or L>1 then return end;A=p(A)if not A then return end;B=p(B)if not B then return end;y=p(y)if not y then return end;local C=string.format("%02x%02x%02x",A*L,B*L,y*L)return J-1,C end;function q.rgba_hex_parser(s,t,U)local a4,a5,a6=U.minlen,U.maxlen,U.valid_lengths;local u=t+1;if#s<u+a4-1 then return end;if t>1 and l(s:byte(t-1))then return end;local v=u+a5;local w;local x=0;while u<=d(v,#s)do local y=s:byte(u)if not m(y)then break end;if u-t>=7 then w=o(y)+h(w or 0,4)else x=o(y)+h(x,4)end;u=u+1 end;if#s>=u and l(s:byte(u))then return end;local z=u-t;if z~=4 and z~=7 and z~=9 then return end;if w then w=tonumber(w)/255;local A=c(f(g(x,16),0xFF)*w)local B=c(f(g(x,8),0xFF)*w)local y=c(f(x,0xFF)*w)local C=string.format("%02x%02x%02x",A,B,y)return 9,C end;return a6[z-1]and z,s:sub(t+1,t+z-1)end;return q
