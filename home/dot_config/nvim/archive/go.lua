return {
    {
        "fredrikaverpil/godoc.nvim",
        version = "*",
        cmd = { "GoDoc" },
        opts = {
            picker = {
                type = "snacks",
            },
        },
    },
    {
        "olexsmir/gopher.nvim",
        ft = "go",
        ---@type gopher.Config
        opts = {
            gotag = {
                transform = "camelcase",
            },
        },
    },
}
