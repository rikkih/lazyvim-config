return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "flake8",
      "java-debug-adapter",
      "java-test",
      "jdtls",
      "stylua",
      "shellcheck",
      "shfmt",
    },
  },
}
