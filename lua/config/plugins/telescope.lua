local M = {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'}
    },
    config = function()
        require('telescope').setup({
            extensions = {
                fzf = {}
            },
            pickers = {
                find_files = {
                    hidden = true -- Увімкнення пошуку прихованих файлів
                }
            }
        })
        require('telescope').load_extension('fzf')

        -- key maps
        vim.keymap.set("n", "<leader>fd", function()
            require('telescope.builtin').find_files({ hidden = true }) -- Гаряча клавіша також показує приховані файли
        end)

        -- Перевіряємо, чи існує `multigrep.lua`
        pcall(function()
            require("config.plugins.telescope.multigrep").setup()
        end)
    end
}

return M
