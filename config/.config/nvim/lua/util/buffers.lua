local M = {}

local function listed_buffers(filter)
  local result = {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[bufnr].buflisted and (not filter or filter(bufnr)) then
      result[#result + 1] = bufnr
    end
  end
  return result
end

local function modified(buffers)
  return vim.tbl_filter(function(bufnr)
    return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].modified
  end, buffers)
end

local function confirm_discard(buffers)
  local changed = modified(buffers)
  if #changed == 0 then
    return false, true
  end

  local names = vim.tbl_map(function(bufnr)
    local name = vim.api.nvim_buf_get_name(bufnr)
    return name == "" and "[No Name]" or vim.fn.fnamemodify(name, ":~:.")
  end, changed)
  local message = "Discard changes in " .. table.concat(names, ", ") .. "?"
  return true, vim.fn.confirm(message, "&Cancel\n&Discard", 1, "WarningMsg") == 2
end

local function delete(buffers)
  if #buffers == 0 then
    return
  end
  local force, approved = confirm_discard(buffers)
  if not approved then
    return
  end
  vim.cmd((force and "bdelete! " or "bdelete ") .. table.concat(buffers, " "))
end

function M.delete_current()
  delete({ vim.api.nvim_get_current_buf() })
end

function M.delete_others()
  local current = vim.api.nvim_get_current_buf()
  delete(listed_buffers(function(bufnr)
    return bufnr ~= current
  end))
end

function M.delete_all()
  delete(listed_buffers())
end

function M.quit_all()
  local buffers = listed_buffers()
  local force, approved = confirm_discard(buffers)
  if approved then
    vim.cmd(force and "qa!" or "qa")
  end
end

return M
