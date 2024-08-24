local M = {}

function M.quote_cmd_arg(arg)
	return string.format("'%s'", arg)
end

function M.escape_path(arg)
	return vim.fn.shellescape(arg, true)
end

function M.wrap_sed_replace(pattern, replacement, flags)
	return string.format("s/%s/%s/%s", pattern, replacement or "", flags or "")
end

return M
