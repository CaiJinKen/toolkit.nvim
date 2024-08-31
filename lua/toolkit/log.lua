local M = {}

-- convert param to table
function M.ensure_table(param)
	if type(param) ~= "table" then
		return { param }
	end
	return param
end

function M.log(msgs, log_level, opts)
	local params = M.ensure_table(msgs)
	if #params == 0 then
		return
	end

	vim.notify(table.concat(params, " "), log_level, opts)
end

function M.error(msgs)
	M.log(msgs, vim.log.levels.ERROR, {})
end

function M.warn(msgs)
	M.log(msgs, vim.log.levels.WARN, {})
end

function M.info(msgs)
	M.log(msgs, vim.log.levels.INFO, {})
end

function M.debug(msgs)
	m.log(msgs, vim.log.levels.DEBUG, {})
end

return M
