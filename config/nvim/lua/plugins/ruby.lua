return {
  -- Add Sorbet to the server list
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- sorbet = {},
        ruby_lsp = {},
      },
    },
  },
}
