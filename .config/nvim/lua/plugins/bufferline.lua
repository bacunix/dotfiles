-- Thêm vào file ~/.config/nvim/lua/plugins/bufferline.lua
return {
  {
    "akinsho/bufferline.nvim",
    dependencies = { "tiagovla/scope.nvim" },
    opts = {
      options = {
        -- Các options khác của mày
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-Tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
      highlights = {
        fill = {
          bg = "NONE", -- Background transparent
        },
        background = {
          bg = "NONE", -- Background tab không active
        },
        buffer_visible = {
          bg = "NONE",
        },
        buffer_selected = {
          bg = "#3b4261", -- Màu khi tab được chọn (có thể điều chỉnh)
          bold = true,
          italic = false,
        },
        separator = {
          fg = "#1a1b26", -- Màu separator
          bg = "NONE",
        },
        separator_selected = {
          fg = "#1a1b26",
          bg = "NONE",
        },
        separator_visible = {
          fg = "#1a1b26",
          bg = "NONE",
        },
        close_button = {
          bg = "NONE",
        },
        close_button_visible = {
          bg = "NONE",
        },
        close_button_selected = {
          bg = "NONE",
        },
      },
    },
  },
}
