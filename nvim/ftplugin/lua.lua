vim.keymap.set('n', 'çç', ':luafile %<CR>', {silent = true, buffer = true})
vim.keymap.set('n', '<localleader>r', function() require("prog").unload_module(vim.fn.expand("%:t:r"), true) end, {silent = true, buffer = true})
vim.opt_local.foldmethod = 'marker'
