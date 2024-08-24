local M = {}

function M.set_lines(bufnr, startLine, endLine, lines)
	return vim.api.nvim_buf_set_lines(bufnr, startLine, endLine, false, lines)
end

function M.get_lines(bufnr, startLine, endLine)
	return vim.api.nvim_buf_get_lines(bufnr, startLine, endLine, true)
end

function M.fire_event(event, silent)
	local cmd = string.format("%s doautocmd <nomodeline> User %s", silent and "silent" or "", event)
	vim.api.nvim_command(cmd)
end

function M.get_buffer_variable(buf, var)
	local status, result = pcall(vim.api.nvim_buf_get_var, buf, var)
	if status then
		return result
	end
	return nil
end

--- get a table that maps a window to a view
---@see vim.fn.winsaveview()
function M.get_views_for_this_buffer()
	local windows_containing_this_buffer = vim.fn.win_findbuf(vim.fn.bufnr())
	local window_to_view = {}
	for _, w in ipairs(windows_containing_this_buffer) do
		vim.api.nvim_win_call(w, function()
			window_to_view[w] = vim.fn.winsaveview()
		end)
	end
	return window_to_view
end

--- restore view for each window
---@param window_to_view table maps window to a view
---@see vim.fn.winrestview()
function M.restore_view_per_window(window_to_view)
	for w, view in pairs(window_to_view) do
		if vim.api.nvim_win_is_valid(w) then
			vim.api.nvim_win_call(w, function()
				vim.fn.winrestview(view)
			end)
		end
	end
end

--- Find the closest node_modules path
function M.find_node_modules(dir)
	for p in vim.fs.parents(vim.fs.normalize(dir) .. "/") do
		local node_modules = p .. "/node_modules"
		if vim.fn.isdirectory(node_modules) == 1 then
			return node_modules
		end
	end
end

function M.get_node_modules_bin_path(node_modules)
	if not node_modules then
		return nil
	end

	local bin_path = node_modules .. "/.bin"
	if vim.fn.isdirectory(bin_path) ~= 1 then
		return nil
	end
	return bin_path
end

return M
