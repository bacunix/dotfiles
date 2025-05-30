return {
  "nvim-lualine/lualine.nvim",
  opts = {
    options = {
      theme = "OceanicNext",  -- Sử dụng theme tokyonight để đồng bộ với colorscheme
  --     disabled_filetypes = { statusline = { "dashboard", "alpha" } }, -- Tùy chọn
  --     globalstatus = true,   -- Hiển thị một thanh statusline duy nhất cho tất cả windows
  --     component_separators = { left = '', right = '' },
  --     section_separators = { left = '', right = '' },
  --   },
  },
  -- config = function(_, opts)
  --   require('lualine').setup(opts)
  --   
  --   -- Thiết lập màu transparent
  --   vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
  --   vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
  --   
  --   -- Override các highlight groups cho Lualine
  --   local hl_groups = {
  --     "lualine_a_normal", "lualine_b_normal", "lualine_c_normal",
  --     "lualine_a_insert", "lualine_b_insert", "lualine_c_insert",
  --     "lualine_a_visual", "lualine_b_visual", "lualine_c_visual",
  --     "lualine_a_replace", "lualine_b_replace", "lualine_c_replace",
  --     "lualine_a_command", "lualine_b_command", "lualine_c_command",
  --     "lualine_a_inactive", "lualine_b_inactive", "lualine_c_inactive",
     -- }
  --   
  --   for _, hl in ipairs(hl_groups) do
  --     vim.api.nvim_set_hl(0, hl, { bg = "none" })
  -- --   end
  -- end
    }
}
