-- Run file in terminal
vim.keymap.set('n', 'çç', ':TermExec cmd="python %"<CR>', {silent = true, buffer = true})

--> NOTE: Buffer local commands for opening Jupyter and using isort to sort imports
vim.cmd('command! -buffer JPC :vs | terminal jupyter-console.exe<CR>') 
vim.cmd('command! -buffer Isort :lua require("prog").run_job("isort " .. vim.fn.expand("%"))<CR>') 

