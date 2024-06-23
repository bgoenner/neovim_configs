local config = function()
  local lspconfig = require("lspconfig")

  local signs = { Error = "x", Warn = "!", Hint = "+ ", Info = "i" }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text=icon, texthl = hl, numhl = "" })
  end

  -- lua
  lspconfig.lua_ls.setup({
    

    settingings = {
      Lua = {
        -- make the lanuage server recognize "vim" global
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          -- make language server aware of runtime
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.stdpath("config") .. "/lua"] = true,
          },
        },
      },
    },
  })

  local luacheck = require("efmls-configs.linters.luacheck")
  local stylua = require("efmls-configs.formatters.stylua")

  -- configure efm server
  lspconfig.efm.setup({
    filetypes = {
      "lua",
    },
    init_options = {
      documentFormatting = true,
      documentRangeFormatting = true,
      hover = true,
      documentSymbol = true,
      codeAction = true,
      completion = true,
    },
    settings = {
      languages = {
        lua = { luacheck, stylua },
      },
    },
  })


  local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = lsp_fmt_group,
    callback = function()
      local efm = vim.lsp.get_active_clients({ name = "efm" })

      if vim.tbl_isempty(efm) then
        return
      end

      vim.lsp.buf.format({ name = "efm" })
    end,
  })
end

return {
  "neovim/nvim-lspconfig",
  config = config,
  lazy = false,
  dependencies = {
    "windwp/nvim-autopairs",
    "williamboman/mason.nvim",
    "creativenull/efmls-configs-nvim",
  },
}
