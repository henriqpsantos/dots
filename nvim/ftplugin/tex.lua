vim.opt_local.wrap = false
vim.opt_local.textwidth = 80

function setMainFile(file)
	_G.tex_main_file = file
	print(file)
end

cmd = [[pdflatex -aux-directory=BUILD % --draftmode -interaction=batchmode --file-line-error]]
-- vim.keymap.set('n', 'çç', function() require('toggleterm').exec_command([[cmd=]]..cmd) end, {silent = true, buffer = true})
-- vim.keymap.set('n', 'çç', )


