local g = vim.g
local s = {silent = true}

local map = vim.keymap.set

--> Leader keys
map('', ' ', '<Nop>')
g.mapleader = [[ ]]

map('', '_', '<Nop>')
g.maplocalleader = [[ç]]

map('', '<leader>S', '<cmd>set spell!<CR>', s)

--> In visual mode press . to search selection 
map('v', '.', 'y/<C-R>0<CR>')

--> use '-' for GOTO MARK 
map('', '-', '`')

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

map('n', '<leader>.', function() return require("telescope.builtin").resume() end, s)
map('n', '<C-f>', function() return require("telescope.builtin").find_files(opts_ff) end, s)
map('n', '<C-c>', function() return require("telescope.builtin").command_history() end, s)
map('n', '<leader>p', function() return require("telescope.builtin").registers() end, s)
map('n', '<leader>t', function() return require("telescope.builtin").treesitter() end, s)
map('n', '<C-C>', function() return require("prog").pick_cd() end,	s)--}}}

--{{{ QUICKFIX LIST
map('n', 'gm', function() require("prog").make() end, s)
map('n', '<leader>b', '<cmd>copen<CR>')
map('n', 'gn', '<cmd>cnext<CR>', s)
map('n', 'gN', '<cmd>cprev<CR>', s)--}}}

--{{{ HOP COMMANDS
local nv = {'n', 'v'}
map(nv, '<leader>a', function() require("hop").hint_char1() end, s)
map(nv, '<leader>s', function() require("hop").hint_char2() end, s)
map(nv, '<leader>d', function() require("hop").hint_words() end, s)
map(nv, '<leader>e', function() require("hop").hint_lines() end, s)
map(nv, '<leader>x', function() require("hop").hint_patterns() end, s)--}}}

-- BUFFERLINE {{{
for i = 1,9 do map('', '<leader>'..i , function() require("bufferline").go_to_buffer(i) end, s) end

map('n', '<leader>q', '<cmd>bd<CR>', s)
map('n', '<leader>Q', '<cmd>BufferLinePickClose<CR>', s)

map('', '<C-Tab>',	function() require("bufferline").cycle(1) end,	s)
map('', '<C-S-Tab>',	function() require("bufferline").cycle(-1) end,	s)
map('', '<C-Right>',	function() require("bufferline").move(1) end,		s)
map('', '<C-Left>',	function() require("bufferline").move(-1) end,	s)--}}}

-- FOCUS MAPS {{{
map('', '<M-Right>',	function() require("focus").split_command("l") end, s)
map('', '<M-Left>',	function() require("focus").split_command("h") end, s)
map('', '<M-Up>',	function() require("focus").split_command("k") end, s)
map('', '<M-Down>',	function() require("focus").split_command("j") end, s)

map('', '<M-l>', function() require("focus").split_command("l") end, s)
map('', '<M-h>', function() require("focus").split_command("h") end, s)
map('', '<M-k>', function() require("focus").split_command("k") end, s)
map('', '<M-j>', function() require("focus").split_command("j") end, s)

map('', '<C-m>',	':FocusMaximise<CR>', s)
map('', '<C-=>',	':FocusEqualise<CR>', s)--}}}

map('n', '<leader>w', '<cmd>update<CR>', s)
map('n', '<leader>m', '<cmd>messages<CR>')

--> Commonly visited files & dirs
local vimhome = "~/Dropbox/Dev"
map('', '<F2>',		':cd '..vim.env.XDG_CONFIG_HOME..'<CR>')
map('', '<C-F2>', 	'<cmd>e $MYVIMRC<CR>', s)

--> Commonly visited dirs
map('', '<F5>',  ':cd '..'~/Dev/<CR>')
map('', '<F6>',  ':cd '..vimhome..'<CR>')

map('', '<F9>',  ':cd '..vimhome..'/projects<CR>')
map('', '<F10>', ':cd '..vimhome..'/projects/ssearcher<CR>')
map('', '<F11>', ':cd '..vimhome..'/projects/agame<CR>')

map('n', 'gb', '<C-o>', {silent = true, nowait = true})

map('n', 'gq', '<cmd>TodoQuickFix<CR>')

