-- Treesitter 
return {
  { 
    "nvim-treesitter/nvim-treesitter", 
    run = ":TSUpdate",  
    config = function()
--	    
      require'nvim-treesitter.configs'.setup {
        ensure_installed = { "lua", "rust", "c_sharp", "cpp", "javascript" },  

        highlight = {
          enable = true,  
        },

        indent = {
          enable = true, 
        },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",   
            node_incremental = "grn",
            node_decremental = "grm", 
            scope_incremental = "grc",
          },
        },
      }
    end
  }
}
