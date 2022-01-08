M = {}

-- NOTE(h): THIS IS TEXT
-- NOTE(h): THIS IS TEXT
-- NOTE: THIS IS TEXT
M.todocomments = function()
	require'todo-comments'.setup { 
		merge_keywords = false,
		signs = false,
		highlight = {
			before = "",
			keyword = "bg",
			after = "fg",
			pattern = {[[.*<(KEYWORDS)(\([^\)]*\))?:]]},
		},
		pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]],
	}
end

M.treesitter = function()
	require'nvim-treesitter.configs'.setup {
		ensure_installed = {'c', 'python', 'latex', 'lua', 'cpp', 'rust'},
		highlight = { enable = true },
		autopairs = { enable = true },
		-- rainbow = {
		-- 	enable = true,
		-- 	extended_mode = false,
		-- },
		refactor = {
			highlight_definitions = { enable = true },
			navigation = {
				enable = true,
				keymaps = {
					goto_definition = 'gd',
					list_definitions = 'gD',
				},
			},
			smart_rename = {
				enable = true,
				keymaps = {
					smart_rename = 'gr',
				},
			},
		},
	}
	require("nvim-treesitter.parsers").get_parser_configs().just = {
		install_info = {
			url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
			files = { "src/parser.c", "src/scanner.cc" },
			branch = "main",
		},
		maintainers = {"@IndianBoy42"},
	}
end

M.tokyonight = function()
	vim.g.tokyonight_style = 'night'
	vim.g.tokyonight_sidebars = { "qf", "telescope", "terminal", "packer" }
	vim.defer_fn(function() vim.cmd('colorscheme tokyonight') end, 0)
end

M.lspconfig = function() 
	require'lspconfig'.jedi_language_server.setup{}
	require'lspconfig'.texlab.setup{}
end

M.luasnip = function()
	require'luasnip'.config.set_config {
		history = true,
		updateevents = "TextChanged,TextChangedI"
	}
end

--> NOTE: Why would you do it like this
M.coq = function()
	vim.g.coq_settings = {
		auto_start = true,
		display = {
			pum = {
				source_context = {'⎡', '⎦'},
			},
		},
	}
end

M.coqPost = function()
	require("coq_3p") {
		{ src = "vimtex", short_name = "vTEX" },
	}
end

M.specs = function()
	require('specs').setup{
		show_jumps  = true,
		min_jump = 10,
		popup = {
			delay_ms = 0, -- delay before popup displays
			inc_ms = 12, -- time increments used for fade/resize effects 
			blend = 10, -- starting blend, between 0-100 (fully transparent), see :h winblend
			width = 15,
			winhl = "PMenu",
			fader = require('specs').exp_fader,
			resizer = require('specs').shrink_resizer
		},
		ignore_filetypes = {},
		ignore_buftypes = {
			nofile = true,
		},
	}
end

M.indentblankline = function()
	require("indent_blankline").setup {
		char = "|",
		buftype_exclude = {"terminal"}
	}
end

M.autopairs = function()
	require'nvim-autopairs'.setup {
		check_ts = true
	}
end

M.surround = function()
	require'surround'.setup{
		load_keymaps = true,
	}
end

M.floatline = function()
	require'floatline'.setup()
end

M.lualine = function()
	require'lualine'.setup {
		options = {
			icons_enabled = true,
			disabled_filetypes = {},
			theme = 'auto',
		},
		sections = {
			lualine_a = {'mode'},
			lualine_b = {require'util'.get_treesitter_status},
			lualine_c = {'branch', 'diff', 'diagnostics'},
			lualine_x = {'filetype', 'encoding', 'fileformat'},
			lualine_y = {'progress', 'location'},
			lualine_z = {require'util'.get_battery_indicator},
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = {'filename'},
			lualine_x = {'location'},
			lualine_y = {},
			lualine_z = {}
		},
		tabline = {},
		extensions = {}
	}
end

M.bufferline = function()
	require'bufferline'.setup {
		options = { 
			numbers = function(opts)
				return string.format('%s₍%s₎', opts.ordinal, opts.lower(opts.id))
			end,
			close_command = nil,	
			right_mouse_command = nil,
			left_mouse_command = nil, 
			middle_mouse_command = nil, 
			indicator_icon = '▎',
			buffer_close_icon = '',
			modified_icon = '●',
			close_icon = '',
			left_trunc_marker = '',
			right_trunc_marker = '',
			max_name_length = 18,
			max_prefix_length = 15,
			tab_size = 18,
			diagnostics = false,
			show_buffer_icons = true,
			show_buffer_close_icons = false,
			show_close_icon = false,
			show_tab_indicators = true,
			separator_style = "thin",
			enforce_regular_tabs = false,
			always_show_bufferline = true,
			sort_by = 'id'
		}
	}
end

M.mini = function()
	require('mini.surround').setup({
		n_lines = 25,
		-- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
		highlight_duration = 500,

		-- Pattern to match function name in 'function call' surrounding
		-- By default it is a string of letters, '_' or '.'
		funname_pattern = '[%w_%.]+',

		-- Mappings. Use `''` (empty string) to disable one.
		mappings = {
			add = 'sa',           -- Add surrounding
			delete = 'sd',        -- Delete surrounding
			find = 'sf',          -- Find surrounding (to the right)
			find_left = 'sF',     -- Find surrounding (to the left)
			highlight = 'sh',     -- Highlight surrounding
			replace = 'sr',       -- Replace surrounding
			update_n_lines = 'sn' -- Update `n_lines`
		}
	})
	require('mini.comment').setup({
		mappings = {
			-- Toggle comment (like `gcip` - comment inner paragraph) for V+I
			comment = 'gc',
			-- Toggle comment on current line
			comment_line = 'gcc',
			-- Define 'comment' textobject (like `dgc` - delete whole comment block)
			textobject = 'gc',
		}
	})
	require('mini.pairs').setup({
		-- In which modes mappings from this `config` should be created
		modes = {insert = true, command = false, terminal = false},

		-- Global mappings. Each right hand side should be a pair information, a
		-- table with at least these fields (see more in `:h MiniPairs.map`):
		-- - `action` - one of 'open', 'close', 'closeopen'.
		-- - `pair` - two character string for pair to be used.
		-- By default pair is not inserted after `\`, quotes are not recognized by
		-- `<CR>`, `'` does not insert pair after a letter.
		-- Only parts of the tables can be tweaked (others will use these defaults).
		mappings = {
			['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
			['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
			['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },

			[')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
			[']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
			['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },

			['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
			["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
			['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
		},
	})
end

M.nvim_comment = function()
	require'nvim_comment'.setup {
		line_mapping = "gvv",
		operator_mapping = "gv",
		create_mappings = true,
	}
end

M.hop = function() 
	require'hop'.setup {
		keys = 'asdghklqwertyuiopzxcvbnmfj',
		reverse_distribution = true,
	}
end

M.telescope = function()
	require'telescope'.setup {
		defaults = {
			file_ignore_patterns = fdignore,
		}
	}
end

M.focus = function()
	require'focus'.setup {
		bufnew =  false,
		hybridnumber = true,
	}
end

return M
