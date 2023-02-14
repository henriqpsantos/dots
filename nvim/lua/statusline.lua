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


-- set_hl(0, 'SLback1', {bg = '#292522'})
-- set_hl(0, 'SLback2', {bg = '#34302c'})
--
-- set_hl(0, 'SLnmode', {bg = '#ece1d7', fg = '#292522', bold = true})
-- set_hl(0, 'SLimode', {bg = '#a3a9ce', fg = '#292522', bold = true})
-- set_hl(0, 'SLrmode', {bg = '#cf9bc2', fg = '#292522', bold = true})
-- set_hl(0, 'SLvmode', {bg = '#b380b0', fg = '#292522', bold = true})
-- set_hl(0, 'SLterm',  {bg = '#ebc06d', fg = '#292522', bold = true})
--
-- set_hl(0, '_inv_SLnmode', {fg = '#ece1d7', bg = '#292522', bold = true})
-- set_hl(0, '_inv_SLimode', {fg = '#a3a9ce', bg = '#292522', bold = true})
-- set_hl(0, '_inv_SLrmode', {fg = '#cf9bc2', bg = '#292522', bold = true})
-- set_hl(0, '_inv_SLvmode', {fg = '#b380b0', bg = '#292522', bold = true})
-- set_hl(0, '_inv_SLterm',  {fg = '#ebc06d', bg = '#292522', bold = true})
--
-- set_hl(0, 'SLcmode', {bg = '#7d2a2f', fg = '#ece1d7', bold = true})
-- set_hl(0, '_inv_SLcmode', {fg = '#7d2a2f', bg = '#292522', bold = true})
--
-- set_hl(0, 'SLfore',  {fg = '#ece1d7'})

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
	local icon_ff = vim.bo.fileformat == 'dos' and '' or ''
	local icon_enc = string.upper(vim.o.encoding)
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
		EQUAL,
		" %<%t ",
		SEPARATOR,
		getFiletype(),
		SEPARATOR,
		getFileInfo(),
		EQUAL,
		" Ln %l /  %L ",
		SEPARATOR,
		" ",
		require('prog').get_battery_indicator(),
	})
end
