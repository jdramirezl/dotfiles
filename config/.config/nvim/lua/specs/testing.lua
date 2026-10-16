return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
      "mrcjkb/rustaceanvim",
      "mfussenegger/nvim-dap",
    },
    keys = {
      { "<leader>tt", function() require("neotest").summary.toggle() end, desc = "Toggle test summary" },
      { "<leader>tn", function() require("neotest").run.run() end, desc = "Run nearest test" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run test file" },
      { "<leader>ts", function() require("neotest").run.stop() end, desc = "Stop test" },
      { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Show test output" },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest test" },
    },
    opts = function()
      return {
        adapters = {
          require("neotest-python")({ runner = "pytest", dap = { justMyCode = false } }),
          require("rustaceanvim.neotest"),
        },
        output = { open_on_run = "short" },
        quickfix = { open = false },
      }
    end,
    config = function(_, opts) require("neotest").setup(opts) end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    keys = {
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle debugger UI" },
      { "<F5>", function() require("dap").continue() end, desc = "Debug continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug step into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug step out" },
      { "<leader>dB", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
    },
    opts = {},
    config = function(_, opts)
      local dap, dapui = require("dap"), require("dapui")
      local debugpy_adapter = vim.fn.exepath("debugpy-adapter")
      if debugpy_adapter == "" then
        local mason_adapter = vim.fn.stdpath("data") .. "/mason/bin/debugpy-adapter"
        if vim.fn.executable(mason_adapter) == 1 then
          debugpy_adapter = mason_adapter
        end
      end
      if debugpy_adapter ~= "" then
        dap.adapters.python = { type = "executable", command = debugpy_adapter }
      end
      dapui.setup(opts)
      dap.listeners.before.attach.dapui_config = dapui.open
      dap.listeners.before.launch.dapui_config = dapui.open
      dap.listeners.before.event_terminated.dapui_config = dapui.close
      dap.listeners.before.event_exited.dapui_config = dapui.close
    end,
  },
}
