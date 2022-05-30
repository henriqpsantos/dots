vim.api.nvim_create_user_command("PSync", function() require("plugins").sync() end, {})
vim.api.nvim_create_user_command("PComp", function() require("plugins").compile() end, {})

local group = vim.api.nvim_create_augroup("MAIN_GROUP", {clear = true})
vim.api.nvim_create_autocmd(
	{"BufWritePost"}, {
		group	 = group,
		pattern  = {"plug*.lua"},
		callback = require('util').reload_plugins })

vim.api.nvim_create_autocmd({"BufWritePre"}, {
		group	 = group,
		pattern  = {"*.cpp", "*.h"},
		callback = function() require('util').format(vim.fn.expand("%"), "cpp") end })

vim.api.nvim_create_autocmd({"FileChangedShellPost"}, {
		group	= group,
		pattern = {"*"},
		command = 'echohl WarningMsg | echo "File changed on disk. Buffer reloaded."' })

--{{{ SKELETON FILES
-- Add skeleton file extensions here
local skeletons = {"h", "c", "cpp", "hpp"}
local skeleton_path = vim.env.XDG_CONFIG_HOME .. "/nvim/templates/skeleton."
-- Though looking for paths at startup works, it is a bit slower than a
-- predefined table of skeletons
-- local paths = vim.split(vim.fn.glob(vim.env.XDG_CONFIG_HOME .. "/nvim/templates/skeleton.*"), '\n')
local command = ""
for _,ext in pairs(skeletons) do
	command = command .. string.format("autocmd BufNewFile *.%s 0r %s\n", ext, skeleton_path..ext)
end

vim.cmd([[
	augroup spooky
	au!
	]] .. command .. [[
	augroup end
]])
--}}}
