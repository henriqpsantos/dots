
require'util'.buf_map('n', '<localleader>b', ':luafile %<CR>')
require'util'.buf_map('n', '<localleader>r', ':lua require("prog").unload_module(vim.fn.expand("%:t:r"), true)<CR>', s)
vim.opt_local.foldmethod = 'marker'
