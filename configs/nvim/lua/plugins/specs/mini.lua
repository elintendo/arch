return {
	"echasnovski/mini.nvim",
	version = "*",
	config = function()
		require("mini.pairs").setup()
		require("mini.statusline").setup()
		require("mini.files").setup({
			windows = { preview = true }
		})
		require("mini.tabline").setup()
		require("mini.pick").setup()
		require("mini.extra").setup()
		local clue = require("mini.clue")

 clue.setup({
  window = {
   delay = 0,
   config = { width = "auto" },
  },

  triggers = {
   { mode = "n", keys = "<leader>" },
   { mode = "v", keys = "<leader>" },
   { mode = "x", keys = "<leader>" },
   { mode = "n", keys = "<c-w>" },
  },

  clues = {
   clue.gen_clues.builtin_completion(),
   clue.gen_clues.windows(),
  },
 })

	end
}
