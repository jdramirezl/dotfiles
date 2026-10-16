local group = vim.api.nvim_create_augroup("UserConfig", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = group,
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "help", "man", "qf", "checkhealth" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, desc = "Close window" })
  end,
})

vim.api.nvim_create_autocmd("BufReadPre", {
  group = group,
  callback = function(event)
    local ok, stat = pcall((vim.uv or vim.loop).fs_stat, event.file)
    if ok and stat and stat.size > 1024 * 1024 then
      vim.b[event.buf].bigfile = true
    end
    if event.file:match("^%a[%w+.-]*://") or vim.env.SSH_CONNECTION then
      vim.b[event.buf].remote_file = true
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "dashboard", "help", "lazy", "mason", "NvimTree", "snacks_dashboard", "trouble" },
  callback = function(event)
    vim.b[event.buf].miniindentscope_disable = true
  end,
})
