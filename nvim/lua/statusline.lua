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
		['cv'] = {'Vim·Ex', 'V·E'};
		['ce'] = {'Ex', 'E'};
		['r']  = {'Prompt', 'P'};
		['rm'] = {'More', 'M'};
		['r?'] = {'Confirm', 'C'};
		['!']  = {'Shell', 'S'};
		['t']  = {'Terminal', 'T'};
	}, {
	__index = function()
		return {'Unknown', 'U'} -- handle edge cases
	end
})

local function getSpecs(name)
	print(name)
	for k,v in pairs(vim.api.nvim_get_hl_by_name(name, true)) do
		if type(v) == 'number' then
			print(string.format('  %s, #%06x', k, v))
		else
			print(string.format('  %s, %s', k, v))
		end
	end
end

local function setHighlight(name, attrs, invert)
	vim.api.nvim_set_hl(0, name, attrs)
	if invert then
		local temp = attrs.bg
		attrs.bg = attrs.fg
		attrs.fg = temp
		vim.api.nvim_set_hl(0, '_inv_'..name, attrs)
	end
end

local SLInvHighlights = {
	['SLnmode'] = {bg = '#ece1d7', fg = '#292522', bold = true},
	['SLimode'] = {bg = '#a3a9ce', fg = '#292522', bold = true},
	['SLrmode'] = {bg = '#cf9bc2', fg = '#292522', bold = true},
	['SLvmode'] = {bg = '#b380b0', fg = '#292522', bold = true},
	['SLterm']  = {bg = '#ebc06d', fg = '#292522', bold = true},
	['SLcenter'] = {bg = '#ece1d7', fg = '#292522'},
}
for i,v in pairs(SLInvHighlights) do setHighlight(i, v, true) end

local SLHighlights = {
	['SLback1'] = {bg = '#292522'},
	['SLback2'] = {bg = '#34302c'},
	['SLfore'] = {fg = '#ece1d7'},
	['SLcmode'] = {bg = '#7d2a2f', fg = '#ece1d7', bold = true},
	['_inv_SLcmode'] = {fg = '#7d2a2f', bg = '#292522', bold = true},
}
for i,v in pairs(SLHighlights) do setHighlight(i, v, false) end

local mode_colors = setmetatable({
		['n']  = "SLnmode";
		['no'] = "SLnmode";
		['v']  = "SLvmode";
		['V']  = "SLvmode";
		[''] = "SLvmode";
		['s']  = "SLrmode";
		['S']  = "SLrmode";
		[''] = "SLrmode";
		['i']  = "SLimode";
		['ic'] = "SLimode";
		['R']  = "SLrmode";
		['Rv'] = "SLrmode";
		['c']  = "SLcmode";
		['cv'] = "SLcmode";
		['ce'] = "SLcmode";
		['r']  = "StatusLine";
		['rm'] = "StatusLine";
		['r?'] = "StatusLine";
		['!']  = "SLterm";
		['t']  = "SLterm";
	}, {
	__index = function()
		return "StatusLine" -- handle edge cases
	end
})

local EQUAL = '%='
-- local SEP = {'', '', '', ''}
local arrows = {
	eleft = '',
	eright = '',
	fleft = '',
	fright = '',
}

local function wrap_hl(hl)
	return table.concat({"%#", hl, "#"})
end

local function getCurrentMode()
	local current_mode = api.nvim_get_mode().mode
	return string.format('%s %s %s%s', wrap_hl(mode_colors[current_mode]), modes[current_mode][1]:upper(), wrap_hl("_inv_"..mode_colors[current_mode]), arrows.fright)
end

local function getGitStatus()
	-- use fallback because it doesn't set this variable on the initial `BufEnter`
	local signs = vim.b.gitsigns_status_dict or {head = '', added = 0, changed = 0, removed = 0}
	local is_head_empty = signs.head ~= ''
	return is_head_empty and string.format(' %s+%s %s~%s %s-%s %%#Normal#|  %s %s',
			wrap_hl('GitSignsAdd'), signs.added,
			wrap_hl('GitSignsChange'), signs.changed,
			wrap_hl('GitSignsDelete'), signs.removed, signs.head, arrows.eright) or ''
end

-- local function getFiletype()
-- 	local file_name, file_ext = fn.expand("%:t"), fn.expand("%:e")
-- 	local icon = require'nvim-web-devicons'.get_icon(file_name, file_ext, { default = true })
-- 	local filetype = vim.bo.filetype
--
-- 	if filetype == '' then return '' end
-- 	return string.format(' %s %s ', icon, filetype):lower()
-- end
--
-- local function getFileInfo()
-- 	local icon_ff = vim.bo.fileformat == 'dos' and '' or ''
-- 	local icon_enc = string.upper(vim.o.encoding)
-- 	return string.format(' %s | %s ', icon_ff, icon_enc)
-- end

local function getFileStr()
	local icon_ff = vim.bo.fileformat == 'dos' and '' or ''
	local icon_enc = string.upper(vim.o.encoding)

	local file_name, file_ext = fn.expand("%:t"), fn.expand("%:e")
	local icon = require'nvim-web-devicons'.get_icon(file_name, file_ext, { default = true })
	local filetype = vim.bo.filetype:lower()
	
	if filetype == 'toggleterm' then file_name = "TERM" end
	local type_info = string.format('%s %s', icon, filetype)
	return string.format('%s%s%s %s | %s | %s : %s %s%s',
		wrap_hl('_inv_SLcenter'), arrows.fleft, wrap_hl('SLcenter'),
		file_name,
		type_info,
		icon_ff, icon_enc, wrap_hl('_inv_SLnmode'), arrows.fright)
end

local norm = wrap_hl('Normal')
local center = wrap_hl('SLcenter')

return function()
	return table.concat({
		getCurrentMode(),
		getGitStatus(),
		EQUAL,
		getFileStr(),
		EQUAL,
		norm, arrows.eleft, " Ln %l / %L ",
		arrows.fleft, center, " ", require('prog').get_battery_indicator(),
	})
end

-- vim.o.statusline = [[%!luaeval('x()')]]

