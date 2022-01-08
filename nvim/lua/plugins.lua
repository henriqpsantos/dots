local execute = vim.api.nvim_command
local fn = vim.fn
local site = fn.stdpath('data')..'/site'

local install_path = fn.fnameescape(site ..'/pack/packer/opt/packer.nvim')
local compile_path = fn.fnameescape(site ..'/plugin/compiled/pack_compiled.lua')

local profile = true

if (fn.empty(fn.glob(install_path)) > 0) then
	fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
	--> Unnecessary since we require packer anyway
	-- vim.cmd('packadd packer.nvim')
end

--> This only adds packer if necessary
vim.cmd('packadd packer.nvim')
local function init()
	local cfg = require('plugcfg')
	local use = require('packer').use

	use {'wbthomason/packer.nvim',
		opt = true,}

	use	{'nvim-treesitter/nvim-treesitter',
 		run = ':TSUpdate',
 		config = cfg.treesitter,}
	use {'p00f/nvim-ts-rainbow',
		after = 'nvim-treesitter',}
	use {'nvim-treesitter/nvim-treesitter-refactor',
		after = 'nvim-treesitter',}

	use "IndianBoy42/tree-sitter-just"

	use {'savq/melange',
		event = 'VimEnter',
		config = function() vim.cmd('colorscheme melange') end,
	}

	use {"beauwilliams/focus.nvim",
		module = "focus",
		config = cfg.focus,}

	--> NOTE: Lualine and bufferline
	use {'nvim-lualine/lualine.nvim',
		requires = {'kyazdani42/nvim-web-devicons',},
		after = 'melange',
		config = cfg.lualine,}

	use {'akinsho/nvim-bufferline.lua',
		requires = {'kyazdani21/nvim-web-devicons',},
		after = 'melange',
		config = cfg.bufferline,}

 	use {'nvim-telescope/telescope.nvim',
 		module = 'telescope',
 		requires = {{'nvim-lua/popup.nvim',},
					{'nvim-lua/plenary.nvim',},
					{'kyazdani42/nvim-web-devicons',}},
 		config = cfg.telescope,}

	--> NOTE: Coding completion and snippet plugins
	use {'ms-jpq/coq_nvim',
		branch = 'coq',
		setup = cfg.coq}
	use {'ms-jpq/coq.artifacts',
		branch = 'artifacts',
		after = 'coq_nvim'}
	use {'ms-jpq/coq.thirdparty',
		branch ='3p',
		after = 'coq_nvim',
		config = cfg.coqPost}
	
		-- REPLACE
	use { 'echasnovski/mini.nvim',
		branch = 'stable',
		config = cfg.mini}

 	use {'folke/todo-comments.nvim',
 		requires = {'nvim-lua/plenary.nvim',},
		event = 'BufRead',
		config = cfg.todocomments}

	use {'lukas-reineke/indent-blankline.nvim',
		config = cfg.indentblankline,
		event = 'BufRead',}

	--> NOTE: Filetype plugins
 	use {'jupyter-vim/jupyter-vim',
 		ft = 'python',
		setup = "vim.g['jupyter_mapkeys'] = 0",}
 	use {'lervag/vimtex',
 		ft = 'tex',}

 	use {'phaazon/hop.nvim',
 		as = 'hop',
 		config = cfg.hop,
 		event = 'CursorHold',
		cmd = {'HopWord','HopChar2','HopWord'}}
	use {'edluffy/specs.nvim',
		config = cfg.specs,
		event = 'BufRead',}

-- 	use {'windwp/nvim-autopairs',
--		config = cfg.autopairs,
-- 		event = 'InsertCharPre'}

-- 	use {'blackCauldron7/surround.nvim',
--		config = cfg.surround,}

	--> Only rarely useful, but extremely when so
 	use {'godlygeek/tabular',
 		cmd = 'Tabularize',}
end

return require('packer').startup({
	init,
	config = {compile_path = compile_path,
			profile = {enable = profile, threshold = 0}}})

