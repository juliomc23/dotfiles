-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.clipboard = {
  name = "win32yank",
  copy = {
    ["+"] = "/mnt/c/Users/julit/win32yank/win32yank.exe -i --crlf",
    ["*"] = "/mnt/c/Users/julit/win32yank/win32yank.exe -i --crlf",
  },
  paste = {
    ["+"] = "/mnt/c/Users/julit/win32yank/win32yank.exe -o --lf",
    ["*"] = "/mnt/c/Users/julit/win32yank/win32yank.exe -o --lf",
  },
}
