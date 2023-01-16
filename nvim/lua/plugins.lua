local cfg = require('plugcfg')
return {
	{'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		config = cfg.treesitter,
		dependencies = {
			'nvim-treesitter/nvim-treesitter-refactor',
			'p00f/nvim-ts-rainbow',
			-- 'IndianBoy42/tree-sitter-just',
		},
	},

<<<<<<< HEAD
	{"savq/melange-nvim",
=======
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

	use({'nathom/filetype.nvim'})

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
>>>>>>> 97482717f6edfd59189f7b0f37f1cb8b0e5dcaac
		config = function()
			vim.cmd.colorscheme('melange')
		end},

	{'nvim-lualine/lualine.nvim',
			dependencies = {'kyazdani42/nvim-web-devicons',},
			event = 'ColorScheme', config = cfg.lualine,},

	{'akinsho/bufferline.nvim',
			dependencies = {'kyazdani42/nvim-web-devicons',},
			event = 'ColorScheme', config = cfg.bufferline,},

 	{'folke/todo-comments.nvim',
 		dependencies = {'nvim-lua/plenary.nvim',},
		event = 'BufRead',
		config = cfg.todocomments},

 	{'nvim-telescope/telescope.nvim',
 		module = 'telescope',
 		dependencies = {{'nvim-lua/popup.nvim',},
					{'nvim-lua/plenary.nvim',},
					{'kyazdani42/nvim-web-devicons',},
					{'nvim-telescope/telescope-fzf-native.nvim',
						build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }},
 		config = cfg.telescope,},

	{'lukas-reineke/indent-blankline.nvim',
		config = cfg.indentblankline,
		event = 'BufRead',},

	{'echasnovski/mini.nvim',
		branch = 'stable',
		config = cfg.mini,},

	{'beauwilliams/focus.nvim',
		module = "focus",
		config = cfg.focus,},

	{'lewis6991/gitsigns.nvim',
		config = cfg.gitsigns,},

	{'akinsho/toggleterm.nvim',
		version = '*',
		config = cfg.toggleterm,},

	{'phaazon/hop.nvim',
			name = 'hop',
			config = cfg.hop,
			event = 'CursorHold',
			cmd = {'HopWord','HopChar2','HopWord'},},

	{'ms-jpq/coq_nvim',
			branch = 'coq',
			init = cfg.coq,
			dependencies = {
				'coq.artifacts',
				'coq.thirdparty'}
			},

	{'ms-jpq/coq.artifacts',
		branch = 'artifacts',
	},

	{'ms-jpq/coq.thirdparty',
		branch ='3p',
		config = cfg.coqPost},

 	{'lervag/vimtex',
 		ft = 'tex',},
}
