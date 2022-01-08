local s = {silent = true}
require'util'.buf_map('n', '<localleader>C', ':JupyterConnect<CR>', s)
require'util'.buf_map('n', '<localleader>c', ':JupyterSendCode "%matplotlib qt5"<CR>', s)
require'util'.buf_map('n', '<localleader>d', ':JupyterCd .<CR>', s)
require'util'.buf_map('n', '<localleader>b', ':JupyterSendCell<CR>', s)

--> NOTE: Buffer local commands for opening Jupyter and using isort to sort imports
vim.cmd('command! -buffer JPC :vs | terminal jupyter-console.exe<CR>') 
vim.cmd('command! -buffer Isort :lua require("prog").run_job("isort " .. vim.fn.expand("%"))<CR>') 

-- vim.cmd('au DirChanged *.py JupyterCd expand(v:event["cwd"])<CR>')

