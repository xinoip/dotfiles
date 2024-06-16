return {
    "imNel/monorepo.nvim",
    config = function()
        require("monorepo").setup({
            -- Your config here!
            silent = true,                      -- Supresses vim.notify messages
            autoload_telescope = true,          -- Automatically loads the telescope extension at setup
            data_path = vim.fn.stdpath("data"), -- Path that monorepo.json gets saved to
        })

        vim.keymap.set("n", "<leader>m", function()
            require("telescope").extensions.monorepo.monorepo()
        end)
        vim.keymap.set("n", "<leader>n", function()
            require("monorepo").toggle_project()
        end)
    end,
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
}
