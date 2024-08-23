local a={}local b=require("multiple-cursors.common")function a.new(c,d,e,f,g,h)local self=setmetatable({},a)self.lnum=c;self.col=d;self.curswant=e;self.seq=h;self.visual_start_lnum=f;self.visual_start_col=g;self.mark_id=0;self.visual_start_mark_id=0;self.visual_multiline_mark_id=0;self.visual_empty_line_mark_ids={}self.editable=true;self.delete=false;self.registers={}return self end;a.__index=function(self,i)return a[i]end;a.__eq=function(j,k)return j.lnum==k.lnum and j.col==k.col end;function a:is_visual_area_valid()if self.visual_start_lnum==0 or self.visual_start_col==0 then return false end;if self.visual_start_lnum>vim.fn.line("$")then return false end;return true end;function a:is_visual_area_forward()if self.visual_start_lnum==self.lnum then return self.visual_start_col<=self.col else return self.visual_start_lnum<=self.lnum end end;function a:get_normalised_visual_area(l)l=l or false;local m=self.visual_start_lnum;local n=self.visual_start_col;local o=self.lnum;local p=self.col;if not self:is_visual_area_forward()then m=self.lnum;n=self.col;o=self.visual_start_lnum;p=self.visual_start_col;if l then p=vim.fn.min({p+1,b.get_max_col(o)})end end;return m,n,o,p end;a.__lt=function(j,k)if not j:is_visual_area_valid()or not k:is_visual_area_valid()then if j.lnum==k.lnum then return j.col<k.col else return j.lnum<k.lnum end else local q,r=j:get_normalised_visual_area()local s,t=k:get_normalised_visual_area()if q==s then return r<t else return q<s end end end;function a:save_cursor_position()local u=vim.fn.getcurpos()self.lnum=u[2]self.col=u[3]self.curswant=u[5]end;function a:set_cursor_position()vim.fn.cursor({self.lnum,self.col,0,self.curswant})end;function a:save_visual_area()local v=vim.fn.getpos("v")self.visual_start_lnum=v[2]self.visual_start_col=v[3]self:save_cursor_position()end;function a:set_visual_area()b.set_visual_area(self.visual_start_lnum,self.visual_start_col,self.lnum,self.col)end;function a:save_register(w)local x=vim.fn.getreginfo(w)self.registers[w]=x;return#x.regcontents end;function a:has_register(w)return self.registers[w]~=nil end;function a:set_register(w)local x=self.registers[w]if x then vim.fn.setreg(w,x)end end;return a