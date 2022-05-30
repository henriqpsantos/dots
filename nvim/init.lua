if not loaded then
	require'prog'.battery_setup(60000)
	require'util'.plug_noload()
	vim.cmd('cd ~/Dev')
end
loaded = true

if true then require'neovide' end

require('settings')	--> for general settings
require('map')		--> for keymaps
require('commands')		--> for keymaps


