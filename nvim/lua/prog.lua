local M = {}

function M.battery_setup(update)
	_batt = (vim.fn.systemlist('WMIC PATH Win32_Battery Get EstimatedChargeRemaining')[2]:gsub('%s*', ''))
	if (_batt == '') then
		_batt = 100
	else
		local timer = vim.loop.new_timer()
		timer:start(1, update, vim.schedule_wrap(function()
			_batt = vim.fn.systemlist('WMIC PATH Win32_Battery Get EstimatedChargeRemaining')[2]:gsub('%s*', '')
		end))
	end
end

function M.get_battery_indicator()
	local batt_tb = {' ', '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█'} 
	if tonumber(_batt) >= 99 then
		return [[󰚥 (100%%) ]]
	else
		local battery_icon = batt_tb[math.floor((_batt) / (101 / #batt_tb)) + 1]
		return string.format('▕%s▏(%d%s', battery_icon, _batt, "%%)")
	end
end

function M.unload_module(module, loud)
	if package.loaded[module] then
		package.loaded[module] = nil
		if loud then print('Reloaded ' .. module) end
	end
end

function M.get_file_cursor(dir, fname)
	local files
	--> dir = nil => simple search for file // dir provided => search relative fdir
	if dir == nil then
		files = vim.fn.systemlist(string.format('fd ' .. fname))
	else
		files = vim.fn.systemlist(string.format('fd %s --full-path "%s"', fname, dir))
	end
	for _,pat in ipairs(fdignore) do
		require'util'.ArrayRemove(files, function(files, index, j) return not files[index]:match(pat) end)
	end
	if (#files == 0) then
		return
	elseif (#files == 1) then
		vim.cmd('e ' .. files[1])
	else
		require('telescope.builtin').find_files({find_command={'fd', fname}})
	end
end

function M.get_matching_file()
	local ext = vim.fn.expand('%:e')
	local f = vim.fn.expand('%:r')
	local MAP = {c = 'h',	  h = 'c',
				 cpp = 'hpp', hpp = 'cpp' }
	if not MAP[ext] then return end
	vim.cmd(':e '..f..'.'..MAP[ext])
end

function M.pick_cd(opts)
	local pickers = require "telescope.pickers"
	local finders = require "telescope.finders"
	local conf = require("telescope.config").values

	local actions = require "telescope.actions"
	local action_state = require "telescope.actions.state"

	opts = opts or {}
	pickers.new(opts, {
		prompt_title = "Pick CWD",
		finder = finders.new_table({
			results = vim.fn.systemlist("fd -t d")
		}),
		sorter = conf.generic_sorter(opts),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				-- print(vim.inspect(selection))
				vim.cmd(":cd "..selection[1])
		end)
		return true
    end,
	}):find()
end

-- Function adapted from Plenary.nvim to allow for direct buffer lines to be
-- setup, multiple floats for split selection and a set of defaults to match
function M.openCenteredFloat(strings, options)
	strings = type(strings) ~= 'table' and {strings} or strings
	local width = options.width or math.floor(vim.o.columns * 0.5)
	local height = options.height or #strings

	local top, left
	if options.rel then
		top = math.floor(((vim.api.nvim_win_get_height(options.rel) - height) / 2) - 1)
		left = math.floor((vim.api.nvim_win_get_width(options.rel) - width) / 2)
	else
		top = math.floor(((vim.o.lines - height) / 2) - 1)
		left = math.floor((vim.o.columns - width) / 2)
	end

	local opts = {
		relative = options.rel and "win" or "editor",
		win = options.rel or nil,
		row = top,
		col = left,
		width = width,
		height = height,
		style = "minimal",
		border = options.border or 'rounded'
	}

	local bufnr = vim.api.nvim_create_buf(false, true)
	local win_id = vim.api.nvim_open_win(bufnr, true, opts)

	vim.api.nvim_win_set_option(win_id, "winblend", 0)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, strings)

	return {
		bufnr = bufnr,
		win_id = win_id,
	}
end

local ESCAPE = 27
local CHARS = {'1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd',
	'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
	'u', 'v', 'w', 'x', 'y', 'z'}

-- Loops until a character is pressed and validated
-- picker_windows -> table of window ids to close
-- select_options -> options for the user to select from
-- callback -> function with the selected item as an argument
local function pickerLoop(picker_windows, select_options, callback)
	picker_windows = type(picker_windows) ~= 'table' and {picker_windows} or picker_windows

	local function close_floating_buffers(buffers)
		for _,buffer in ipairs(buffers) do
			vim.api.nvim_buf_delete(buffer, {force = true})
		end
	end

	local char_selected = nil
	while char_selected == nil do
		char_selected = vim.fn.getchar()
		char_selected = type(char_selected) ~= "string" and char_selected or nil
		if char_selected == ESCAPE then
			close_floating_buffers(picker_windows)
			return
		-- Char is a number key or is in alphabet
		elseif ((char_selected >= 49 and char_selected <=57) or (char_selected >= 97 and char_selected <= 122)) then
			-- Equivalent to char_selected = nil if char_selected is not in select_options
			char_selected = select_options[string.char(char_selected)]
			if char_selected then
				close_floating_buffers(picker_windows)
				callback(char_selected)
				return
			end
		else 
			char_selected = nil
		end
	end
end

function M.pickBuffers()
	local buffers, strings = {}, {}
	local i = 1
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_option(bufnr, "modifiable") then
			buffers[CHARS[i]] = bufnr
			table.insert(strings, string.format('%s: %s', CHARS[i], vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':t')))
			i = i + 1
		end
	end
	local tbl = M.openCenteredFloat(strings, {rel = false})

	vim.defer_fn(function()
		pickerLoop(tbl.bufnr, buffers,
			function(selected)
				vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), selected)
			end)
	end, 0)
end

function M.pickWindows()
	local wins = vim.api.nvim_list_wins()
	local pickers = {}
	local selects = {}
	for i,id in ipairs(wins) do
		table.insert(pickers, M.openCenteredFloat(string.format('%3s', i), {rel = id, width = 5, border = 'double'}).bufnr)
		selects[CHARS[i]] = id
	end

	vim.defer_fn(function()
		pickerLoop(pickers, selects,
			function(selected)
				vim.api.nvim_set_current_win(selected)
			end)
	end, 0)
end

return M

