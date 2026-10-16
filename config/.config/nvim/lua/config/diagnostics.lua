local icons = {
  ERROR = " ",
  WARN = " ",
  INFO = " ",
  HINT = "󰌵 ",
}

vim.diagnostic.config({
  severity_sort = true,
  signs = { text = icons },
  underline = true,
  update_in_insert = false,
  virtual_text = {
    current_line = true,
    spacing = 2,
    source = "if_many",
  },
  float = {
    border = "rounded",
    focusable = true,
    source = "if_many",
  },
})

return icons
