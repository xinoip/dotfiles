local gh = function(x)
    return "https://github.com/" .. x
end

vim.pack.add({
    -- Dependencies
    gh("MunifTanjim/nui.nvim"),
    gh("nvim-lua/plenary.nvim"),

    -- Theming
    gh("oskarnurm/koda.nvim"),
    gh("nvim-lualine/lualine.nvim"),

    -- Core
    gh("nvim-treesitter/nvim-treesitter"),
    gh("nvim-treesitter/nvim-treesitter-textobjects"),
    gh("nvim-mini/mini.nvim"),
    gh("folke/snacks.nvim"),
    gh("nmac427/guess-indent.nvim"),
    gh("j-hui/fidget.nvim"),
    gh("lewis6991/gitsigns.nvim"),

    -- Control
    gh("stevearc/oil.nvim"),
    gh("MagicDuck/grug-far.nvim"),
    gh("christoomey/vim-tmux-navigator"),
    gh("folke/flash.nvim"),

    -- LSP
    gh("neovim/nvim-lspconfig"),
    gh("mason-org/mason.nvim"),
    gh("mason-org/mason-lspconfig.nvim"),
    gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
    gh("stevearc/conform.nvim"),
    gh("folke/lazydev.nvim"),
    gh("saghen/blink.cmp"),
    gh("rafamadriz/friendly-snippets"),
    gh("nvim-flutter/flutter-tools.nvim"),

    -- AI
    gh("supermaven-inc/supermaven-nvim"),
})

Pio.create_cmd("PioPackList", "List installed plugins", function()
    vim.pack.update(nil, { offline = true })
end)

Pio.create_cmd("PioPackRestore", "Restore plugins", function()
    vim.pack.update(nil, { target = "lockfile" })
end)

Pio.create_cmd("PioPackUpdate", "Update plugins", function()
    vim.pack.update()
end)

Pio.create_cmd("PioPackClean", "Clean plugins", function()
    local inactive_plugins = vim.iter(vim.pack.get())
        :filter(function(x)
            return not x.active
        end)
        :map(function(x)
            return x.spec.name
        end)
        :totable()

    if #inactive_plugins > 0 then
        vim.pack.del(inactive_plugins)
        vim.notify("Cleaned " .. #inactive_plugins .. " inactive plugin(s).")
    else
        vim.notify("No inactive plugins to clean.")
    end
end)
