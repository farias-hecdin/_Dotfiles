local a={}a.__index=a;a.elements={}function a:push(b)table.insert(self.elements,self:length()+1,b)end;function a:length()return#self.elements end;function a:pop()if self:is_empty()then return nil end;local b=self.elements[self:length()]table.remove(self.elements,self:length())return b end;function a:new(c,d)d=d or{}d.elements=c or{}return setmetatable(d,self)end;function a:is_empty()return self:length()==0 end;function a:peek()return self.elements[self:length()]end;return a
