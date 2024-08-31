local M = {}

local settings = require("toolkit.settings")

function M.setup(config)
	if config then
		settings.set(config)
	end
	if settings.current.go.enable then
		M.go_register(settings.current.go)
	end
end

function M.go_register(config)
	if config.enable ~= true or #config.enable_cmds == 0 then
		return
	end

	if config.auto_install then
		require("toolkit.filetypes.go").install_deps()
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
		["AddTags"] = function()
			vim.api.nvim_create_autocmd("FileType", {
				group = toolkit_go_group,
				pattern = "go",
				command = "command! -bar -nargs=+ -buffer -range AddTags <line1>,<line2>lua require('toolkit.filetypes.go').tags_add_lines(<f-args>,<line1>,<line2>)",
			})
		end,
		["DelTags"] = function()
			vim.api.nvim_create_autocmd("FileType", {
				group = toolkit_go_group,
				pattern = "go",
				command = "command! -bar -nargs=+ -buffer -range DelTags <line1>,<line2>lua require('toolkit.filetypes.go').tags_remove_lines(<f-args>,<line1>,<line2>)",
			})
		end,
		["ClearTags"] = function()
			vim.api.nvim_create_autocmd("FileType", {
				group = toolkit_go_group,
				pattern = "go",
				command = "command! -bar -nargs=0 -buffer -range ClearTags <line1>,<line2>lua require('toolkit.filetypes.go').tags_clear_lines(<line1>,<line2>)",
			})
		end,
		["AddTagOpts"] = function()
			vim.api.nvim_create_autocmd("FileType", {
				group = toolkit_go_group,
				pattern = "go",
				command = "command! -bar -nargs=+ -buffer -range AddTagOpts <line1>,<line2>lua require('toolkit.filetypes.go').tags_add_opts(<f-args>,<line1>,<line2>)",
			})
		end,
		["DelTagOpts"] = function()
			vim.api.nvim_create_autocmd("FileType", {
				group = toolkit_go_group,
				pattern = "go",
				command = "command! -bar -nargs=+ -buffer -range DelTagOpts <line1>,<line2>lua require('toolkit.filetypes.go').tags_remove_opts(<f-args>,<line1>,<line2>)",
			})
		end,
		["ClearTagOpts"] = function()
			vim.api.nvim_create_autocmd("FileType", {
				group = toolkit_go_group,
				pattern = "go",
				command = "command! -bar -nargs=0 -buffer -range ClearTagOpts <line1>,<line2>lua require('toolkit.filetypes.go').tags_clear_opts(<line1>,<line2>)",
			})
		end,
	}

	for _, v in pairs(config.enable_cmds) do
		local fn = map[v]
		if type(fn) == "function" then
			fn()
		end
	end
end

return M
