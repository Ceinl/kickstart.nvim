local M = {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",
	"hrsh7th/nvim-cmp",

	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",

	"j-hui/fidget.nvim"
    },
    config = function()
	require("fidget").setup()
	require("mason").setup()
	require("mason-lspconfig").setup({
	    ensure_installed = {
		"lua_ls",
		"rust_analyzer"
	    },
	    handlers = {
		function (server_name)
		    require("lspconfig")[server_name].setup {}
		end
	    }
	})

	local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },

    mapping = {
                ['<Tab>'] = cmp.mapping.select_next_item(),
                ['<S-Tab>'] = cmp.mapping.select_prev_item(),
                ['<Tab><Tab>'] = cmp.mapping.confirm({ select = true }),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
            },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' }, -- For luasnip users.
    }, {
      { name = 'buffer' },
    })
  })
    end
}

return M
