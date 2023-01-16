if not loaded then
	require'prog'.battery_setup(60000)
	require'util'.plug_noload()
end
loaded = true

local execute = vim.api.nvim_command
local fn = vim.fn
local site = fn.stdpath('data')..'/site'

local compile_path = fn.fnameescape(site ..'/plugin/compiled/pack_compiled.lua')

local profile_plugins = false

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

require('lazy').setup('plugins')

