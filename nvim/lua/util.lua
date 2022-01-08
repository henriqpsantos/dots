local M = {}

function M.reload_plugins()
	require('prog').unload_module('plugcfg', false)
	require('prog').unload_module('plugins', false)
	vim.schedule(function()
		require('plugins').compile()
	end)
end

--> Map keys with nvim api, on modes mode
function M.map(modes, lhs, rhs, opts)
	opts = opts or {}
	opts.noremap = opts.noremap == nil and true or opts.noremap
	if type(modes) == 'string' then modes = {modes} end
	for _, mode in ipairs(modes) do vim.api.nvim_set_keymap(mode, lhs, rhs, opts) end
end

--> Equivalent to util.map but only for the current buffer
function M.buf_map(modes, lhs, rhs, opts)
	opts = opts or {}
	opts.noremap = opts.noremap == nil and true or opts.noremap
	if type(modes) == 'string' then modes = {modes} end
	for _, mode in ipairs(modes) do vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, opts) end
end

function M.get_battery_indicator()
	local batt_tb = {' ', '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█'} 
	--> This looks disgusting here, but good on lualine
	return string.format('▕%s▏%s%d%s', batt_tb[math.floor((_batt) / (101 / #batt_tb)) + 1], '(', _batt, '%%) ')
end

function M.get_treesitter_status()
	return require'nvim-treesitter'.statusline({
			indicator_size = 100,
			type_patterns = {'class', 'function', 'method'},
			transform_fn = function(line) return line:gsub('%s*[%[%(%{]*%s*$', '') end,
			separator = ' -> '})
end

--> Usually an order of magnitude faster than table.remove : source ->> https://stackoverflow.com/questions/12394841 <<- 
function M.ArrayRemove(t, fnKeep)
	local j, n = 1, #t;
	for i=1,n do
		if (fnKeep(t, i, j)) then
			-- Move i's kept value to j's position, if it's not already there.
			if (i ~= j) then
				t[j] = t[i];
				t[i] = nil;
			end
			j = j + 1;
		else
			t[i] = nil;
		end
	end
	return t;
end

--> Disable built-in plugins, only run once
function M.plug_noload()
	local disabled_built_ins = {
		"netrw",
		"netrwPlugin",
		"netrwSettings",
		"netrwFileHandlers",
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
		"spellfile_plugin",
		-- "matchit",
		"tutor_mode_plugin",
	}

	for _, plugin in pairs(disabled_built_ins) do
		vim.g["loaded_" .. plugin] = true
	end
end

return M
