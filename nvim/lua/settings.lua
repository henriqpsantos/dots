local o = vim.o
local wo = vim.wo
local g = vim.g
local cmd = vim.cmd


--> Colorscheme, plugins etc
cmd ('filetype plugin indent on')
cmd ('syntax enable')

--> SETTINGS <--
o.inccommand	= 'nosplit'
o.clipboard		= 'unnamedplus'
o.swapfile		= false
o.tabstop		= 4
o.shiftwidth	= 4
o.textwidth		= 0
o.ignorecase	= true
o.smartcase		= true
o.smarttab		= false
o.smartindent	= false
o.autoindent	= false
o.showmode		= false
o.wrap			= false
o.splitright	= true
o.splitbelow	= true
o.termguicolors = true
o.number		= true
o.relativenumber= true
o.lazyredraw	= false
o.cursorline	= true
o.conceallevel	= 2
o.completeopt	= 'menuone,noselect'
o.encoding		= 'UTF-8'
o.fileformats	= 'dos,unix'

o.updatetime	= 750

g.spelllang		= 'en'

-- g.python3_host_prog = vim.env.PYTHON_LOC
g.python_recommended_style = 0

-- Shell options
o.shell			= "nu"
o.shellcmdflag	= '-c'
o.shellredir = '2>&1 | save --raw %s'
o.shellpipe	 = '2>&1 | save --raw %s'

o.shellquote	= ""
o.shellxquote	= ""


--> POWERSHELL STUFF
-- o.shell			= "pwsh"
-- o.shellcmdflag	= '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
-- o.shellredir	= '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
-- o.shellpipe	= '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'

--> FD ignore patterns
fdignore = {
	'__pycache__',
	'%.tdms',
	'%.feather',
	'%.npz',
	'%.aux',
	'%.otf',
	'%.ttf',
	'%.mp3',
	'%.sfd',
}

