local a={}function a.new(b,c,d)local self=setmetatable({},a)self.lnum=b;self.col=c;self.curswant=d;self.visual_start_lnum=0;self.visual_start_col=0;self.mark_id=0;self.visual_start_mark_id=0;self.visual_multiline_mark_id=0;self.visual_empty_line_mark_ids={}self.within_buffer=true;self.editable=true;self.delete=false;self.registers={}return self end;a.__index=function(self,e)return a[e]end;a.__eq=function(f,g)return f.lnum==g.lnum and f.col==g.col end;function a:is_visual_area_valid()if self.visual_start_lnum==0 or self.visual_start_col==0 then return false end;if self.visual_start_lnum>vim.fn.line("$")then return false end;return true end;function a:is_visual_area_forward()if self.visual_start_lnum==self.lnum then return self.visual_start_col<=self.col else return self.visual_start_lnum<=self.lnum end end;function a:get_normalised_visual_area()local h=self.visual_start_lnum;local i=self.visual_start_col;local j=self.lnum;local k=self.col;if not self:is_visual_area_forward()then h=self.lnum;i=self.col;j=self.visual_start_lnum;k=self.visual_start_col end;return h,i,j,k end;a.__lt=function(f,g)if not f:is_visual_area_valid()or not g:is_visual_area_valid()then if f.lnum==g.lnum then return f.col<g.col else return f.lnum<g.lnum end else local l,m=f:get_normalised_visual_area()local n,o=g:get_normalised_visual_area()if l==n then return m<o else return l<n end end end;function a:save_cursor_position()local p=vim.fn.getcurpos()self.lnum=p[2]self.col=p[3]self.curswant=p[5]end;function a:set_cursor_position()vim.fn.cursor({self.lnum,self.col,0,self.curswant})end;function a:save_visual_area()local q=vim.fn.getpos("v")self.visual_start_lnum=q[2]self.visual_start_col=q[3]self:save_cursor_position()end;function a:set_visual_area()vim.cmd("normal!:")vim.api.nvim_buf_set_mark(0,"<",self.visual_start_lnum,self.visual_start_col-1,{})vim.api.nvim_buf_set_mark(0,">",self.lnum,self.col-1,{})vim.cmd("normal! gv")end;function a:save_register(r)local s=vim.fn.getreginfo(r)self.registers[r]=s;return#s.regcontents end;function a:has_register(r)return self.registers[r]~=nil end;function a:set_register(r)local s=self.registers[r]if s then vim.fn.setreg(r,s)end end;return a