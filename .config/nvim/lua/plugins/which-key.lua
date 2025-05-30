-- Thêm vào file config của LazyVim (thường là ~/.config/nvim/lua/config/which-key.lua hoặc tương tự)
return {
  "folke/which-key.nvim",
  opts = {
    -- Tắt thông báo register
    register = {
      enable = false, -- Tắt hoàn toàn
      silent = true,  -- Hoặc chỉ tắt thông báo nhưng vẫn register
    }
  }
}
