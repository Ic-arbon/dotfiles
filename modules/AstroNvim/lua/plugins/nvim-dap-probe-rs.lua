-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
  "mfussenegger/nvim-dap",
  opts = function()
    local dap = require "dap"
    if not dap.adapters then dap.adapters = {} end
    local probe_rs = vim.fn.exepath "probe-rs"
    if probe_rs == "" then
      vim.notify("probe-rs 未找到", vim.log.levels.ERROR)
      return
    end
    dap.adapters["probe-rs-debug"] = {
      type = "server",
      port = "${port}",
      executable = {
        command = probe_rs,
        args = { "dap-server", "--port", "${port}" },
      },
    }
    -- Connect the probe-rs-debug with rust files. Configuration of the debugger is done via project_folder/.vscode/launch.json
    require("dap.ext.vscode").type_to_filetypes["probe-rs-debug"] = { "rust" }
    -- Set up of handlers for RTT and probe-rs messages.
    -- In addition to nvim-dap-ui I write messages to a probe-rs.log in project folder
    -- If RTT is enabled, probe-rs sends an event after init of a channel. This has to be confirmed or otherwise probe-rs wont sent the rtt data.
    dap.listeners.before["event_probe-rs-rtt-channel-config"]["plugins.nvim-dap-probe-rs"] = function(session, body)
      local utils = require "dap.utils"
      utils.notify(
        string.format('probe-rs: Opening RTT channel %d with name "%s"!', body.channelNumber, body.channelName)
      )
      local file = io.open("probe-rs.log", "a")
      if file then
        file:write(
          string.format(
            '%s: Opening RTT channel %d with name "%s"!\n',
            os.date "%Y-%m-%d-T%H:%M:%S",
            body.channelNumber,
            body.channelName
          )
        )
      end
      if file then file:close() end
      session:request("rttWindowOpened", { body.channelNumber, true })
    end
    -- After confirming RTT window is open, we will get rtt-data-events.
    -- I print them to the dap-repl, which is one way and not separated.
    -- If you have better ideas, let me know.
    dap.listeners.before["event_probe-rs-rtt-data"]["plugins.nvim-dap-probe-rs"] = function(_, body)
      local message =
        string.format("%s: RTT-Channel %d - Message: %s", os.date "%Y-%m-%d-T%H:%M:%S", body.channelNumber, body.data)
      local repl = require "dap.repl"
      repl.append(message)
      local file = io.open("probe-rs.log", "a")
      if file then file:write(message) end
      if file then file:close() end
    end
    -- Probe-rs can send messages, which are handled with this listener.
    dap.listeners.before["event_probe-rs-show-message"]["plugins.nvim-dap-probe-rs"] = function(_, body)
      local message = string.format("%s: probe-rs message: %s", os.date "%Y-%m-%d-T%H:%M:%S", body.message)
      local repl = require "dap.repl"
      repl.append(message)
      local file = io.open("probe-rs.log", "a")
      if file then file:write(message) end
      if file then file:close() end
    end
  end,
}
