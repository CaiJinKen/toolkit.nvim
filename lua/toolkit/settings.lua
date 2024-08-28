local M = {}

local DEFAULT_SETTINGS = {
	go = {
		enabled = true,
		enabled_cmds = {
			"GenSwag",
			"FillStruct",
			"JsonToGo",
			"YamlToGo",
		},
	},
}

M.DEFAULT_SETTINGS = DEFAULT_SETTINGS
M.current = M.DEFAULT_SETTINGS

function M.set(opts)
	M.current = vim.tbl_deep_extend("force", vim.deepcopy(M.current), opts)
end

return M
