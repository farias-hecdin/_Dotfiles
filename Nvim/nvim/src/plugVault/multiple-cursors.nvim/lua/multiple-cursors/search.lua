local a={}local b=require("multiple-cursors.virtual_cursors")local function c(d,e)local f={}for g=e+1,#d do table.insert(f,d[g])end;for g=1,e-1 do table.insert(f,d[g])end;return f end;local function h(i)if i==0 then vim.fn.cursor({1,1,0,1})return nil elseif i==1 then local j=vim.fn.line("w0")vim.fn.cursor({j,1,0,1})return nil else local k=vim.api.nvim_buf_get_mark(0,"<")local l=vim.api.nvim_buf_get_mark(0,">")if k[1]==0 or l[1]==0 then vim.print("No previous visual area")return end;vim.fn.cursor({k[1],k[2]+1,0,k[2]+1})return l end end;local function m(i,l,n)if i==0 then return false end;if i==1 then if n[1]>vim.fn.line("w$")then return true end else if n[1]>l[1]or n[1]==l[1]and n[2]>l[2]+1 then return true end end;return false end;function a.get_matches_and_move_cursor(o,p,q)local i=0;if q then i=2 elseif p then i=1 end;local r=vim.fn.getcurpos()b.set_ignore_cursor_movement(true)local l=h(i)if q and not l then b.set_ignore_cursor_movement(false)return nil end;local d={}local s=true;local t=vim.fn.line("w$")local u=vim.o.ignorecase;vim.o.ignorecase=false;while true do local n={0,0}if s then n=vim.fn.searchpos(o,"cW")s=false else n=vim.fn.searchpos(o,"W")end;if n[1]==0 or n[2]==0 then break end;if m(i,l,n)then break end;table.insert(d,n)end;vim.o.ignorecase=u;if#d<=1 then vim.fn.cursor({r[2],r[3],r[4],r[5]})b.set_ignore_cursor_movement(false)vim.print("No matches found")return nil end;for g,n in ipairs(d)do if n[1]==r[2]then if r[3]>=n[2]and r[3]<n[2]+#o or r[3]<n[2]then vim.fn.cursor({n[1],n[2],0,n[2]})d=c(d,g)break end end end;b.set_ignore_cursor_movement(false)return d end;function a.get_next_match(o,v)local u=vim.o.ignorecase;vim.o.ignorecase=false;local n=vim.fn.searchpos(o,"nw")if n[1]==0 or n[2]==0 then vim.o.ignorecase=u;return nil end;if v then vim.fn.searchpos(o,"bc")end;vim.o.ignorecase=u;b.set_ignore_cursor_movement(false)return n end;return a