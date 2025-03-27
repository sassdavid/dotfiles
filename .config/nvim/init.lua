-- Global variables.
MAP = vim.keymap.set
DEL = vim.keymap.del

-- Clipboard configuration.
require("config.clipboard")

-- Bootstrap lazy.nvim, LazyVim and your plugins.
require("config.lazy")
