return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            auto_close = true,
            layout = {
              preview = true,
              layout = {
                box = "horizontal",
                width = 0.8,
                height = 0.8,
                {
                  box = "vertical",
                  border = "rounded",
                  { win = "input", height = 1, border = true, title = "{title} {live} {flags}", title_pos = "center" },
                  { win = "list" },
                },
                { win = "preview", title = "{preview}", border = "rounded", width = 0.6 },
              },
            },
          },
        },
      },
    },
  },
}
