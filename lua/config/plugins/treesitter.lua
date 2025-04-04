return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", -- Keeps parsers up-to-date
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects", -- Enhances navigation (optional but recommended)
    },
    config = function()
      require("nvim-treesitter.configs").setup {
        -- List of languages to ensure are installed, including "go"
        ensure_installed = { "lua", "rust", "c_sharp", "cpp", "javascript", "go" },
        auto_install = true, -- Automatically installs parsers when opening a file

        -- Enable syntax highlighting
        highlight = {
          enable = true,
          -- Optional: Disable highlighting for large files to improve performance
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
          additional_vim_regex_highlighting = false, -- Use Treesitter highlighting exclusively
        },

        -- Enable Treesitter-based indentation
        indent = {
          enable = true,
        },

        -- Optional: Incremental selection for easier code expansion
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            node_decremental = "grm",
            scope_incremental = "grc",
          },
        },

        -- Text objects for navigation and selection
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Jumps to the next match automatically
            keymaps = {
              ["af"] = "@function.outer", -- Select around function
              ["if"] = "@function.inner", -- Select inside function
              ["ac"] = "@class.outer",    -- Select around class/struct
              ["ic"] = "@class.inner",    -- Select inside class/struct
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- Adds movements to jumplist
            goto_next_start = {
              ["]m"] = "@function.outer", -- Jump to next function
              ["]]"] = "@class.outer",    -- Jump to next class/struct
            },
            goto_previous_start = {
              ["[m"] = "@function.outer", -- Jump to previous function
              ["[["] = "@class.outer",    -- Jump to previous class/struct
            },
          },
        },
      }
    end,
  },
}
