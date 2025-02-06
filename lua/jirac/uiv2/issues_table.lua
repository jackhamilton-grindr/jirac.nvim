local Component = require("nui-components.component")
local Select = require("nui-components.select")
local n = require("nui-components")

local IssuesTable = Component:extend("IssuesTable")

local M = {}
local ISSUE_PAGE_SIZE = 26

M.IssuesTable = {
    current_page = 1
}

local signal = n.create_signal({
    selected = {}
})

function M.IssuesTable:get_body()
    local issue_data = {}
    for i, issue in pairs(self:get_current_value()) do
        issue_data.insert(n.option(issue.name, { id = issue.id }))
    end
    if next(issue_data) == nil then
        require("notify")("No issues")
        return n.paragraph({
            is_focusable = false,
            align = "center",
            lines = {
                n.gap(1),
                n.line("No issues!"),
                n.gap(1),
            },
        })
    end
    require("notify")("Issues")
    return Select({
        border_label = "Issues",
        selected = signal.selected,
        data = issue_data,
        multiselect = false,
        on_select = function(node)
            signal.selected = node
        end,
    })
end

function M.IssuesTable:build_nui_panel()
    return self:get_body()
end

---@class M.IssuesTableParams
---@field project_key string
---@field issues Array<Issue>?

---@param o SprintPanelParams
function M.IssuesTable:new(o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)
    return o
end

return M
