vim.keymap.set('n', '<F12>', function() require("prog").get_matching_file() end, {silent = true, buffer = true})
