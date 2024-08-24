local M = {}

function M.setup(conf)
	M.go_register()
end

function M.go_register()
	local toolkit_go_group = vim.api.nvim_create_augroup("toolkit_go_group", { clear = true })

	vim.api.nvim_create_autocmd("FileType", {
		group = toolkit_go_group,
		pattern = "go",
		command = "command! -bar -nargs=0 -buffer -range=% GenSwag lua require('toolkit.filetypes.go').gen_swagger()",
	})

	vim.api.nvim_create_autocmd("FileType", {
		group = toolkit_go_group,
		pattern = "go",
		command = "command! -bar -nargs=0 -buffer -range=% FillStruct lua require('toolkit.filetypes.go').fill_struct()",
	})

	vim.api.nvim_create_autocmd("FileType", {
		group = toolkit_go_group,
		pattern = "go",
		command = "command! -bar -nargs=0 -buffer -range=% JsonToGo <line1>,<line2>lua require('toolkit.filetypes.go').to_struct('json',<line1>, <line2>)",
	})
end

return M
