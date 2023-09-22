local map = vim.keymap.set

-- Features -------------------------------------------------------------------

local load_current_buffer = function()
  local path = vim.cmd("echo bufname()")
  vim.cmd("e " .. path)
end

-- MiniSessions
-- source: ~/.local/share/nvim/session/
function MiniSessions_write(var)
  local session_name = var
  vim.cmd("lua MiniSessions.write('".. session_name .. "')")
end
function MiniSessions_delete(var)
  local session_name = var
  vim.cmd("lua MiniSessions.delete('".. session_name .. "')")
end

-- Keymaps generales ----------------------------------------------------------
--
-- Modos
-- * normal mode = "n",
-- * insert mode = "i",
-- * visual mode = "v",
-- * vis_line mode = "x",
-- * terminal mode = "t",
-- * command mode = "c",

-- Sessions
map("n", "<leader>xa1", function() MiniSessions_write('session_1') end, {desc = "New - 1"})
map("n", "<leader>xa2", function() MiniSessions_write('session_2') end, {desc = "New - 2"})
map("n", "<leader>xa3", function() MiniSessions_write('session_3') end, {desc = "New - 3"})
map("n", "<leader>xa4", function() MiniSessions_write('session_4') end, {desc = "New - 4"})
map("n", "<leader>xa5", function() MiniSessions_write('session_5') end, {desc = "New - 5"})
map("n", "<leader>xd1", function() MiniSessions_delete('session_1') end, {desc = "Delete - 1"})
map("n", "<leader>xd2", function() MiniSessions_delete('session_2') end, {desc = "Delete - 2"})
map("n", "<leader>xd3", function() MiniSessions_delete('session_3') end, {desc = "Delete - 3"})
map("n", "<leader>xd4", function() MiniSessions_delete('session_4') end, {desc = "Delete - 4"})
map("n", "<leader>xd5", function() MiniSessions_delete('session_5') end, {desc = "Delete - 5"})

-- Other
map("n", "<leader>@", function() load_current_buffer() end, {desc = "Load current buffer"})

-- Lsp diagnotic
map("n", "gdS", ":DiagnoticShow<cr>", {desc = "[Lsp] Show"})
map("n", "gdH", ":DiagnoticHide<cr>", {desc = "[Lsp] Hide"})
map("n", "gdE", ":DiagnosticEnable<cr>", {desc = "[Lsp] Enabled"})
map("n", "gdD", ":DiagnosticDisable<cr>", {desc = "[Lsp] Disabled"})

-- Search mode
map("v", "<leader>s", "y/<C-r>\"", {desc = "Search: text selected"})

-- Gitsigns
map("n", "<leader>Gd", ":Gitsigns diffthis<cr>", {desc = "Gitsigns: diff"})
map("n", "<leader>Gp", ":Gitsigns preview_hunk<cr>", {desc = "Gitsigns: preview"})

-- Undo
map("n", "<C-u>", "<ESC>u", {desc = "Undo"})

-- Cursor
map("i", "<C-j>", "<ESC>o", {desc = "Open a line below"})
map("i", "<C-k>", "<ESC>O", {desc = "Open a line above"})

-- Return normal mode
map("i", "jk", "<ESC>", {desc = "Return normal mode"})
map("i", "kj", "<ESC>", {desc = "Return normal mode"})

-- Add undo break-points
map("i", ",", ",<c-g>u", {desc = "Undo break-points"})
map("i", ".", ".<c-g>u", {desc = "Undo break-points"})
map("i", ";", ";<c-g>u", {desc = "Undo break-points"})
map("i", ":", ":<c-g>u", {desc = "Undo break-points"})
map("i", "?", "?<c-g>u", {desc = "Undo break-points"})
map("i", "=", "=<c-g>u", {desc = "Undo break-points"})

-- Delete safely
map({"n", "x"}, "x", '"_x', {desc = "Delete safely"})

-- MiniStarter
map("n", "<leader>S", ":lua require('mini.starter').open()<cr>", {desc = "Starter"})

-- Oldfiles
map("n", "<leader>o", ":browse oldfiles<cr>", {desc = "Old files"})

-- Terminal
map("t", "<C-x>", "<C-\\><C-N>", {desc = "Terminal: exit mode"})
map("n", "<C-t>", ":terminal<cr>", {desc = "Terminal: open"})

-- Treesitter
map("n", "<leader>Te", ":TSOn<cr>", {desc = "TS: enabled"})
map("n", "<leader>Td", ":TSOff<cr>", {desc = "TS: disabled"})

-- Wrap
map("n", "<leader>we", ":set wrap<cr>", {desc = "Wrap: enabled"})
map("n", "<leader>wd", ":set nowrap<cr>", {desc = "Wrap: disabled"})

-- Fzf-lua
map("n", "<leader>Fo", ":FzfLua<cr>", {desc = "Fzf: open"})
map("n", "<leader>Fg", ":FzfLua grep<cr>", {desc = "Fzf: grep"})
map("n", "<leader>Ff", ":FzfLua files cwd=~/", {desc = "Fzf: search"})

-- Markdown
map("v", "<C-B>", ":lua require('markdowny').bold()<cr>", {desc = "Md: bold",})
map("v", "<C-I>", ":lua require('markdowny').italic()<cr>", {desc = "Md: italic"})
map("v", "<C-L>", ":lua require('markdowny').link()<cr>", {desc = "Md: link"})
map("n", "<leader>Mt", ":MdTocToggle<cr>", {desc = "Md: open TOC"})
map("n", "<leader>Mu", ":MdUpdateNumber<cr>", {desc = "Md: add/update number"})
map("n", "<leader>Mx", ":MdCleanNumber<cr>", {desc = "Md: clean number"})

-- Cut, Copy and Paste
map("v", "<C-x>", ":!termux-clipboard-set<cr>", {desc = "To cut"}) -- “Ctrl-x” to cut
map("v", "<C-c>", ":w !termux-clipboard-set<cr>", {desc = "To copy"}) -- “Ctrl-c” to copy
map("v", "<C-v>", ":read !termux-clipboard-get<cr>", {desc = "To paste"}) -- “Ctrl+p” to paste

-- Save, quit and exit
map("n", "<leader>fz", ":wq<cr>", {desc = "Save/quit"})
map("n", "<leader>fw", ":w<cr>", {desc = "Save"})
map("n", "<leader>f!w", ":w!<cr>", {desc = "Save: forced"})
map("n", "<leader>fq", ":q<cr>", {desc = "Quit"})
map("n", "<leader>f!q", ":q!<cr>", {desc = "Quit: forced"})
map("n", "<leader>f@", ":qa<cr>", {desc = "Exit"})
map("n", "<leader>f!@", ":qa!<cr>", {desc = "Exit: forced"})
map("n", "<C-q>", ":q<cr>", {desc = "Quit"})
map("n", "<C-w>", ":wq<cr>", {desc = "Save/quit"})

-- Save in all mode
map({"i", "v", "n", "s"}, "<C-s>", "<cmd>w<cr><esc>", {desc = "Save: now"})

-- Select
map("n", "<leader>ma", ":keepjumps normal! ggVG<cr>", {desc = "Select: all"})
map("v", "<leader>ma", "ggVG<cr>", {desc = "Select: all"})

-- Buffers
map("n", "<leader>bN", ":enew<cr>", {desc = "Buffer: new"})
map("n", "<C-Right>", ":bn<cr>", {desc = "Buffer: next"})
map("n", "<C-Left>", ":bp<cr>", {desc = "Buffer: previous"})
map("n", "<leader>bn", ":bn<cr>", {desc = "Buffer: next"})
map("n", "<leader>bp", ":bp<cr>", {desc = "Buffer: previous"})
map("n", "<leader>ba", ":ls<cr>", {desc = "Buffer: all"})
map("n", "<leader>bx", ":bd<cr>", {desc = "Buffer: close"})
map("n", "<leader>bl", ":BSOpen<cr>", {desc = "Buffer: list"})
map("n", "<leader>bo", ":FlyBuf<cr>", {desc = "Buffer: list alt"})

-- Refresh
map("n", "<leader>%", ":source %<cr>", {desc = "Refresh"})

-- Numbers
map("n", "<leader>ni", "<C-a>", {desc = "Number: increase"})
map("n", "<leader>nd", "<C-x>", {desc = "Number: decrease"})

-- Tab
map("n", "<leader>tc", ":tabnew<cr>", {desc = "Tabs: new"})
map("n", "<leader>tn", ":tabn<cr>", {desc = "Tabs: next"})
map("n", "<leader>tp", ":tabp<cr>", {desc = "Tabs: previous"})
map("n", "<leader>tx", ":tabclose<cr>", {desc = "Tabs: close"})

-- File explorer
map("n", "<leader>eo", ":NnnExplorer<cr>", {desc = "Explorer: sidebar"})
map("n", "<leader>ef", ":NnnPicker %:p:h<cr>", {desc = "Explorer: float (active buffer)"})
map("n", "<leader>em", ":lua MiniFiles.open()<cr>", {desc = "Explorer: miller columns"})

-- Clear search with <esc>
map("n", "<esc>", "<cmd>noh<cr><esc>", {desc = "Escape and clear hlsearch"})

-- Lowercase and uppercase
map("v", "<leader>lu", "U<cr>", {desc = "Letter: uppercase"})
map("v", "<leader>ll", "u<cr>", {desc = "Letter: lowercase"})
map("n", "<leader>lu", "gU<cr>", {desc = "Letter: uppercase"})
map("n", "<leader>ll", "gu<cr>", {desc = "Letter: lowercase"})
map("n", "<leader>lr", "g~~<cr>", {desc = "Letter: reverse"})

-- Tabulator
map("v", "<leader>.h", "<gv", {desc = "Tab: left"})
map("v", "<leader>.l", ">gv", {desc = "Tab: Right"})

-- Move Lines
map("n", "<leader>.k", ":m .-2<cr>==", {desc = "Move line: up"})
map("n", "<leader>.j", ":m .+1<cr>==", {desc = "Move line: down"})
map("v", "<leader>.k", ":m '<-2<cr>gv=gv", {desc = "Move lines: up"})
map("v", "<leader>.j", ":m '>+1<cr>gv=gv", {desc = "Move lines: down"})

-- Resize window
map("n", "<leader>sj", ":resize +10<cr>", {desc = "Window: down"})
map("n", "<leader>sk", ":resize -10<cr>", {desc = "Window: up"})
map("n", "<leader>sh", ":vertical resize -10<cr>", {desc = "Window: left"})
map("n", "<leader>sl", ":vertical resize +10<cr>", {desc = "Window: right"})
map("n", "<leader>se", "<C-w>=", {desc = "Window: equal size"})

-- Split
map("n", "<leader>sH", "<C-w>v", {desc = "Split: horizontal"})
map("n", "<leader>sV", "<C-w>s", {desc = "Split: vertical"})
map("n", "<leader>sq", ":close<cr>", {desc = "Split: quit"})
map("n", "<leader>sx", ":Bdelete<cr>", {desc = "Split: close"})
map("n", "<leader>sw", ":WindowNvim<cr>", {desc = "Split: check"})
map("n", "<leader>\'", ":WindowNvim<cr>", {desc = "Split: check"})

-- Easier pasting
map("i", "<C-p>", '<ESC>gP', {desc = "Paste"})
map("v", "p", '"_dP', {desc = "Paste"})
map("n", "P", "gP", {desc = "Paste: right"})
map("n", "p", "gp", {desc = "Paste: left"})
map("n", "<leader>pk", ":pu!<cr>", {desc = "Paste: up"})
map("n", "<leader>pj", ":pu<cr>", {desc = "Paste: down"})

-- Duplicate lines
map("x", "<leader>d", ":'<,'>y|put!<cr>", {desc = "Duplicate: all line"})
map("n", "<leader>d", "yyP<cr>", {desc = "Duplicate: an line"})

-- Better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j' ", {expr = true, silent = true})
map("n", "k", "v:count == 0 ? 'gk' : 'k' ", {expr = true, silent = true})
map("v", "j", "v:count == 0 ? 'gj' : 'j' ", {expr = true, silent = true})
map("v", "k", "v:count == 0 ? 'gk' : 'k' ", {expr = true, silent = true})

-- Lazy
map("n", "<leader>Z", ":Lazy<cr>", {desc = "Lazy"})

-- Which_key
map("n", "<leader>W", ":checkhealth which_key<cr>", {desc = "Which key"})

-- Cmp
map("n", "<leader>Cd", ":lua require('cmp').setup.buffer {enabled = false}<cr>", {desc = "Cmp: disable"})
map("n", "<leader>Ce", ":lua require('cmp').setup.buffer {enabled = true}<cr>", {desc = "Cmp: enabled"})

-- URL handling ( https://sbulav.github.io/vim/neovim-opening-urls )
map("n", "gx", ':call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<cr>', {desc = "Open: link"})
