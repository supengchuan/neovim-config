-- Interface
---@class InterfaceItem
---@field container_name string?
---@field path string
---@field line integer
---@field col integer

---@class InterfaceData
---@field name string?
---@field declaration string?
---@field real_package_name string?
---@field generic_parameters string[]?

---@class StructInfo
---@field name string?
---@field line_start integer? the struct start at line, the first line is 0
---@field line_end integer?  the struct end at line, the first line is 0
---@field generic_name string[]? the generic name list, such as T, K ...
