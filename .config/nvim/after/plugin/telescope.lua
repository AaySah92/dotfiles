local builtin = require('telescope.builtin')
-- vim.keymap.set('n', '<leader>fp', builtin.find_files, {})
--[[ vim.keymap.set('n', '<leader>fw', function() 
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end) ]]--

vim.keymap.set('n', '<CS-n>', builtin.find_files, {})
vim.keymap.set('n', '<CS-g>', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end) 
