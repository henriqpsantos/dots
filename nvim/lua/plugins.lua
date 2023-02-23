local cfg = require('plugcfg')
return {
	{'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		config = cfg.treesitter,
		event = 'BufRead',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-refactor',
			'p00f/nvim-ts-rainbow',
		},},

	{'savq/melange-nvim',
		config = function() vim.cmd.colorscheme('melange') end},

	{'folke/todo-comments.nvim',
		dependencies = {'nvim-lua/plenary.nvim',},
		event = 'BufRead',
		config = cfg.todocomments},

	{'nvim-telescope/telescope.nvim',
		module = 'telescope',
		dependencies = {
			{'nvim-lua/popup.nvim',},
			{'nvim-lua/plenary.nvim',},
			{'kyazdani42/nvim-web-devicons',},
			{'nvim-telescope/telescope-ui-select.nvim'},
			{'nvim-telescope/telescope-fzf-native.nvim',
				build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
		},
		lazy = true,
		config = cfg.telescope,},

	{'lukas-reineke/indent-blankline.nvim',
		config = cfg.indentblankline,
		event = 'BufRead',},

	{'echasnovski/mini.nvim',
		branch = 'stable',
		config = cfg.mini,},

	{'lewis6991/gitsigns.nvim',
		event = 'BufRead',
		config = cfg.gitsigns,},
	
	{'sindrets/diffview.nvim',
		cmd = 'DiffviewOpen',
		dependencies = {'nvim-lua/plenary.nvim',},
		config = cfg.diffview
	},

	{'akinsho/toggleterm.nvim',
		keys = '<C-t>',
		version = '*',
		config = cfg.toggleterm,},

	{'phaazon/hop.nvim',
		name = 'hop',
		config = cfg.hop,
		event = 'CursorHold',
		cmd = {'HopWord','HopChar2','HopWord'},
	},

	{'ms-jpq/coq_nvim',
		branch = 'coq',
		init = cfg.coq,
		event = 'InsertEnter',
		dependencies = {
			{'ms-jpq/coq.artifacts',
					branch = 'artifacts',},
			{'ms-jpq/coq.thirdparty',
				branch ='3p',
				config = cfg.coqPost,},
		},
	},

	{'lervag/vimtex',
		ft = 'tex',},

	{'asiryk/auto-hlsearch.nvim',
		version = '1.0.0',
		event = 'BufRead',
		config = function() require('auto-hlsearch').setup() end},

	{'kevinhwang91/nvim-ufo',
		config = cfg.ufo,
		event = 'BufRead',
		dependencies = 'kevinhwang91/promise-async'},
}
