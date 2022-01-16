local execute = vim.api.nvim_command
local fn = vim.fn
local site = fn.stdpath('data')..'/site'

local install_path = fn.fnameescape(site ..'/pack/packer/opt/packer.nvim')
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
	-- use({'savq/melange',
	-- 		event = 'VimEnter',
	-- 		config = function() vim.cmd('colorscheme melange') end})
	use({'rebelot/kanagawa.nvim',
			event = 'VimEnter',
			config = function() vim.cmd('colorscheme kanagawa') end})

	use({{'nvim-lualine/lualine.nvim',
			requires = {'kyazdani42/nvim-web-devicons',},
			event = 'VimEnter', config = cfg.lualine,},
		{'akinsho/nvim-bufferline.lua',
			requires = {'kyazdani21/nvim-web-devicons',},
			event = 'VimEnter', config = cfg.bufferline,}
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
					{'kyazdani42/nvim-web-devicons',}},
 		config = cfg.telescope,})

	use({"beauwilliams/focus.nvim",
		module = "focus",
		config = cfg.focus,})

	use {'lukas-reineke/indent-blankline.nvim',
		config = cfg.indentblankline,
		event = 'BufRead',}

	use { 'echasnovski/mini.nvim',
		branch = 'stable',
		config = cfg.mini,}

	use {'edluffy/specs.nvim',
		config = cfg.specs,
		event = 'BufRead',}
--}}}

--{{{ MOTIONS
	use({'phaazon/hop.nvim',
 		as = 'hop',
 		config = cfg.hop,
 		event = 'CursorHold',
		cmd = {'HopWord','HopChar2','HopWord'},})
--}}}

--{{{ COQ COMPLETION
	use({{'ms-jpq/coq_nvim',
			branch = 'coq',
			setup = cfg.coq,
			commit = 'ba6e67ed'},
		{'ms-jpq/coq.artifacts',
			branch = 'artifacts',
			after = 'coq_nvim',
			commit = 'c37312c'},
		{'ms-jpq/coq.thirdparty',
			branch ='3p',
			after = 'coq_nvim',
			config = cfg.coqPost,
			commit = '7fe3067'},
	})
--}}}

--{{{ LANGUAGE SUPPORT
 	use {'jupyter-vim/jupyter-vim',
 		ft = 'python',
		setup = "vim.g['jupyter_mapkeys'] = 0",}
 	use {'lervag/vimtex',
 		ft = 'tex',}
--}}}

end

return require('packer').startup({
	init,
	config = {compile_path = compile_path, profile = {enable = profile_plugins, threshold = 0}}})

