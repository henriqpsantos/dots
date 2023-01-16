local execute = vim.api.nvim_command
local fn = vim.fn
local site = fn.stdpath('data')..'/site'

install_path = site ..'/pack/packer/opt/packer.nvim'
local compile_path = fn.fnameescape(site ..'/plugin/compiled/pack_compiled.lua')

local profile_plugins = false

if (fn.empty(fn.glob(install_path)) > 0) then
	fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
end

--> This only adds packer if necessary
vim.cmd('packadd packer.nvim')

local function init()
	local cfg = require('plugcfg')
	local use = require('packer').use

	use({'wbthomason/packer.nvim', opt = true,})

--{{{ TREESITTER
	use({
		{'nvim-treesitter/nvim-treesitter',
			run = ':TSUpdate',
			config = cfg.treesitter,},
		{'nvim-treesitter/nvim-treesitter-refactor',
			after = 'nvim-treesitter',},
		{'p00f/nvim-ts-rainbow',
			after = 'nvim-treesitter',},
		{'IndianBoy42/tree-sitter-just',
			after = 'nvim-treesitter'}
	})
--}}}

--{{{ COLORSCHEME AND PRETTY UI
	use({"EdenEast/nightfox.nvim",
		config = function()
			require('nightfox')
			vim.schedule(function() vim.cmd('colorscheme terafox') end)
		end})

	use({{'nvim-lualine/lualine.nvim',
			requires = {'kyazdani42/nvim-web-devicons',},
			event = 'ColorScheme', config = cfg.lualine,},

		{'akinsho/bufferline.nvim',
			requires = {'kyazdani21/nvim-web-devicons',},
			event = 'ColorScheme', config = cfg.bufferline,}
	})

 	use({'folke/todo-comments.nvim',
 		requires = {'nvim-lua/plenary.nvim',},
		event = 'BufRead',
		config = cfg.todocomments})
--}}}

--{{{ EDITOR AND FINDER
 	use({'nvim-telescope/telescope.nvim',
 		module = 'telescope',
 		requires = {{'nvim-lua/popup.nvim',},
					{'nvim-lua/plenary.nvim',},
					{'kyazdani42/nvim-web-devicons',},
					{'nvim-telescope/telescope-fzf-native.nvim',
						run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }},
 		config = cfg.telescope,})

	use({'lukas-reineke/indent-blankline.nvim',
		config = cfg.indentblankline,
		event = 'BufRead',})

	use({'echasnovski/mini.nvim',
		branch = 'stable',
		config = cfg.mini,})

	use({'beauwilliams/focus.nvim',
		module = "focus",
		config = cfg.focus,})

	use({'lewis6991/gitsigns.nvim',
		config = cfg.gitsigns,})

	use({'akinsho/toggleterm.nvim',
		tag = '*',
		config = cfg.toggleterm,})
--}}}

--{{{ MOTIONS
	use({'phaazon/hop.nvim',
			as = 'hop',
			config = cfg.hop,
			event = 'CursorHold',
			cmd = {'HopWord','HopChar2','HopWord'},})
	
	-- attepted to use Leap, didn't fit me
	-- use({"ggandor/leap.nvim",
	-- 	config = cfg.leap})
--}}}

--{{{ COQ
	use({{'ms-jpq/coq_nvim',
			branch = 'coq',
			setup = cfg.coq,
			commit = '553fc3c0'},
		{'ms-jpq/coq.artifacts',
			branch = 'artifacts',
			after = 'coq_nvim',
			commit = '52358b2'},
		{'ms-jpq/coq.thirdparty',
			branch ='3p',
			after = 'coq_nvim',
			config = cfg.coqPost,
			commit = '3f49405'},
	})
--}}}

--{{{ LANGUAGE SUPPORT
 	use {'lervag/vimtex',
 		ft = 'tex',}
--}}}

end

return require('packer').startup({
	init,
	config = {compile_path = compile_path, profile = {enable = profile_plugins, threshold = 0}}})

