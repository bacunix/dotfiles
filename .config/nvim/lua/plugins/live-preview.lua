return {
    {
    'brianhuster/live-preview.nvim',
    config = function()
        -- Tự động ghi file khi thoát insert hoặc thay đổi
        vim.o.autowriteall = true

        vim.api.nvim_create_autocmd({ 'InsertLeavePre', 'TextChanged', 'TextChangedP' }, {
        pattern = '*',
        callback = function()
            vim.cmd('silent! write')
        end,
        })
    end
    }
}
