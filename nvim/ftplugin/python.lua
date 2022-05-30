vim.keymap.set('n', '<localleader>C', ':JupyterConnect<CR>', {silent = true, buffer = true})
vim.keymap.set('n', '<localleader>c', ':JupyterSendCode "%matplotlib qt5"<CR>', {silent = true, buffer = true})
vim.keymap.set('n', '<localleader>d', ':JupyterCd .<CR>', {silent = true, buffer = true})
vim.keymap.set('n', '<localleader>b', ':JupyterSendCell<CR>', {silent = true, buffer = true})

--> NOTE: Buffer local commands for opening Jupyter and using isort to sort imports
vim.cmd('command! -buffer JPC :vs | terminal jupyter-console.exe<CR>') 
vim.cmd('command! -buffer Isort :lua require("prog").run_job("isort " .. vim.fn.expand("%"))<CR>') 

-- vim.cmd('au DirChanged *.py JupyterCd expand(v:event["cwd"])<CR>')

