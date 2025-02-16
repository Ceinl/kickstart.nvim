local M = 
{
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
      	dependencies = 
		{ 
			'nvim-lua/plenary.nvim',
			{'nvim-telescope/telescope-fzf-native.nvim', build = 'make'}
		},
	config = function()
	require('telescope').setup 
	{
		extensions = 
		{
			fzf = {}
		}
	}
	require('telescope').load_extension('fzf')
	-- key maps
	vim.keymap.set("n","<leader>fd", require('telescope.builtin').find_files)
	
	require("config.plugins.telescope.multigrep").setup()

	end
}

return { M }
