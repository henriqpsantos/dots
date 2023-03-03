if not loaded then
	require'prog'.battery_setup(60000)
	local disabled_built_ins = {
		"gzip",
		"zip",
		"zipPlugin",
		"tar",
		"tarPlugin",
		"getscript",
		"getscriptPlugin",
		"vimball",
		"vimballPlugin",
		"2html_plugin",
		"logipat",
		"rrhelper",
		-- "netrw",
		-- "netrwPlugin",
		-- "netrwSettings",
		-- "netrwFileHandlers",
		-- "spellfile_plugin",
		"tutor_mode_plugin",
	}
	for _, plugin in pairs(disabled_built_ins) do
		vim.g["loaded_" .. plugin] = true
	end
end
loaded = true

local execute = vim.api.nvim_command
local fn = vim.fn
local site = fn.stdpath('data')..'/site'

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
})
end
vim.opt.rtp:prepend(lazypath)

require('neovide')
require('settings')		--> for general settings
require('map')			--> for keymaps
require('commands')		--> for custom commands

vim.g.coq_settings = {
	auto_start = 'shut-up',
	-- display = {pum = {source_context = {'⎡', '⎦'},},},
	-- clients = { snippets = {}, },
}

require('lazy').setup('plugins')

