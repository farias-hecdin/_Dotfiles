local a={}local b=false;local c=false;function a.extend(d)if c then return end;local e={set_lsp_source=true,set_mappings=true,use_luasnip=true}d=vim.tbl_deep_extend('force',e,d or{})local f=a.base_config()local g={}if d.set_lsp_source then g.sources=f.sources end;if d.set_mappings then g.mapping=f.mapping end;if d.use_luasnip then g.snippet=f.snippet end;require('cmp').setup(g)b=true;c=true end;function a.apply_base()if b then return end;b=true;if package.loaded['cmp']==nil then require('cmp').setup(a.base_config())return end;local h=require('cmp')local i=h.get_config()local j=a.base_config()local k={}if vim.tbl_isempty(i.sources)then k.sources=j.sources end;if vim.tbl_isempty(i.mapping)then k.mapping=j.mapping end;local l=i.snippet.expand;local m=j.snippet.expand;k.snippet={expand=function(n)local o=pcall(l,n)if not o then l=m;l(n)end end}h.setup(k)end;function a.base_config()return{mapping=a.basic_mappings(),sources={{name='nvim_lsp'}},snippet={expand=function(n)require('luasnip').lsp_expand(n.body)end}}end;function a.basic_mappings()local h=require('cmp')return{['<C-y>']=h.mapping.confirm({select=false}),['<C-e>']=h.mapping.abort(),['<Up>']=h.mapping.select_prev_item({behavior='select'}),['<Down>']=h.mapping.select_next_item({behavior='select'}),['<C-p>']=h.mapping(function()if h.visible()then h.select_prev_item({behavior='insert'})else h.complete()end end),['<C-n>']=h.mapping(function()if h.visible()then h.select_next_item({behavior='insert'})else h.complete()end end)}end;function a.format(d)d=d or{}local p=d.max_width or false;return{fields={'abbr','menu','kind'},format=function(q,r)local s=q.source.name;if s=='nvim_lsp'then r.menu='[LSP]'elseif s=='nvim_lua'then r.menu='[nvim]'else r.menu=string.format('[%s]',s)end;if p and#r.abbr>p then local t=r.kind=='Snippet'and'~'or''r.abbr=string.format('%s %s',string.sub(r.abbr,1,p),t)end;return r end}end;function a.action()return require('lsp-zero.cmp-mapping')end;return a