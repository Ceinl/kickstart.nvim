local M = {
  'smoka7/hop.nvim',
  version = "*",
  config = function()
    local hop = require('hop')
    local directions = require('hop.hint').HintDirection

    vim.keymap.set('n', '<leader>fj', function()
    	vim.cmd('HopWordMW')
    end, { remap = true })

    hop.setup({
      keys = 'etovxqpdygfblzhckisuran'  -- Це твої налаштування для можливих клавіш
    })
  end
}

return { M }
