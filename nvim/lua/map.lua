local g = vim.g
local s = {silent = true}

local map = vim.keymap.set

--> Leader keys
map('', ' ', '<Nop>')
g.mapleader = [[ ]]

map('', '_', '<Nop>')
-- g.maplocalleader = [[ç]]

map('', '<leader>s', function() vim.o.spell = not vim.o.spell end, s)

--> In visual mode press / to search selection 
map('v', '/', 'y/<C-R>0<CR>')

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

for i = 1,9 do map('', '<leader>'..i , function() require("bufferline").go_to_buffer(i) end, s) end

map('n', '<leader>q', '<cmd>bd<CR>', s)
map('n', '<leader>Q', '<cmd>BufferLinePickClose<CR>', s)

map('', '<C-Right>',	function() require("bufferline").move(1) end,		s)
map('', '<C-Left>',	function() require("bufferline").move(-1) end,	s)--}}}

map('n', '<leader>w', '<cmd>update<CR>', s)
map('n', '<leader>m', '<cmd>messages<CR>')

map('n', 'gb', '<C-o>', {silent = true, nowait = true})
map('n', 'gq', '<cmd>TodoQuickFix<CR>')

local nv = {'n', 'v'}
map(nv, 'm', function() require("hop").hint_char1() end, s)
map(nv, 'M', function() require("hop").hint_char2() end, s)
map(nv, ',', function() require("hop").hint_words() end, s)
map(nv, '-', function() require("hop").hint_lines() end, s)

map('n', '<M-Right>', '<cmd>wincmd l<CR>', s)
map('n', '<M-Left>', '<cmd>wincmd h<CR>', s)
map('n', '<M-Up>', '<cmd>wincmd k<CR>', s)
map('n', '<M-Down>', '<cmd>wincmd j<CR>', s)

map('n', '<M-CR>', '<cmd>wincmd =<CR>', s)

map('n', '<M-+>', '<cmd>wincmd 5><CR>', s)
map('n', '<M-->', '<cmd>wincmd 5<<CR>', s)

map('n', '<M-S-+>', '<cmd>wincmd 5+<CR>', s)
map('n', '<M-S->', '<cmd>wincmd 5-<CR>', s)

map('n', '<M-q>', '<cmd>wincmd q<CR>', s)
map('n', '<M-o>', '<cmd>wincmd o<CR>', s)

