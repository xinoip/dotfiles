local ts_update = function()
    vim.cmd("TSUpdate")
end

Pio.on_pack_change("nvim-treesitter", { "update" }, ts_update, ":TSUpdate")

local parsers = {
    "vimdoc",
    "markdown",
    "asm",
    "awk",
    "bash",
    "bitbake",
    "c",
    "caddy",
    "cmake",
    "comment",
    "cpp",
    "css",
    "csv",
    "dart",
    "diff",
    "dockerfile",
    "doxygen",
    "editorconfig",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "glsl",
    "go",
    "gomod",
    "gosum",
    "gpg",
    "html",
    "ini",
    "javascript",
    "jsdoc",
    "json",
    "json5",
    "kitty",
    "lua",
    "make",
    "markdown",
    "proto",
    "python",
    "regex",
    "rust",
    "scss",
    "sql",
    "squirrel",
    "ssh_config",
    "toml",
    "typescript",
    "xml",
    "yaml",
    "yang",
    "zsh",
}

local isnt_installed = function(lang)
    return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
end

local to_install = vim.tbl_filter(isnt_installed, parsers)
if #to_install > 0 then
    require("nvim-treesitter").install(to_install)
end

local filetypes = {}
for _, lang in ipairs(parsers) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
        table.insert(filetypes, ft)
    end
end

local ts_start = function(ev)
    vim.treesitter.start(ev.buf)
end

Pio.create_autocmd("Start tree-sitter", "FileType", filetypes, ts_start)
