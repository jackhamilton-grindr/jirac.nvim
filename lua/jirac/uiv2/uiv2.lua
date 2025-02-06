local n = require("nui-components")
-- local Panel = require("jirac.uiv2.panel")
local IssuesTable = require("jirac.uiv2.issues_table")

local M = {}

local renderer = n.create_renderer({
    width = 50,
    height = 30,
})

renderer:add_mappings({
    {
        mode = { "n", "i" },
        from = "q",
        to = function()
            renderer:close()
        end,
    },
})

local signal = n.create_signal({
    issues = {},
})

local body = function()
    return n.rows (
        IssuesTable({
            signal,
            border_style = 'rounded',
            border_label = {
                text = "Issues",
                align = "center",
            },
        })
    )
    -- return Panel({
    --   border_style = 'rounded',
    --   border_label = {
    --     text = "panel",
    --     align = "center",
    --   },
    --   autofocus = true,
    -- })
end

function M.display()
    renderer:render(body)
end

return M
