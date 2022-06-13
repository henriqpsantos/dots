local o = vim.o
local wo = vim.wo
local g = vim.g
local cmd = vim.cmd

--> Colorscheme, plugins etc
cmd ('filetype plugin indent on')
cmd ('syntax enable')

-- When virtual text becomes usable in folds
-- o.foldmethod	= 'marker'
-- o.foldlevelstart= 0
-- o.foldtext = [['-->'.substitute(getline(v:foldstart),'\\\\t',repeat('\\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
-- o.foldminlines	= 3

o.inccommand	= 'split'			--> Show incremental search results
o.clipboard		= 'unnamedplus' 	--> Clipboard prog
o.swapfile		= false
o.tabstop		= 4					--> Tabs > Spaces fight me
o.shiftwidth	= 4
o.textwidth		= 0
o.ignorecase	= true
o.smartcase		= true
o.smarttab		= true
o.smartindent	= true
o.autoindent	= false

o.showmatch		= true
o.showmode		= false
o.laststatus	= 3

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

o.updatetime	= 500

g.spelllang		= 'en'

-- g.python3_host_prog = vim.env.PYTHON_LOC
g.python_recommended_style = 0

-- Shell options
o.shell = 'pwsh -NoLogo'
o.shellcmdflag = '-NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
o.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
o.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'

-- o.shell			= "nu"
-- o.shellcmdflag	= '-c'
-- o.shellredir = '| save %s'
-- o.shellpipe	 = '| save %s'

o.shellquote	= ""
o.shellxquote	= ""
o.makeprg		= "ninja -c bin"

