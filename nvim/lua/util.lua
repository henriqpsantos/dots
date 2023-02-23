local M = {}

function M.format(file, prog_type)
	if prog_type == "cpp" then
		local clang_cfg = vim.env.XDG_CONFIG_HOME .. "/clang-format/clang-format"
		vim.fn.system(string.format("clang-format %s -i --style=file:'%s'", file, clang_cfg))
	end
	
end

function M.get_treesitter_status()--{{{
	return require'nvim-treesitter'.statusline({
			indicator_size = 100,
			type_patterns = {'class', 'function', 'method'},
			transform_fn = function(line) return line:gsub('%s*[%[%(%{]*%s*$', '') end,
			separator = ' : '})
end

-- ARRAY REMOVE FUNCTION
-- Usually an order of magnitude faster than table.remove : source ->> https://stackoverflow.com/questions/12394841 <<- 
function M.ArrayRemove(t, fnKeep)
	local j, n = 1, #t;
	for i = 1,n do
		if (fnKeep(t, i, j)) then
			-- Move i's kept value to j's position, if it's not already there.
			if (i ~= j) then
				t[j] = t[i];
				t[i] = nil;
			end
			j = j + 1;
		else
			t[i] = nil;
		end
	end
	return t;
end

return M
