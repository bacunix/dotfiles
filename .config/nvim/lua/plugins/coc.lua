return {
  {
    "neoclide/coc.nvim",
    branch = "release",
    config = function()
      -- Tắt backup để tránh lỗi với một số language server
      vim.opt.backup = false
      vim.opt.writebackup = false

      -- Giảm thời gian cập nhật để cải thiện UX
      vim.opt.updatetime = 300

      -- Hiển thị signcolumn cố định để tránh nhảy layout
      vim.opt.signcolumn = "yes"

      local keyset = vim.keymap.set

      -- Check backspace để xử lý Tab
      function _G.check_back_space()
        local col = vim.fn.col('.') - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
      end
      -- Mapping cho Tab / Shift-Tab / Enter
      local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
      keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
      keyset("i", "<S-TAB>", 'coc#pum#visible() ? coc#pum#prev(1) : "<C-h>"', opts)
      -- Fix Enter không hoạt động trong tmux
      keyset("i", "<CR>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>"]], opts)

      -- Di chuyển giữa các lỗi
      keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
      keyset("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})
    end,
  }
}

