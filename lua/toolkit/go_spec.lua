local M = {}

function M.get_spec_name(find_partten, name_partten)
	local buf = vim.api.nvim_get_current_buf()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local line_num = cursor[1]

	local name = nil
	for i = line_num, 1, -1 do
		local line = vim.api.nvim_buf_get_lines(buf, i - 1, i, false)[1]
		if line:match(find_partten) then
			name = line:match(name_partten)
			break
		end
	end
	return name
end
-- get struct name where the coursor location
function M.current_struct_name()
	return M.get_spec_name("^%s*type%s+%w+%s+struct%s*{", "^%s*type%s+(%w+)%s+struct%s*{")
end

-- get func name where the coursor location
function M.current_func_name()
	return M.get_spec_name("^%s*func%s+", "^%s*func%s+[%w%*%s%(%)]*%s*([%w_]+)%s*%(")
end

return M
