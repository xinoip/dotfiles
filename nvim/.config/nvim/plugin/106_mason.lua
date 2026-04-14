require("mason").setup()
require("mason-lspconfig").setup()

local is_go_installed = function()
    return vim.fn.executable("go") == 1
end

require("mason-tool-installer").setup({
    ensure_installed = {
        -- Lua & Vim
        "lua-language-server",
        "vim-language-server",
        "stylua",

        -- Bash
        "bash-language-server",
        "shfmt",
        "shellcheck",

        -- C/C++
        "clangd",
        "neocmakelsp",
        "cmakelang",

        -- Go & Backend
        { "gopls", condition = is_go_installed },
        { "templ", condition = is_go_installed },
        { "postgres-language-server", condition = is_go_installed },
        { "protols", condition = is_go_installed },
        { "gofumpt", condition = is_go_installed },
        { "golines", condition = is_go_installed },
        { "gomodifytags", condition = is_go_installed },
        { "gotests", condition = is_go_installed },
        { "golangci-lint", condition = is_go_installed },

        -- Python
        "isort",
        "black",
        "pyright",

        -- JS & Frontend
        "prettierd",
        "harper-ls",
        "jq",
        "goimports",
        "golines",

        -- Markdown
        "markdown-oxide",
        "rumdl",

        -- Other
        "json-lsp",
        "yaml-language-server",
        "taplo",
    },
})
