local set = vim.keymap.set

set("n", "<leader>fe", function()
	if not MiniFiles.close() then
		local path = vim.api.nvim_buf_get_name(0)
		MiniFiles.open(path, false)
	end
	end
)

set("n", "<leader>fr", function()
	MiniExtra.pickers.oldfiles()
end, { desc = "recent files" })

set("n", "L", vim.cmd.bnext, { silent = true })
set("n", "H", vim.cmd.bprevious, { silent = true })

set("n", ",w", vim.cmd.wa)
set("n", ",q", vim.cmd.q)
set("n", "U", vim.cmd.redo, { silent = true} )

-- (close) Other Buffers
set("n", "<leader>bo", function()
 local current_buf = vim.fn.bufnr()
 local current_win = vim.fn.win_getid()
 local bufs = vim.fn.getbufinfo({ buflisted = 1 })

 for _, buf in ipairs(bufs) do
  if buf.bufnr ~= current_buf then
   pcall(MiniBufremove.delete, buf.bufnr)
  end
 end

 vim.fn.win_gotoid(current_win)
end)

set("n", "<leader>bd", vim.cmd.bd, { desc = "buffer delete" })

