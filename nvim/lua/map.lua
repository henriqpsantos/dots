local g = vim.g
local s = {silent = true}

local map = vim.keymap.set

--> Leader keys
vim.keymap.set('', ' ', '<Nop>')
g.mapleader = [[ ]]

vim.keymap.set('', '_', '<Nop>')
g.maplocalleader = [[ç]]

vim.keymap.set('', '<leader>S', '<cmd>set spell!<CR>', s)

--> In visual mode press . to search selection 
vim.keymap.set('v', '.', 'y/<C-R>0<CR>')
--> use '-' for GOTO MARK 
vim.keymap.set('', '-', '`')

--{{{ TELESCOPE STUFF
local opts_ff = { attach_mappings = function(prompt_bufnr, map)
	local actions = require "telescope.actions"
	actions.select_default:replace(
		function(prompt_bufnr)
			local actions = require "telescope.actions"
			local state = require "telescope.actions.state"
			local picker = state.get_current_picker(prompt_bufnr)
			local multi = picker:get_multi_selection()
			local single = picker:get_selection()
			local str = ""
			if #multi > 0 then
				for i,j in pairs(multi) do
					str = str.."edit "..j[1].." | "
				end
			end
			str = str.."edit "..single[1]
			actions.close(prompt_bufnr)
			vim.api.nvim_command(str)
		end)
	return true
end }

vim.keymap.set('n', '<C-f>', function() return require("telescope.builtin").find_files(opts_ff) end, s)
vim.keymap.set('n', '<leader>p', function() return require("telescope.builtin").registers() end, s)
vim.keymap.set('n', '<leader>t', function() return require("telescope.builtin").treesitter() end, s)
vim.keymap.set('n', '<C-c>', function() return require("prog").pick_cd() end,	s)--}}}

--{{{ QUICKFIX LIST
vim.keymap.set('n', 'gm', function() require("prog").make() end, s)
vim.keymap.set('n', '<leader>b', '<cmd>copen<CR>')
vim.keymap.set('n', 'gn', '<cmd>cnext<CR>', s)
vim.keymap.set('n', 'gN', '<cmd>cprev<CR>', s)--}}}

--{{{ HOP COMMANDS
local nv = {'n', 'v'}
vim.keymap.set(nv, '<leader>a', function() require("hop").hint_char1() end, s)
vim.keymap.set(nv, '<leader>s', function() require("hop").hint_char2() end, s)
vim.keymap.set(nv, '<leader>d', function() require("hop").hint_words() end, s)
vim.keymap.set(nv, '<leader>e', function() require("hop").hint_lines() end, s)
vim.keymap.set(nv, '<leader>x', function() require("hop").hint_patterns() end, s)--}}}

-- BUFFERLINE {{{
for i = 1,9 do vim.keymap.set('', '<leader>'..i , function() require("bufferline").go_to_buffer(i) end, s) end

vim.keymap.set('n', '<leader>q', '<cmd>bd<CR>', s)
vim.keymap.set('n', '<leader>Q', '<cmd>BufferLinePickClose<CR>', s)

vim.keymap.set('', '<C-Tab>',	function() require("bufferline").cycle(1) end,	s)
vim.keymap.set('', '<C-S-Tab>',	function() require("bufferline").cycle(-1) end,	s)
vim.keymap.set('', '<C-Right>',	function() require("bufferline").move(1) end,		s)
vim.keymap.set('', '<C-Left>',	function() require("bufferline").move(-1) end,	s)--}}}

-- FOCUS MAPS {{{
vim.keymap.set('', '<M-Right>',	function() require("focus").split_command("l") end, s)
vim.keymap.set('', '<M-Left>',	function() require("focus").split_command("h") end, s)
vim.keymap.set('', '<M-Up>',	function() require("focus").split_command("k") end, s)
vim.keymap.set('', '<M-Down>',	function() require("focus").split_command("j") end, s)

vim.keymap.set('', '<M-l>', function() require("focus").split_command("l") end, s)
vim.keymap.set('', '<M-h>', function() require("focus").split_command("h") end, s)
vim.keymap.set('', '<M-k>', function() require("focus").split_command("k") end, s)
vim.keymap.set('', '<M-j>', function() require("focus").split_command("j") end, s)

vim.keymap.set('', '<C-m>',	':FocusMaximise<CR>', s)
vim.keymap.set('', '<C-=>',	':FocusEqualise<CR>', s)--}}}

vim.keymap.set('n', '<leader>w', '<cmd>update<CR>', s)
vim.keymap.set('n', '<leader>m', '<cmd>messages<CR>')

--> Commonly visited files & dirs
local vimhome = "~/Dropbox/Dev"
vim.keymap.set('', '<F2>',		':cd '..vimhome..'/.config<CR>')
vim.keymap.set('', '<C-F2>', 	'<cmd>e $MYVIMRC<CR>', s)

--> Commonly visited dirs
vim.keymap.set('', '<F5>',  ':cd '..'~/Dev/<CR>')
vim.keymap.set('', '<F6>',  ':cd '..vimhome..'<CR>')

vim.keymap.set('', '<F9>',  ':cd '..vimhome..'/projects<CR>')
vim.keymap.set('', '<F10>', ':cd '..vimhome..'/projects/ssearcher<CR>')
vim.keymap.set('', '<F11>', ':cd '..vimhome..'/projects/agame<CR>')

vim.keymap.set('n', 'gb', '<C-o>', {silent = true, nowait = true})

--> <C-F12> to exit terminal mode
vim.keymap.set('t', '<C-F12>', [[<C-\><C-N>]], s)

vim.keymap.set('n', 'gq', '<cmd>TodoQuickFix<CR>')

