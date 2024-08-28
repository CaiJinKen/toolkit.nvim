local M = {}

local settings = require("toolkit.settings")

function M.setup(config)
	if config then
		settings.set(config)
	end
	if settings.current.go.enabled then
		M.go_register(settings.current.go)
	end
end

function M.go_register(config)
	if config.enabled ~= true or #config == 0 then
		return
	end

	local toolkit_go_group = vim.api.nvim_create_augroup("toolkit_go_group", { clear = true })

	local map = {
		["GenSwag"] = function()
			vim.api.nvim_create_autocmd("FileType", {
				group = toolkit_go_group,
				pattern = "go",
				command = "command! -bar -nargs=0 -buffer -range=% GenSwag lua require('toolkit.filetypes.go').gen_swagger()",
			})
		end,
		["FillStruct"] = function()
			vim.api.nvim_create_autocmd("FileType", {
				group = toolkit_go_group,
				pattern = "go",
				command = "command! -bar -nargs=0 -buffer -range=% FillStruct lua require('toolkit.filetypes.go').fill_struct()",
			})
		end,
		["JsonToGo"] = function()
			vim.api.nvim_create_autocmd("FileType", {
				group = toolkit_go_group,
				pattern = "go",
				command = "command! -bar -nargs=0 -buffer -range=% JsonToGo <line1>,<line2>lua require('toolkit.filetypes.go').to_struct('json',<line1>, <line2>)",
			})
		end,
		["YamlToGo"] = function()
			vim.api.nvim_create_autocmd("FileType", {
				group = toolkit_go_group,
				pattern = "go",
				command = "command! -bar -nargs=0 -buffer -range=% YamlToGo <line1>,<line2>lua require('toolkit.filetypes.go').to_struct('yaml',<line1>, <line2>)",
			})
		end,
	}

	for _, v in pairs(config) do
		local fn = map[v]
		if type(fn) == "function" then
			fn()
		end
	end
end

return M
