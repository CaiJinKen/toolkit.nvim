local M = {
	urls = {
		gomodifytags = "github.com/fatih/gomodifytags",
		fillstruct = "github.com/CaiJinKen/fillstruct",
		gojson = "github.com/ChimeraCoder/gojson",
	},
}

local f = require("toolkit.file")
local log = require("toolkit.log")
local conf = require("toolkit.settings")
local spec = require("toolkit.go_spec")

-- install pkg
function M.async_install(pkg)
	local cmd = "go install " .. M.urls[pkg] .. "@latest"
	log.info({ "installing", pkg })

	local function on_exit(job_id, exit_code, event)
		if exit_code == 0 then
			log.info({ pkg, "install success!" })
		else
			log.error({ pkg, "install failed!" })
		end
	end

	local job_id = vim.fn.jobstart(cmd, {
		on_exit = on_exit,
		stdout_buffered = true,
	})

	if job_id <= 0 then
		log.error({ "run install", pkg, "job failed!" })
	end
end

-- install dependencies
function M.install_deps()
	for pkg, _ in pairs(M.urls) do
		if f.is_executable(pkg) ~= true then
			M.async_install(pkg)
		end
	end
end

function M.exec_check_failed(program)
	if f.is_executable(program) ~= true then
		log.error({ program, "not exist or executable." })
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
		"!gojson -subStruct",
		"-fmt " .. format,
		"-name " .. f.remove_extension(name),
	}

	local package_name = spec.current_package_name()
	print("package_name", package_name)
	if not package_name or type(package_name) ~= "string" then
		package_name = spec.fix_package_name(f.get_current_buffer_parent_name())
	end
	table.insert(cmd, "-pkg " .. package_name)

	vim.cmd(tostring(firstline) .. "," .. tostring(lastline) .. " " .. table.concat(cmd, " "))
end

function M.tags_opt(params)
	local cmd = {
		"!gomodifytags",
		"-file " .. vim.fn.expand("%"),
		"-transform " .. conf.current.go.tags_transform,
	}
	for _, v in pairs(params) do
		table.insert(cmd, v)
	end
	vim.cmd("%" .. table.concat(cmd, " "))
end

-- add tags to lines in range
-- eg : json,yaml
function M.tags_add_lines(tags, firstline, lastline)
	if type(tags) ~= "string" then
		return
	end

	if #tags == 0 then
		tags = "json"
	end

	M.tags_opt({
		"-line " .. tostring(firstline) .. "," .. tostring(lastline),
		"-add-tags " .. tags,
	})
end

-- clear tags to lines in range
function M.tags_clear_lines(firstline, lastline)
	M.tags_opt({
		"-line " .. tostring(firstline) .. "," .. tostring(lastline),
		"-clear-tags",
	})
end

-- remove tags on the line
function M.tags_remove_lines(tags, firstline, lastline)
	M.tags_opt({
		"-line " .. tostring(firstline) .. "," .. tostring(lastline),
		"-remove-tags " .. tags,
	})
end

-- add options to tags
function M.tags_add_opts(opts, firstline, lastline)
	M.tags_opt({
		"-line " .. tostring(firstline) .. "," .. tostring(lastline),
		"-add-options " .. opts,
	})
end

-- clear all tas`s options
function M.tags_clear_opts(firstline, lastline)
	M.tags_opt({
		"-line " .. tostring(firstline) .. "," .. tostring(lastline),
		"-clear-options",
	})
end

-- remove tags` options
function M.tags_remove_opts(opts, firstline, lastline)
	M.tags_opt({
		"-line " .. tostring(firstline) .. "," .. tostring(lastline),
		"-remove-options " .. opts,
	})
end

return M
