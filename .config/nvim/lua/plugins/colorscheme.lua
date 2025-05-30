return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "night", -- "night", "storm", "day", "moon"
    transparent = true, -- Bật transparent background
    styles = {
      sidebars = "transparent", -- Transparent cho sidebar (như NvimTree)
      floats = "transparent", -- Transparent cho floating windows
    },
  },
}
