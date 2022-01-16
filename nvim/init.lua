if not loaded then
	require'prog'.battery_setup(60000)
	require'util'.plug_noload()
end

--> for utility functions util.lua
-->	for custom routines prog.lua
--> plugins.lua ++ plugcfg.lua

if vim.g.neovide then require'neovide' end

require('settings')	--> for general settings  
require('map')		--> for keymaps

--> NOTE: Run psh build, for latex etc
-- vim.cmd('command! Build :lua require("prog").run_job("just")<CR>') 
-- vim.cmd('au BufWritePost *.tex Build')

vim.cmd('command! PSync :lua require("plugins").sync()<CR>') 
vim.cmd('command! PComp :lua require("plugins").compile()<CR>') 

vim.cmd('au FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None')
vim.cmd('au BufWritePost plug*.lua lua require("util").reload_plugins()')

-- vim.cmd('au BufWritePost *.cpp,*.h lua require("util").format(vim.fn.expand("%"), "cpp")')

--> FIXME: Eventually run Build in the background on tex files

--> Used to check if this file has already been loaded;
--> useful for battery_setup and timer checks
loaded = true

