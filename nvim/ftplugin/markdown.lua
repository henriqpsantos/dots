local s = {silent = true}
require'util'.buf_map('n', '<localleader>c', ':lua require("prog").togglecb()<CR>', s)

