return {
	"xiyaowong/transparent.nvim",
	config = function()
		require("transparent").setup({
			extra_groups = {
				"Normal",
				"NormalNC",
				"TelescopeBorder",
                "Comment",
				-- "NvimTreeNormal",
				"LualineNormal",
				"FzfLuaBorder",
				"FzfLuaNormal",
				"FzfLuaTitle",
				"FzfLuaPreviewBorder",
				"FzfLuaPreviewNormal",
				"FzfLuaPreviewTitle",
                'StatusLine', 
                'StatusLineNC',
            },
		})
		-- require("transparent").clear_prefix("NeoTree")
		require("transparent").clear_prefix("lualine")
		-- depends on pc, these settings are needed
		vim.cmd("highlight Normal guibg=NONE")
		vim.cmd("highlight Lualine guibg=NONE")
		vim.cmd("highlight Lualine guifg=NONE")
		vim.cmd("highlight NormalNC guibg=NONE")
		vim.cmd("highlight CursorLine guibg=NONE")
        

        require('transparent').clear_prefix('BufferLine')

		vim.cmd("highlight Normal guibg=NONE")
        vim.cmd("highlight BufferLine guibg=NONE") 
		vim.cmd("highlight NormalNC guibg=NONE")
		vim.cmd("highlight CursorLine guibg=NONE")
	end,
}
