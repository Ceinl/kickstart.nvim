-- Встановлення Telescope через lazy.nvim
require('lazy').setup({
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
})

-- Підключення до Telescope після завантаження плагіна
require('telescope').setup {
  defaults = {
    prompt_prefix = "> ",
    selection_caret = "> ",
    layout_strategy = "vertical",
    layout_config = {
      preview_width = 0.5,
    },
  },
}

-- Мапінги для Telescope
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', ':Telescope live_grep<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', ':Telescope buffers<CR>', { noremap = true, silent = true })
