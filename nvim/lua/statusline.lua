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


-- lualine_a = {'mode'},
-- lualine_b = {},
-- lualine_c = {'branch', 'diff'},
-- lualine_y = {'filetype', 'encoding', 'fileformat'},
-- lualine_z = {require('prog').get_battery_indicator},

-- local function getColorSpec(hlGroup, kind)
-- 	for _,hlName in ipairs(hlGroup) do
-- 		if vim.fn.hlexists(hlName) ~= 0 then
-- 			if kind == 'bg' then
-- 				return string.format('#%06x', vim.api.nvim_get_hl_by_name(hlName, true).background)
-- 			else
-- 				return string.format('#%06x', vim.api.nvim_get_hl_by_name(hlName, true).foreground)
-- 			end
-- 		end
-- 	end
-- end

-- local colors = {
-- 	normal  = getColorSpec( { 'PmenuSel', 'PmenuThumb', 'TabLineSel' },'bg'),
-- 	insert  = getColorSpec( { 'String', 'MoreMsg' },'fg'),
-- 	replace = getColorSpec( { 'Number', 'Type' },'fg'),
-- 	visual  = getColorSpec( { 'Special', 'Boolean', 'Constant' },'fg'),
-- 	command = getColorSpec( { 'Identifier' },'fg'),
-- 	back1   = getColorSpec( { 'Normal', 'StatusLineNC' },'bg'),
-- 	fore    = getColorSpec( { 'Normal', 'StatusLine' },'fg'),
-- 	back2   = getColorSpec( { 'StatusLine' },'bg'),
-- }

local colors = {
	active        = '%#StatusLine#',
	inactive      = '%#StatuslineNC#',
	mode          = '%#Mode#',
	mode_alt      = '%#ModeAlt#',
	git           = '%#Git#',
	git_alt       = '%#GitAlt#',
	filetype      = '%#Filetype#',
	filetype_alt  = '%#FiletypeAlt#',
	line_col      = '%#LineCol#',
	line_col_alt  = '%#LineColAlt#',
}

local sep = ''

local function getCurrentMode()
	local current_mode = api.nvim_get_mode().mode
	return string.format(' %s ', modes[current_mode][1]):upper()
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
		colors.active,
		colors.filetype,
		getCurrentMode(),
		colors.mode_alt,
		sep,
		" %<%f ",
	})
end

vim.o.statusline = "%!luaeval('getStatusLine()')"
