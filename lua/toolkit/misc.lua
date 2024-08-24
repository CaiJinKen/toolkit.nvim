local M = {}

-- return true when current is git project
function M.is_git_repo()
	local handle = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null")
	local result = handle:read("*a")
	handle:close()
	return result:match("true") ~= nil
end

-- get selection positions
function M.get_visual_selection()
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")

	local start_line = start_pos[2]
	local start_col = start_pos[3]

	local end_line = end_pos[2]
	local end_col = end_pos[3]

	return start_line, start_col, end_line, end_col
end

return M
