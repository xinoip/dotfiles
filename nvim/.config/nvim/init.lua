_G.Pio = {}

local pio_autocmd_group = vim.api.nvim_create_augroup("pio-auto-commands", { clear = true })
local pio_lsp_group = vim.api.nvim_create_augroup("pio-lsp", { clear = true })

Pio.create_autocmd_base = function(event, callback_or_cmd, opts)
    if type(callback_or_cmd) == "function" then
        opts.callback = callback_or_cmd
    else
        opts.command = callback_or_cmd
    end

    vim.api.nvim_create_autocmd(event, opts)
end

Pio.create_autocmd = function(desc, event, pattern, callback_or_cmd)
    local opts = {
        group = pio_autocmd_group,
        desc = desc,
        pattern = pattern,
    }

    Pio.create_autocmd_base(event, callback_or_cmd, opts)
end

Pio.create_autocmd_buffer = function(desc, event, buffer, callback_or_cmd)
    local opts = {
        group = pio_autocmd_group,
        desc = desc,
        buffer = buffer,
    }

    Pio.create_autocmd_base(event, callback_or_cmd, opts)
end

Pio.create_autocmd_lsp = function(desc, event, buffer, callback_or_cmd)
    local opts = {
        group = pio_lsp_group,
        desc = desc,
        buffer = buffer,
    }

    Pio.create_autocmd_base(event, callback_or_cmd, opts)
end

Pio.clear_autocmd_lsp = function(buffer)
    vim.api.nvim_clear_autocmds({ group = pio_lsp_group, buffer = buffer })
end

Pio.create_keymap = function(desc, mode, lhs, rhs, opts)
    opts = opts or {}
    opts.desc = desc
    vim.keymap.set(mode, lhs, rhs, opts)
end

Pio.create_cmd = function(name, desc, callback, opts)
    opts = opts or {}
    opts.desc = desc
    vim.api.nvim_create_user_command(name, callback, opts)
end

Pio.on_pack_change = function(plugin_name, kinds, callback, desc)
    local f = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then
            return
        end
        if not ev.data.active then
            vim.cmd.packadd(plugin_name)
        end
        callback()
    end
    Pio.create_autocmd(desc, "PackChanged", "*", f)
end
