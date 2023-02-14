local M = {}
local api = vim.api
local fn = vim.fn
local modes = setmetatable({
		['n']  = {'Normal', 'N'};
		['no'] = {'N·Pending', 'N·P'} ;
		['v']  = {'Visual', 'V' };
		['V']  = {'V·Line', 'V·L' };
		[''] = {'V·Block', 'V·B'};
		['s']  = {'Select', 'S'};
		['S']  = {'S·Line', 'S·L'};
		[''] = {'S·Block', 'S·B'};
		['i']  = {'Insert', 'I'};
		['ic'] = {'Insert', 'I'};
		['R']  = {'Replace', 'R'};
		['Rv'] = {'V·Replace', 'V·R'};
		['c']  = {'Command', 'C'};
		['cv'] = {'Vim·Ex ', 'V·E'};
		['ce'] = {'Ex ', 'E'};
		['r']  = {'Prompt ', 'P'};
		['rm'] = {'More ', 'M'};
		['r?'] = {'Confirm ', 'C'};
		['!']  = {'Shell ', 'S'};
		['t']  = {'Terminal ', 'T'};
	}, {
	__index = function()
		return {'Unknown', 'U'} -- handle edge cases
	end
})

local clmodes = setmetatable({
		['n']  = "%#SpecialChar#";
		['no'] = "%#SpecialChar#";
		['v']  = "%#DiffChange#";
		['V']  = "%#DiffChange#";
		[''] = "%#DiffChange#";
		['s']  = "%#Operator#";
		['S']  = "%#Operator#";
		[''] = "%#Operator#";
		['i']  = "%#Constant#";
		['ic'] = "%#Constant#";
		['R']  = "%#Character#";
		['Rv'] = "%#Character#";
		['c']  = "%#ErrorMsg#";
		['cv'] = "%#ErrorMsg#";
		['ce'] = "%#ErrorMsg#";
		['r']  = "%#StatusLine#";
		['rm'] = "%#StatusLine#";
		['r?'] = "%#StatusLine#";
		['!']  = "%#Function#";
		['t']  = "%#Function#";
	}, {
	__index = function()
		return "%#StatusLine#" -- handle edge cases
	end
})

local function getCurrentMode()
	local current_mode = api.nvim_get_mode().mode
	return string.format('%s %s ', clmodes[current_mode], modes[current_mode][1]):upper()
end

local function getFiletype()
	local file_name, file_ext = fn.expand("%:t"), fn.expand("%:e")
	local icon = require'nvim-web-devicons'.get_icon(file_name, file_ext, { default = true })
	local filetype = vim.bo.filetype

	if filetype == '' then return '' end
	return string.format(' %s %s ', icon, filetype):lower()
end

local function getGitStatus()
	-- use fallback because it doesn't set this variable on the initial `BufEnter`
	local signs = vim.b.gitsigns_status_dict or {head = '', added = 0, changed = 0, removed = 0}
	local is_head_empty = signs.head ~= ''

	return is_head_empty
		and string.format(' %%#GitSignsAdd#+%s %%#GitSignsChange#~%s %%#GitSignsDelete#-%s %%#Normal#|  %s ',
		signs.added, signs.changed, signs.removed, signs.head) or ''
end

local cls = {
	active		= '%#Normal#',
}
local function getFiletype()
	local file_name, file_ext = fn.expand("%:t"), fn.expand("%:e")
	local icon = require'nvim-web-devicons'.get_icon(file_name, file_ext, { default = true })
	local filetype = vim.bo.filetype
	
	if filetype == '' then return '' end
	return string.format(' %s %s ', icon, filetype):lower()
end

local function getFileInfo()
	local icon_ff = require'nvim-web-devicons'.get_icon(vim.bo.fileformat, vim.bo.fileformat, { default = true })
	local icon_enc = require'nvim-web-devicons'.get_icon(vim.o.encoding, vim.o.encoding, { default = true })
	return string.format(' %s | %s ', icon_ff, icon_enc)
end

local EQUAL = '%='
local SEPARATOR = cls.active..'|'

return function()
	return table.concat({
		cls.active,
		getCurrentMode(),
		SEPARATOR,
		getGitStatus(),
		SEPARATOR,
		getFiletype(),
		-- SEPARATOR,
		-- getFileInfo(),
		EQUAL,
		" %<%t ",
		EQUAL,
		" Ln %l /  %L ",
		SEPARATOR,
		" ",
		require('prog').get_battery_indicator(),
	})
end

vim.o.statusline = "%!luaeval('getStatusLine()')"
