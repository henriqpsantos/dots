local g = vim.g
local s = {silent = true}

local map = require'util'.map

--> Leader keys
map('', ' ', '<Nop>')
g.mapleader = [[ ]]
map('', '_', '<Nop>')
g.maplocalleader = [[_]]
map('', '<leader>S', '<cmd>set spell!<CR>', s)

--> In visual mode press . to search selection 
map('v', '.', 'y/<C-R>0<CR>')
--> use '-' for GOTO MARK 
map('', '-', '`')

--> File finding setups
map('n', '<C-f>',	':lua require("telescope.builtin").find_files()<CR>',	s)
map('n', '<C-S-f>',	':lua require("telescope.builtin").file_browser()<CR>',	s)
map('n', '<leader>t', ':lua require("telescope.builtin").treesitter()<CR>',	s)
map('n', '<leader>p', ':lua require("telescope.builtin").registers()<CR>',	s)
--> Search file under cursor
map('n', 'gf', 	'<cmd>lua require("prog").get_file_cursor(vim.fn.expand("%:p:h"), vim.fn.expand("<cfile>"))<CR>', s)
map('n', 'gF', 	'<cmd>lua require("prog").get_file_cursor(nil, vim.fn.expand("<cfile>"))<CR>', s)

--> Hop commands
local hop_modes = {'n', 'v'}

map(hop_modes, '<leader>a', '<cmd>lua require("hop").hint_char1()<CR>', s)
map(hop_modes, '<leader>s', '<cmd>lua require("hop").hint_char2()<CR>', s)
map(hop_modes, '<leader>d', '<cmd>lua require("hop").hint_words()<CR>', s)
map(hop_modes, '<leader>e', '<cmd>lua require("hop").hint_lines()<CR>', s)
map(hop_modes, '<leader>x', '<cmd>lua require("hop").hint_patterns()<CR>', s)

--> Buffer management things
map('n', '<leader>q', '<cmd>bd<CR>', s)
map('n', '<leader>Q', '<cmd>BufferLinePickClose<CR>', s)

map('n', 'gq', '<cmd>TodoQuickFix<CR>')

--> Mappings for C-# -> goto buffer
for i = 1,9 do map('', '<leader>'..i , '<cmd>lua require"bufferline".go_to_buffer('..i..')<CR>', s) end

-->	Bufferline mappings - C[-S]-Tab for cycle, C- <- or -> to move
map('', '<C-Tab>',		'<cmd>lua require"bufferline".cycle(1)<CR>',	s)
map('', '<C-S-Tab>',	'<cmd>lua require"bufferline".cycle(-1)<CR>',	s)
map('', '<C-Right>',	'<cmd>lua require"bufferline".move(1)<CR>',		s)
map('', '<C-Left>',		'<cmd>lua require"bufferline".move(-1)<CR>',	s)

map('', '<M-Right>',':lua require"focus".split_command("l")<CR>', s)
map('', '<M-Left>',	':lua require"focus".split_command("h")<CR>', s)
map('', '<M-Up>',	':lua require"focus".split_command("k")<CR>', s)
map('', '<M-Down>',	':lua require"focus".split_command("j")<CR>', s)

map('', '<M-l>', ':lua require"focus".split_command("l")<CR>', s)
map('', '<M-h>', ':lua require"focus".split_command("h")<CR>', s)
map('', '<M-k>', ':lua require"focus".split_command("k")<CR>', s)
map('', '<M-j>', ':lua require"focus".split_command("j")<CR>', s)

map('', '<C-m>',	':FocusMaximise<CR>', s)
map('', '<C-=>',	':FocusEqualise<CR>', s)

map('n', '<leader>w', '<cmd>update<CR>', s)

map('n', '<leader>m', '<cmd>messages<CR>')
map('n', '<leader>b', '<cmd>Build<CR>')

--> Commonly visited files
local vimhome = "~/Dropbox/Dev"
map('', '<F2>',		':cd '..vimhome..'/.config<CR>')
map('', '<C-F2>', 	'<cmd>e $MYVIMRC<CR>', s)

--> Commonly visited dirs
map('', '<F4>',  ':cd '..vimhome..'<CR>')
map('', '<F5>',  ':cd '..vimhome..'/thesis/Tandem<CR>')
map('', '<F6>',	 ':cd '..vimhome..'/thesis/TandemPres<CR>')
map('', '<F7>',  ':cd '..vimhome..'/thesis/TandemAbstract<CR>')

map('', '<F9>',  ':cd '..vimhome..'/projects<CR>')
map('', '<F10>', ':cd '..vimhome..'/projects/ssearcher<CR>')
map('', '<F11>', ':cd '..vimhome..'/projects/agame<CR>')

map('n', 'gc', '<cmd>lua require"prog".goto_comment()<CR>', {silent = true, nowait = true})
map('n', 'gb', '<C-o>', {silent = true, nowait = true})
-- map('n', 'gh', '<C-i>', {silent = true, nowait = true})

--> <C-F12> to exit terminal mode
map('t', '<C-F12>', [[<C-\><C-N>]], s)

