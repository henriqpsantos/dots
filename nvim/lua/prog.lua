local M = {}

function M.make() --{{{
	local lines = {""}

	local makeprg = vim.api.nvim_get_option("makeprg")

	if not makeprg then return end

	local cmd = vim.fn.expandcmd(makeprg)
	local function on_stdX(job_id, data, event)
		if data then
			vim.list_extend(lines, data)
		end
	end

	local function on_exit(job_id, data, event)
			vim.fn.setqflist({}, " ", {
			title = cmd,
			lines = lines,
			efm = vim.api.nvim_get_option("errorformat")
		})
		vim.api.nvim_command("doautocmd QuickFixCmdPost")
		vim.api.nvim_command("cw")
		build_running = nil
		make_done = true
	end

	if build_running then
		vim.fn.jobstop(build_running)
		print('stopping previous make command')
	end

	print("starting make")
	make_done = false
	build_running = vim.fn.jobstart(
		cmd,
		{
			on_stderr = on_stdX,
			on_stdout = on_stdX,
			on_exit = on_exit,
			stdout_buffered = true,
			stderr_buffered = true,
		})
end
--}}}

function M.run_job(cmd, job_opts)--{{{
	if last_build then vim.fn.jobstop(last_build) end

	if not job_opts then
		local function ev_exit(id, data, event)
			last_build = nil
		end
		local function ev_out(id, data, event)
				for _,d in ipairs(data) do
					if d ~= "" then
						print(string.format("JOB » %s", d))
					end
				end
			end
		end

		local function ev_err(id, data, event)
			for _,d in ipairs(data) do
				if d ~= "" then
					print(string.format("ERR » %s", d))
				end
			end
		end
		-- ERR
	last_build = vim.fn.jobstart(cmd, {
		on_exit = ev_exit,
		on_stdout = ev_out,
		on_stderr = ev_err,
	})
end--}}}

function M.battery_setup(update)--{{{
	_batt = (vim.fn.systemlist('WMIC PATH Win32_Battery Get EstimatedChargeRemaining')[2]:gsub('%s*', ''))
	if (_batt == '') then
		_batt = 100
	else
		local timer = vim.loop.new_timer()
		timer:start(1, update, vim.schedule_wrap(function()
			_batt = vim.fn.systemlist('WMIC PATH Win32_Battery Get EstimatedChargeRemaining')[2]:gsub('%s*', '')
		end))
	end
end--}}}

function M.get_battery_indicator()--{{{
	local batt_tb = {' ', '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█'} 
	local battery_icon = batt_tb[math.floor((_batt) / (101 / #batt_tb)) + 1]
	return string.format('▕%s▏(%d%s', battery_icon, _batt, "%%)")
end--}}}

function M.just_progress()--{{{
	local status = {"", "", "", "", "", ""}
	local icons = {"?", "ⓙ", "✓", "🞖"}
	if build_running then
		-- _TIMER = _TIMER or vim.loop.new_timer()
		-- _TIMER:start(0, 250, 
		-- 	function()
		-- 		if __I == nil then
		-- 			__I = 1
		-- 		else
		-- 			__I = __I + 1
		-- 		end
		-- 	end)
		return status[1]
	elseif make_done then
	end
	return icons[1]
end--}}}

function M.unload_module(module, loud)--{{{
	if package.loaded[module] then
		package.loaded[module] = nil
		if loud then print('Reloaded ' .. module) end
	end
end
--}}}

function M.get_file_cursor(dir, fname)--{{{
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

function M.get_matching_file()--{{{
	local ext = vim.fn.expand('%:e')
	local f = vim.fn.expand('%:r')
	local MAP = {c = 'h',	  h = 'c',
				 cpp = 'hpp', hpp = 'cpp' }
	if not MAP[ext] then return end
	vim.cmd(':e '..f..'.'..MAP[ext])
end--}}}

function M.pick_cd(opts)--{{{
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
end--}}}

return M

