local Component = require("nui-components.component")

local Panel = Component:extend("Panel")

function Panel:init(props)
  Panel.super.init(
    self,
    vim.tbl_extend("force", {}, props)
  )
end

function Panel:prop_types()
  return {}
end

-- function Panel:on_layout()
--     local height = 0
--     local width = 0
--     for i, child in pairs(self:get_children()) do
--         height += child.height
--         width +=  child.width
--     end
--   return {
--     height = 1,
--     width = self:get_lines():width(),
--   }
-- end
--
return Panel
