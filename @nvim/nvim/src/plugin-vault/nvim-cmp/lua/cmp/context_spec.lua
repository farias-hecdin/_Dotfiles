local a=require('cmp.utils.spec')local b=require('cmp.context')describe('context',function()before_each(a.before)describe('new',function()it('middle of text',function()vim.fn.setline('1','function! s:name() abort')vim.bo.filetype='vim'vim.fn.execute('normal! fm')local c=b.new()assert.are.equal(c.filetype,'vim')assert.are.equal(c.cursor.row,1)assert.are.equal(c.cursor.col,15)assert.are.equal(c.cursor_line,'function! s:name() abort')end)it('tab indent',function()vim.fn.setline('1','\t\tab')vim.bo.filetype='vim'vim.fn.execute('normal! fb')local c=b.new()assert.are.equal(c.filetype,'vim')assert.are.equal(c.cursor.row,1)assert.are.equal(c.cursor.col,4)assert.are.equal(c.cursor_line,'\t\tab')end)end)end)
