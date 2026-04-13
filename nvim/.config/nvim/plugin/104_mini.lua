-- Text Editing
require("mini.ai").setup()
require("mini.move").setup()
require("mini.pairs").setup()
require("mini.surround").setup({
    mappings = {
        add = "ma",
        delete = "md",
        find = "mf",
        find_left = "mF",
        highlight = "mh",
        replace = "mr",
    },
})
require("mini.snippets").setup({
    mappings = {
        jump_next = "<Tab>",
        jump_prev = "<S-Tab>",
    },
})

-- Appearance
require("mini.icons").setup()
require("mini.indentscope").setup()
require("mini.cursorword").setup()
require("mini.statusline").setup()
require("mini.trailspace").setup()
require("mini.diff").setup({
    view = {
        -- Valid values: "number", "sign".
        style = "sign",
        signs = { add = "┃", change = "┃", delete = "_" },
    },
    mappings = {
        apply = "",
        reset = "",
        textobject = "",
        goto_first = "",
        goto_prev = "",
        goto_next = "",
        goto_last = "",
    },
})
local hipatterns = require("mini.hipatterns")
hipatterns.setup({
    highlighters = {
        -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
        hex_color = hipatterns.gen_highlighter.hex_color(),
    },
})
local miniclue = require("mini.clue")
miniclue.setup({
    triggers = {
        -- Leader triggers
        { mode = { "n", "x" }, keys = "<Leader>" },

        -- `[` and `]` keys
        { mode = "n", keys = "[" },
        { mode = "n", keys = "]" },

        -- Built-in completion
        { mode = "i", keys = "<C-x>" },

        -- `g` key
        { mode = { "n", "x" }, keys = "g" },

        -- Marks
        { mode = { "n", "x" }, keys = "'" },
        { mode = { "n", "x" }, keys = "`" },

        -- Registers
        { mode = { "n", "x" }, keys = '"' },
        { mode = { "i", "c" }, keys = "<C-r>" },

        -- Window commands
        { mode = "n", keys = "<C-w>" },

        -- `z` key
        { mode = { "n", "x" }, keys = "z" },
    },

    clues = {
        -- Enhance this by adding descriptions for <Leader> mapping groups
        miniclue.gen_clues.square_brackets(),
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
    },
})

-- Completion
local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
local process_items = function(items, base)
    return MiniCompletion.default_process_items(items, base, process_items_opts)
end

require("mini.completion").setup({
    lsp_completion = {
        -- `omnifunc` instead of `completefunc`
        source_func = "omnifunc",
        auto_setup = false,
        process_items = process_items,
    },
})
MiniIcons.tweak_lsp_kind()
