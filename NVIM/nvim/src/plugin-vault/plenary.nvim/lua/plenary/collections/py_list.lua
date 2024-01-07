local a={}function a.new(b)if type(b)=="table"then local c=#b;local d=setmetatable(b,a)d._len=c;return d end;error"List constructor must be called with table argument"end;function a.is_list(b)local e=getmetatable(b)or{}return e==a end;function a:__index(f)if self~=a then local g=a[f]if g then return g end end end;function a:__tostring()local h=self:join", "return"["..h.."]"end;function a:__eq(i)if#self~=#i then return false end;for j=1,#self do if self[j]~=i[j]then return false end end;return true end;function a:__mul(i)local k=a.new{}for j=1,i do k[j]=self end;return k end;function a:__len()return self._len end;function a:__concat(i)return self:concat(i)end;function a:push(i)self[#self+1]=i;self._len=self._len+1 end;function a:pop()local k=table.remove(self)self._len=self._len-1;return k end;function a:insert(l,i)table.insert(self,l,i)self._len=self._len+1 end;function a:remove(l)self._len=self._len-1;return table.remove(self,l)end;function a:equal(i)return self:__eq(i)end;function a:deep_equal(i)return vim.deep_equal(self,i)end;function a:slice(m,n)return a.new(vim.list_slice(self,m,n))end;function a:copy()return self:slice(1,#self)end;function a:deep_copy()return vim.deep_copy(self)end;function a:reverse()local o=#self;local j=1;while j<o do self[j],self[o]=self[o],self[j]j=j+1;o=o-1 end;return self end;function a:join(p)p=p or""local k=""for j,q in self:iter()do k=k..tostring(q)if j~=#self then k=k..p end end;return k end;function a:concat(...)local k=self:copy()local r={...}for s,i in ipairs(r)do for s,q in ipairs(i)do k:push(q)end end;return k end;function a:move(t,c,u,i)return table.move(self,t,c,u,i)end;function a.pack(...)return a.new{...}end;function a:unpack()return unpack(self,1,#self)end;local v=require"plenary.iterators"local w=getmetatable(v:wrap())local function x(y,z)z=z+1;local q=y[z]if q~=nil then return z,q end end;local function A(y,z)z=z-1;local q=y[z]if q~=nil then return z,q end end;local function B(self,C)local D,E=a.new{},a.new{}for s,q in self do if C(q)then D:push(q)else E:push(q)end end;return D,E end;local function F(G,H,o)local I=v.wrap(G,H,o)I.partition=B;return I end;function a:count(J)local K=0;for s,q in self:iter()do if J==q then K=K+1 end end;return K end;function a:extend(i)if type(i)=="table"and getmetatable(i)==w then for s,q in i do self:push(q)end else error"Argument must be an iterator"end end;function a:contains(J)for s,q in self:iter()do if q==J then return true end end;return false end;function a:iter()return F(x,self,0)end;function a:riter()return F(A,self,#self+1)end;function a.from_iter(I)local k=a.new{}for s,q in I do k:push(q)end;return k end;return setmetatable({},{__call=function(s,b)return a.new(b)end,__index=a})