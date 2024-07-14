vim.g.mapleader = " "

vim.keymap.set('n', '<leader>b', vim.cmd.Ex)
vim.opt.clipboard:append { 'unnamed', 'unnamedplus' }
vim.api.nvim_set_keymap('n', 'y', '"+y', { noremap = true })

vim.keymap.set('n', '<leader>v', ':vsplit<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>s', ':split<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<MS-Right>', ':wincmd R<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<MS-Left>', ':wincmd L<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Right>', ':tabnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Left>', ':tabprevious<CR>', { noremap = true, silent = true })

vim.keymap.set('i', '<CR>', 'pumvisible() ? "<C-y>" : "<CR>"', { expr = true, noremap = true, silent = true })
