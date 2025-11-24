vim.api.nvim_create_autocmd("LspAttach", {
 group = vim.api.nvim_create_augroup("my.lsp", {}),
 callback = function(args)
  local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

  if client:supports_method("textDocument/completion") then
   local chars = {}
   for i = 32, 126 do
    table.insert(chars, string.char(i))
   end
   client.server_capabilities.completionProvider.triggerCharacters = chars

   vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })

   for lhs, rhs in pairs({
    ["<tab>"] = "<c-y>",
    ["<c-j>"] = "<c-n>",
    ["<c-k>"] = "<c-p>",
    ["<cr>"] = function()
     return "<c-e>" .. MiniPairs.cr()
    end,
   }) do
    vim.keymap.set("i", lhs, function()
     if vim.fn.pumvisible() ~= 0 then
      if type(rhs) == "function" then
       return rhs()
      end

      return rhs
     end

     return lhs
    end, { expr = true, buffer = args.buf })
   end
  end
 end,
})

