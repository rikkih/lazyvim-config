return {
  {
    "mfussenegger/nvim-jdtls",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    ft = { "java" },
    config = function()
      local jdtls = require("jdtls")
      local mason_registry = require("mason-registry")
      local home = os.getenv("HOME")

      local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

      local java_debug_pkg = mason_registry.get_package("java-debug-adapter")
      local java_debug_path = java_debug_pkg:get_install_path()

      local bundles = {
        vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", 1),
      }

      local config = {
        cmd = { "jdtls", "-data", workspace_folder },
        root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
        settings = {
          java = {
            contentProvider = { preferred = "fernflower" },
            saveActions = { organizeImports = true },
            signatureHelp = { enabled = true },
          },
        },
        init_options = {
          bundles = bundles,
        },
        on_attach = function(client, bufnr)
          -- Now safe to call these because the LSP is active
          jdtls.setup_dap({ hotcodereplace = "auto" })
          require("jdtls.dap").setup_dap_main_class_configs()
        end,
      }

      jdtls.start_or_attach(config)

      -- Initialize dapui after everything else is set up
      require("dapui").setup()

      -- Set up dap-ui
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
