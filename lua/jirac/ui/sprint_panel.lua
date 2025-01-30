local nui = require("nui-components")
local issue_service = require("jirac.jira_issue_service")
local project_service = require("jirac.jira_project_service")
local IssueSubmitPanel = require("jirac.ui.issue_submit_panel").IssueSubmitPanel
local IssuePanel = require("jirac.ui.issue_panel").IssuePanel

local M = {}
local ISSUE_PAGE_SIZE = 26

M.SprintPanel = {
    current_page = 1
}

function M.SprintPanel:_handle_open_issue(issue)
    self.parent:push(IssuePanel:new {
        issue_id_or_key = issue.key,
        project_key = self.project.key
    })
end

function M.SprintPanel:_handle_create_issue()
    self.parent:push(IssueSubmitPanel:new {
        project = self.project
    })
end

function M.SprintPanel:_handle_refresh_issues()
    self.search_phrase = self.parent.renderer:get_component_by_id("search-phrase"):get_current_value()
    self.parent:swap(M.SprintPanel:new {
        search_phrase = self.search_phrase,
        project_key = self.project_key
    })
end

function M.SprintPanel:_build_issues_column()
    local key_column = {}
    local summary_column = {}
    local status_column = {}
    for _, issue in ipairs(self.issues) do
        key_column[#key_column + 1] = nui.button {
            label = issue.key,
            on_press = function () self:_handle_open_issue(issue) end
        }
        summary_column[#summary_column + 1] = nui.paragraph {
            lines = issue.summary,
            max_lines = 1,
            is_focusable = false,
        }
        status_column[#status_column + 1] = nui.paragraph {
            lines = issue.status.name,
            is_focusable = false
        }
    end
    return nui.rows({ flex = 2 },
    nui.paragraph {
        lines = "Issues",
        max_lines = 1,
        is_focusable = false,
        padding = {
            bottom = 1
        },
        align = "center"
    },
    nui.columns(
        { flex = 0 },
        nui.button {
            label = "Refresh issues",
            autofocus = true,
            on_press = function () self:_handle_refresh_issues() end,
        },
        nui.gap { flex = 1 }
    ),
    #key_column > 0 and nui.columns(
        { flex = 0 },
        nui.rows(unpack(key_column)),
        nui.rows(unpack(summary_column)),
        nui.rows(unpack(status_column))
    ) or nui.gap(1),
    nui.gap { flex = 1 })
end

function M.SprintPanel:_create_field(name, value)
    return nui.rows({flex = 0},
    nui.paragraph {
        flex = 1,
        is_focusable = false,
        lines = name .. ":"
    },
    nui.paragraph {
        flex = 1,
        is_focusable = false,
        lines = value,
        padding = {
            left = 2,
            bottom = 1
        }
    })
end

function M.SprintPanel:_build_details_column()
    return nui.rows(unpack {
        self:_create_field("Key", self.project.key),
        self:_create_field("Name", self.project.name),
        nui.gap({flex = 1})
    })
end

function M.SprintPanel:build_nui_panel()
    return nui.rows(
    nui.paragraph {
        lines = self.project.key .. " " .. self.project.name,
        align = "center",
        is_focusable = false
    },
    nui.gap(1),
    nui.columns( {flex = 1},
    self:_build_issues_column(),
    self:_build_details_column()
    ))
end

function M.SprintPanel:fetch_resources(callback)
    project_service.get_project(self.project_key, function (project)
        self.project = project
        issue_service.search_open_project_work({
            max_results = ISSUE_PAGE_SIZE,
            project_key = self.project_key
        }, function (issues)
            self.issues = issues
            callback()
        end)
    end)
end

---@class SprintPanelParams : Panel
---@field project_key string
---@field issues Array<Issue>?
---@field search_phrase string?

---@param o SprintPanelParams
function M.SprintPanel:new(o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)
    o.search_phrase = o.search_phrase or ""
    return o
end

return M
