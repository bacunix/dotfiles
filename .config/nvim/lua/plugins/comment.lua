return {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup({
            -- Add a space between the comment and the line
            padding = true,
            -- Whether the cursor should stay at its position
            sticky = true,
            -- Lines to be ignored while (un)comment
            ignore = nil,
            -- LHS of toggle mappings in NORMAL mode
            toggler = {
                line = 'gcc',  -- Line-comment toggle keymap
                block = 'gbc', -- Block-comment toggle keymap
            },
            -- LHS of operator-pending mappings in NORMAL and VISUAL mode
            opleader = {
                line = 'gc',   -- Line-comment keymap
                block = 'gb',  -- Block-comment keymap
            },
            -- LHS of extra mappings
            extra = {
                above = 'gcO', -- Add comment on the line above
                below = 'gco', -- Add comment on the line below
                eol = 'gcA',   -- Add comment at the end of line
            },
            -- Enable keybindings
            mappings = {
                basic = true,  -- Operator-pending mapping
                extra = true,  -- Extra mappings
            },
            -- Hooks (optional)
            pre_hook = nil,
            post_hook = nil,
        })
    end
}

