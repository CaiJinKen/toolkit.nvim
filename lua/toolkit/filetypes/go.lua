local M = {}

local f = require("toolkit.file")

function M.exec_check_failed(program)
	if f.is_executable(program) ~= true then
		vim.notify(program .. " not exist or executable.", vim.log.levels.ERROR, {})
		return true
	end
	return false
end

-- go-swagger doc generator
function M.gen_swagger()
	local buf = vim.api.nvim_get_current_buf()
	local row = vim.api.nvim_win_get_cursor(0)[1]
	local lines = {
		"// FuncName     FuncDesc",
		"// @Summary     Summary",
		"// @Description Desc",
		"// @Tags        Tags",
		"// @Accept      x-www-form-urlencoded",
		"// @Accept      json",
		"// @Produce     json",
		'// @Param       1Param    header   string  true "1Pram"',
		'// @Param       2Param    path     integer true "2Pram"',
		'// @Param       3Param    query    number  true "3Pram"',
		'// @Param       4Param    query    bool    true "4Pram"',
		'// @Param       Form      formData integer true "1Pram"',
		'// @Param       Body      body     Struct  true "2Pram"',
		'// @Success     200       {object} Object  "success"',
		"// @Router      Path      [GET]",
	}
	vim.api.nvim_buf_set_lines(buf, row, row, false, lines)
end

-- fill go struct fields
function M.fill_struct()
	if M.exec_check_failed("fillstruct") then
		return
	end

	local cmd = {
		"!fillstruct",
		"-file " .. vim.fn.expand("%"),
		"-line " .. vim.fn.line("."),
		"-std-out",
		"-only-changed",
	}

	-- execute
	vim.cmd("." .. table.concat(cmd, " "))
end

-- convert json/yaml to go struct
-- @param format yaml or json(default)
-- @param firstline/lastline is position of selection
function M.to_struct(format, firstline, lastline)
	if M.exec_check_failed("gojson") then
		return
	end

	if format == "" then
		format = "json"
	end

	local name = f.get_current_buffer_file_name()

	local cmd = {
		"!gojson",
		"-fmt " .. format,
		"-name " .. f.remove_extension(name),
		"-pkg " .. f.get_current_buffer_parent_name(),
	}

	vim.cmd(tostring(firstline) .. "," .. tostring(lastline) .. " " .. table.concat(cmd, " "))
end

return M
