local a=require('cmp.utils.spec')local b=require('cmp.types.lsp')describe('types.lsp',function()before_each(a.before)describe('Position',function()vim.fn.setline('1',{'あいうえお','かきくけこ','さしすせそ'})local c,d;local e=vim.api.nvim_get_current_buf()c=b.Position.to_vim(e,{line=1,character=3})assert.are.equal(c.row,2)assert.are.equal(c.col,10)d=b.Position.to_lsp(e,c)assert.are.equal(d.line,1)assert.are.equal(d.character,3)c=b.Position.to_vim(e,{line=1,character=0})assert.are.equal(c.row,2)assert.are.equal(c.col,1)d=b.Position.to_lsp(e,c)assert.are.equal(d.line,1)assert.are.equal(d.character,0)c=b.Position.to_vim(e,{line=1,character=5})assert.are.equal(c.row,2)assert.are.equal(c.col,16)d=b.Position.to_lsp(e,c)assert.are.equal(d.line,1)assert.are.equal(d.character,5)c=b.Position.to_vim(e,{line=1,character=6})assert.are.equal(c.row,2)assert.are.equal(c.col,16)c.col=c.col+1;d=b.Position.to_lsp(e,c)assert.are.equal(d.line,1)assert.are.equal(d.character,5)end)end)
