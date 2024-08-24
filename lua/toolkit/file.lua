local M = {}

-- get current work dir
function M.get_cwd()
	return vim.fn.getcwd()
end

function M.get_current_buffer_file_path()
	return vim.api.nvim_buf_get_name(0)
end

function M.get_current_buffer_file_name()
	return vim.fn.fnamemodify(M.get_current_buffer_file_path(), ":t")
end

function M.get_current_buffer_file_dir()
	return vim.fn.fnamemodify(M.get_current_buffer_file_path(), ":h")
end

function M.get_current_buffer_file_extension()
	return vim.fn.fnamemodify(M.get_current_buffer_file_path(), ":e")
end

function M.get_current_buffer_parent_name()
	return vim.fn.fnamemodify(M.get_current_buffer_file_dir(), ":t")
end

function M.remove_extension(filename_with_extension)
	return filename_with_extension:match("(.+)%..+$") or filename_with_extension
end

-- check program is exist and executable
function M.is_executable(program)
	return vim.fn.executable(program) == 1
end

return M
