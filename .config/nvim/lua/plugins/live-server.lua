return {
    'barrett-ruth/live-server.nvim',
    build = 'pnpm add -g live-server',
    cmd = { 'LiveServerStart', 'LiveServerStop' },
    config = function()
        --[[ require("live-server").setup({
            args = { "--host=0.0.0.0" },
        }) ]]
    require("live-server").setup({
    args = { "--open=http://localhost:8080" }
    })
    end,
}

