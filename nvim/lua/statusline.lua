local M = {}
local api = vim.api
local fn = vim.fn
M.modes = setmetatable({
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

M.get_current_mode = function()
	local current_mode = api.nvim_get_mode().mode
	if self:is_truncated(self.trunc_width.mode) then
		return string.format(' %s ', modes[current_mode][2]):upper()
	end
	return string.format(' %s ', modes[current_mode][1]):upper()
end

statusline = ""

return M
