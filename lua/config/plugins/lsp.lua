return {
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
        "j-hui/fidget.nvim",
        "nvim-treesitter/nvim-treesitter", -- Added for better syntax highlighting
    },
    config = function()
        -- Setup fidget for LSP progress
        require("fidget").setup()

        -- Setup mason for managing LSP servers
        require("mason").setup()

        -- Setup nvim-treesitter for syntax highlighting
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "go", "html" }, -- Install parsers for Go and HTML
            auto_install = true,
            highlight = {
                enable = true, -- Enable syntax highlighting
            },
        })

        -- Define LSP configurations with custom settings
        local lspconfig = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        local servers = {
            gopls = {
                settings = {
                    gopls = {
						completeUnimported= true,
                        analyses = {
                            unusedparams = true,
                        },
                        staticcheck = true,
                        gofumpt = true,
                    },
                },
                on_attach = function(client, bufnr)
                    -- Disable LSP formatting (use goimports/gofumpt via autocmd)
                    client.server_capabilities["documentFormattingProvider"] = false
                    client.server_capabilities["documentRangeFormattingProvider"] = false

                    -- Go-specific keybinding for organizing imports
                    vim.keymap.set("n", "<leader>gi", function()
                        vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
                    end, { buffer = bufnr, desc = "Organize Go imports" })
                end,
            },
            lua_ls = {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" }, -- Recognize Neovim globals
                        },
                    },
                },
            },
            rust_analyzer = {},
            html = {}, -- Added for HTML support
        }

        -- Configure mason-lspconfig with custom handlers
        require("mason-lspconfig").setup({
            ensure_installed = { "gopls", "lua_ls", "rust_analyzer", "html" }, -- Added html
            handlers = {
                function(server_name)
                    local opts = servers[server_name] or {}
                    opts.capabilities = capabilities
                    lspconfig[server_name].setup(opts)
                end,
            },
        })

        -- Setup nvim-cmp for autocompletion
        local cmp = require("cmp")
        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            mapping = {
                ["<Tab>"] = cmp.mapping.select_next_item(),
                ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
            },
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "path" },
            }, {
                { name = "buffer" },
            }),
        })

        -- Setup command-line completions
        cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })

        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" },
            }, {
                { name = "cmdline" },
            }),
        })

        -- Define LSP keybindings and diagnostic settings
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local buf = args.buf
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client.server_capabilities["definitionProvider"] then
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Go to definition" })
                end
                if client.server_capabilities["hoverProvider"] then
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buf, desc = "Show hover info" })
                end
                if client.server_capabilities["documentFormattingProvider"] then
                    vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { buffer = buf, desc = "Format buffer" })
                end
            end,
        })

        -- Configure diagnostic display
        vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            update_in_insert = false,
        })

        -- Setup goimports and formatting for Go files on save
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.go",
            callback = function()
                local params = vim.lsp.util.make_range_params()
                params.context = { only = { "source.organizeImports" } }
                local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
                for _, res in pairs(result or {}) do
                    for _, r in pairs(res.result or {}) do
                        if r.edit then
                            vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
                        end
                    end
                end
                vim.lsp.buf.format({ async = false })
            end,
            desc = "Organize imports and format Go files on save",
        })
    end,
}
