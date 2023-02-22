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

function M.just_progress()
	local status = {"", "", "", "", "", ""}
	local icons = {"?", "ⓙ", "✓", "🞖"}
	if build_running then
		return status[1]
	elseif make_done then
	end
	return icons[1]
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
end--}}}

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

local function openCenteredFloat(strings, options)
	local curr_win_id = vim.api.nvim_get_current_win()
	local width = options.width or math.floor(vim.api.nvim_win_get_width(curr_win_id) * 0.5)
	local height = options.height or #strings

	local top, left
	if options.rel then
		top = math.floor(((vim.api.nvim_get_win_height(curr_win_id) - height) / 2) - 1)
		left = math.floor((vim.api.nvim_get_win_width(curr_win_id) - width) / 2)
	else
		top = math.floor(((vim.o.lines - height) / 2) - 1)
		left = math.floor((vim.o.columns - width) / 2)
	end

	local opts = {
		relative = "editor",
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
	vim.cmd(string.format("autocmd WinLeave <buffer> silent! execute 'bdelete! %s'", bufnr))

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, strings)

	return {
		bufnr = bufnr,
		win_id = win_id,
	}
end

function M.pickBuffers()
	local ESCAPE = 27
	local CHARS = {'1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd',
		'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
		'u', 'v', 'w', 'x', 'y', 'z'}

	local function get_editable_buffers()
		local result = {}
		local strings = {}
		local index = 1
		for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_option(bufnr, "modifiable") then
				result[CHARS[index]] = bufnr
				table.insert(strings, string.format('%s: %s', CHARS[index], vim.api.nvim_buf_get_name(bufnr)))
				index = index + 1
			end
		end
		return result, strings
	end

	local buffers, strings = get_editable_buffers()
	local tbl = openCenteredFloat(strings, {rel = false})

	vim.defer_fn(function()
		local char = nil
		while char == nil do
			char = vim.fn.getchar()
			if char == ESCAPE then
				vim.api.nvim_win_close(tbl.win_id, true)
				return
			end
			print(char)
			if ((char >= 97 and char <= 122) or (char >= 49 and char <=57)) then
				local selected = buffers[string.char(char)]
				char = selected
				if selected then
					vim.api.nvim_win_close(tbl.win_id, true)
					vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), selected)
					return
				end
			else 
				char = nil
			end
		end
	end, 0)
end

return M
