local M = {}

local DEFAULT_SETTINGS = {
	go = {
		enable = true,
		auto_install = true,
		enable_cmds = {
			"GenSwag",
			"FillStruct",
			"JsonToGo",
			"YamlToGo",
			"AddTags",
			"DelTags",
			"ClearTags",
			"AddTagOpts",
			"DelTagOpts",
			"ClearTagOpts",
		},
		tags_transform = "snakecase", -- options: [snakecase, camelcase, lispcase, pascalcase, titlecase, keep]
	},
}

M.DEFAULT_SETTINGS = DEFAULT_SETTINGS
M.current = M.DEFAULT_SETTINGS

function M.set(opts)
	M.current = vim.tbl_deep_extend("force", vim.deepcopy(M.current), opts)
end

return M
