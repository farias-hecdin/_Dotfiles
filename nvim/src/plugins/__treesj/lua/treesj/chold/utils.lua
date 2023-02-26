local a=require('treesj.utils')local b={}local c='split'function b.get_cursor()local d=vim.api.nvim_win_get_cursor(0)return{row=d[1]-1,col=d[2]}end;function b.is_not_need_change(e,f)local g=a.readable_range(f:root():child(1):range())return e.pos.row==g.row.start and e.pos.col<=g.col.end_ end;function b.is_after_node(e,f)local g=a.readable_range(f:root():range())return e.pos.row==g.row.end_ and e.pos.col>=g.col.end_ end;function b.in_node_range(e,f)local g=a.readable_range(f:o_range())local h=false;if g.row.start<=e.pos.row and e.pos.row<=g.row.end_ then if e.pos.row==g.row.end_ then h=e.pos.col<g.col.end_ elseif e.pos.row==g.row.start then h=e.pos.col>=g.col.start else h=true end end;return h end;function b.pos_in_node(e,f,i)local g=a.readable_range(f:range())local j=e.pos.col-g.col.start;local k=f:parent():preset(i)local l=k and k.space_separator or 0;if i==c then local m=-a.calc_indent(f)j=j>=m and j or m else local n=-l;j=j>=n and j or n end;return j end;function b.new_col_pos(e,f,i)local j=b.pos_in_node(e,f,i)local o=i==c and f:is_omit()local p=o and#f:prev():text()or 0;local q=i==c and a.calc_indent(f)or#a.get_whitespace(f)return p+q+j end;function b.increase_row(e,f)local r=not(f:is_omit()or f:is_first())if r then local s=f:text()local t=1;if type(s)=='table'then if b.in_node_range(e,f)then local j=b.new_col_pos(e,f,'split')local u=0;local v=0;while j>u do v=v+1;u=u+#s[v]end;t=v else t=#vim.tbl_flatten(s)end end;e:_update_pos({row=e._new_pos.row+t})end end;return b
