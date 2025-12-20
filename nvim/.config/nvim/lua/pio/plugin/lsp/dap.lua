return {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
        {
            "leoluz/nvim-dap-go",
            config = function()
                require("dap-go").setup()
            end,
        },
    },
    config = function()
        local dap, dapui = require("dap"), require("dapui")

        dapui.setup({
            controls = {
                icons = {
                    disconnect = "",
                    pause = "",
                    play = " F5",
                    run_last = "",
                    step_back = " F9",
                    step_into = " F6",
                    step_out = " F8",
                    step_over = " F7",
                    terminate = " F12",
                },
            },
        })

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { desc = "DAP: " .. desc })
        end

        map("<F3>", dap.toggle_breakpoint, "Toggle Breakpoint")
        map("<F4>", dap.pause, "Pause")
        map("<F5>", dap.continue, "Debug")
        map("<F6>", dap.step_into, "Step Into")
        map("<F7>", dap.step_over, "Step Over")
        map("<F8>", dap.step_out, "Step Out")
        map("<F9>", dap.step_back, "Step Back")
        map("<F12>", dap.terminate, "Terminate")
    end,
}
