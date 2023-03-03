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

local function getSpecs(name, kind)
	for k,v in pairs(vim.api.nvim_get_hl_by_name(name, true)) do
		if type(v) == 'number' then
			print(string.format('  %s, #%06x', k, v))
		else
			print(string.format('  %s, %s', k, v))
		end
	end
end

local function getHLColor(name, kind)
	return string.format('#%06x', vim.api.nvim_get_hl_by_name(name, true)[kind])
end

local function highlightLike(name, attrs, invert)
	attrs.bg, nbg = attrs.bg:gsub("?", "")
	attrs.fg, nfg = attrs.fg:gsub("?", "")

	local bg_plane = nbg == 0 and 'background' or 'foreground'
	local fg_plane = nfg == 0 and 'foreground' or 'background'
 
	attrs.bg = getHLColor(attrs.bg, bg_plane)
	attrs.fg = getHLColor(attrs.fg, fg_plane)
	vim.api.nvim_set_hl(0, name, attrs)
	if invert then
		local temp = attrs.bg
		attrs.bg = attrs.fg
		attrs.fg = temp
		vim.api.nvim_set_hl(0, '_inv_'..name, attrs)
	end
end

local SLInvV2 = {
	['SLnmode'] =  {fg = 'Normal', bg = 'Normal', bold = true}, -- a.fg
	['SLimode'] =  {fg = 'String', bg = 'Normal', bold = true}, -- b.blue
	['SLrmode'] =  {fg = 'Type', bg = 'Normal', bold = true}, -- c.cyan
	['SLvmode'] =  {fg = 'GitSignsChange', bg = 'Normal', bold = true}, -- c.magenta
	['SLterm']  =  {fg = 'Function', bg = 'Normal', bold = true}, -- b.yellow
	['SLcenter'] = {fg = 'Normal', bg = 'Normal'},			  -- a.fg
	['SLcmode'] = {fg = 'ErrorMsg', bg = 'Normal', bold = true},	  -- 
}
for i,v in pairs(SLInvV2) do highlightLike(i, v, true) end

local SLHighlights = {
	-- ['_inv_SLcmode'] = {bg = '?ErrorMsg', fg = 'Normal', bold = true}, -- 
	['SL_ON'] = {fg = 'GitSignsAdd', bg = 'Normal'},
	['SL_OFF'] = {fg = 'GitSignsDelete', bg = 'Normal'},
}
for i,v in pairs(SLHighlights) do highlightLike(i, v, false) end

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
	return string.format('%s %s %s%s', wrap_hl('_inv_'..mode_colors[current_mode]), modes[current_mode][1]:upper(), wrap_hl(mode_colors[current_mode]), arrows.fright)
end

local function getGitStatus()
	-- use fallback because it doesn't set this variable on the initial `BufEnter`
	local signs = vim.b.gitsigns_status_dict or {head = '', added = 0, changed = 0, removed = 0}
	local is_head_empty = signs.head ~= ''
	return is_head_empty and string.format(' %s+%s %s~%s %s-%s %s|  %s %s',
			wrap_hl('GitSignsAdd'), signs.added,
			wrap_hl('GitSignsChange'), signs.changed,
			wrap_hl('GitSignsDelete'), signs.removed,
			wrap_hl('Normal'), signs.head, arrows.eright) or ''
end

local function getFileStr()
	local icon_ff = vim.bo.fileformat == 'dos' and '' or ''
	local icon_enc = string.upper(vim.o.encoding)
	local file_name, file_ext = fn.expand("%:t"), fn.expand("%:e")
	local icon = require'nvim-web-devicons'.get_icon(file_name, file_ext, { default = true })
	local filetype = vim.bo.filetype:lower()
	
	if filetype == 'toggleterm' then file_name = "term" end
	if filetype == 'lazy' then file_name = "lazy" end
	local type_info = string.format('%s %s', icon, filetype)
	return string.format('%s%s%s %s | %s | %s : %s %s%s',
		wrap_hl('SLcenter'), arrows.fleft, wrap_hl('_inv_SLcenter'),
		file_name,
		type_info,
		icon_ff, icon_enc, wrap_hl('SLnmode'), arrows.fright)
end

local function opts()
	local function format_option(icon, option)
		return (option and wrap_hl('SL_ON') or wrap_hl('SL_OFF')) .. icon
	end
	local spell_check = format_option('暈', vim.o.spell)
	local wrap_check = format_option('', vim.o.wrap)

	local flags = {
		pt_pt = 'pt',
	}
	local langs = ''
	if vim.opt_local.spell:get() then
		langs = {}
		for i,v in ipairs(vim.opt_local.spelllang:get()) do
			langs[i] = flags[v] or v
		end
		langs = string.format('(%s)', table.concat(langs, '/'):upper())
	end
	return table.concat({'', spell_check,
		langs,
		wrap_check,
		' '}, ' ')
end

local function word_count()
	local wc = vim.fn.wordcount().visual_words and vim.fn.wordcount().visual_words or vim.fn.wordcount().words
	return string.format(' %d words ', wc)
end

local norm = wrap_hl('Normal')
local center = wrap_hl('_inv_SLcenter')

return function()
	return table.concat({
		getCurrentMode(),
		getGitStatus(),
		EQUAL,
		getFileStr(),
		EQUAL, norm, arrows.eleft,
		word_count(), arrows.eleft,
		opts(),
		norm, arrows.eleft, " Ln %l / %L ",
		arrows.fleft, center, " ", require('prog').get_battery_indicator(),
	})
end

