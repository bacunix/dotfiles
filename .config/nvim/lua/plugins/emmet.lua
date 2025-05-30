return {
  "mattn/emmet-vim",
  ft = { "html", "css", "javascript", "javascriptreact", "typescriptreact", "vue", "php", "xml" },
  init = function()
    vim.g.user_emmet_leader_key = "<C-y>" -- mặc định
  end,
}
