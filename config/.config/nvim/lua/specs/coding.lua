return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason.nvim", cmd = "Mason", opts = { ui = { border = "rounded" } } },
      {
        "williamboman/mason-lspconfig.nvim",
        opts = { ensure_installed = { "pyright", "rust_analyzer" }, automatic_enable = false },
      },
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts = {
          ensure_installed = { "debugpy", "prettier", "ruff", "stylua" },
          run_on_start = true,
          start_delay = 1000,
          debounce_hours = 24,
        },
      },
      "hrsh7th/cmp-nvim-lsp",
      { "j-hui/fidget.nvim", opts = { notification = { window = { winblend = 0 } } } },
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
        callback = function(event)
          if vim.b[event.buf].bigfile or vim.b[event.buf].remote_file then
            vim.lsp.buf_detach_client(event.buf, event.data.client_id)
            return
          end
          -- Neovim 0.11 installs K for LSP hover before LspAttach. Mark the
          -- filetype-provided keywordprg as explicit, then remove the initial
          -- mapping so later dynamic capability registration cannot restore it.
          if vim.bo[event.buf].keywordprg ~= "" then
            vim.bo[event.buf].keywordprg = vim.bo[event.buf].keywordprg
          end
          pcall(vim.keymap.del, "n", "K", { buffer = event.buf })
          local map = function(lhs, rhs, desc, mode)
            vim.keymap.set(mode or "n", lhs, rhs, { buffer = event.buf, silent = true, desc = desc })
          end
          map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "x" })
          map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>cs", vim.lsp.buf.signature_help, "Signature help")
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gi", vim.lsp.buf.implementation, "Go to implementation")
          map("gr", vim.lsp.buf.references, "References")
        end,
      })

      vim.lsp.config("pyright", {
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              typeCheckingMode = "basic",
              useLibraryCodeForTypes = true,
            },
          },
        },
      })
      vim.lsp.config("rust_analyzer", {
        capabilities = capabilities,
        settings = { ["rust-analyzer"] = { check = { command = "clippy" } } },
      })
      vim.lsp.enable({ "pyright", "rust_analyzer" })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip").config.setup({ history = true, updateevents = "TextChanged,TextChangedI" })
        end,
      },
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        enabled = function()
          return not vim.b.bigfile and not vim.b.remote_file and vim.b.completion ~= false
        end,
        preselect = cmp.PreselectMode.None,
        completion = { completeopt = "menu,menuone,noselect" },
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        window = { completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered() },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-y>"] = cmp.mapping.confirm({ select = false }),
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() and cmp.get_selected_entry() then cmp.confirm({ select = false }) else fallback() end
          end, { "i", "s" }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, { { name = "buffer", keyword_length = 3 } }),
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      { "<leader>cf", function()
          if vim.b.bigfile or vim.b.remote_file then
            vim.notify("Formatting is disabled for large or remote files", vim.log.levels.INFO)
            return
          end
          require("conform").format({ async = true, lsp_format = "fallback", timeout_ms = 3000 })
        end, mode = { "n", "x" }, desc = "Format file or selection" },
    },
    opts = {
      formatters_by_ft = {
        css = { "prettier" },
        graphql = { "prettier" },
        html = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        python = { "ruff_format" },
        svelte = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        yaml = { "prettier" },
      },
      format_on_save = function(bufnr)
        if vim.b[bufnr].bigfile or vim.b[bufnr].remote_file then return end
        return { timeout_ms = 3000, lsp_format = "fallback" }
      end,
      notify_on_error = true,
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "InsertLeave" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = { python = { "ruff" } }
      local group = vim.api.nvim_create_augroup("UserLint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        group = group,
        callback = function(event)
          if not vim.b[event.buf].bigfile and not vim.b[event.buf].remote_file then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
