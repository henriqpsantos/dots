require("telescope.builtin").find_files({ attach_mappings = function(prompt_bufnr, map)
	local actions = require "telescope.actions"
	actions.select_default:replace(
		function(prompt_bufnr)
			local actions = require "telescope.actions"
			local state = require "telescope.actions.state"
			local picker = state.get_current_picker(prompt_bufnr)
			local multi = picker:get_multi_selection()
			local single = picker:get_selection()
			local str = ""
			if #multi > 0 then
				for i,j in pairs(multi) do
					str = str.."edit "..j[1].." | "
				end
			end
			actions.close(prompt_bufnr)
			str = str.."edit "..single[1]
			vim.api.nvim_command(str)
		end)
	return true
end })
