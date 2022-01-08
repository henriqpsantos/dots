local M = {}

--> NOTE: Useful for config edits where modules want to be reloaded often;
-->		Checks is module is loaded first so that no errors occur with inexistent modules
function M.unload_module(module, loud)
	if package.loaded[module] then
		package.loaded[module] = nil
		if loud then
			print('Reloaded ' .. module)
		end
	end
end

function M.run_job(cmd)
	if last_build then
		print('Job ' .. last_build .. ' is still running, forcing it to stop.')
		vim.fn.jobstop(last_build)
	end
	last_build = vim.fn.jobstart(cmd, {
		on_exit = function(id, data, event)
			last_build = nil
			print('Job done!')
		end,
		on_stdout = function(id, data, event)
			for _,d in ipairs(data) do
				if d ~= "" then
					print(string.format("JOB » %s", d))
				end
			end
		end,
		on_stderr = function(id, data, event)
			for _,d in ipairs(data) do
				if d ~= "" then
					print(string.format("ERR >> %s", d))
				end
			end
		end,
	})
end

--> go to first comment in line 
function M.goto_comment()
	local cs = (vim.bo.commentstring):gsub('%%s', '')
	local pos = vim.fn.getline('.'):find(cs, 1, true)
	if not (pos == nil) then
		vim.fn.setpos('.', {0, vim.fn.getpos('.')[2], pos + #cs, -1})
	end
end

function M.battery_setup(update)
	--> Initialize battery charge
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

--> Open file under cursor if only 1 match; show telescope options if N > 1
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

--> Toggle checkbox, only mapped in markdown
function M.togglecb()
	local line = vim.fn.getline('.')
	local no_spc = line:gsub('^%s*', '')
	--> [x] into [ ]
	if not (no_spc:match('^%- %[x%] ') == nil) then
		line = line:gsub('%- %[x%] ', '- [ ] ')
	--> [ ] into [x]
	elseif not (no_spc:match('^%- %[ %] ') == nil) then
		line = line:gsub('%- %[ %] ', '- [x] ')
	--> No checkbox 
	else
		line = line:match('^%s*') .. '- [ ] ' .. no_spc
	end
	vim.fn.setline('.', line)
end

return M

