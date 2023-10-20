local D = require("USER.modules.utils.dir")

return {
  {
    -- "wuelnerdotexe/vim-astro",
    dir = D.plugin .. "vim-astro",
    ft = "astro",
    config = function()
      vim.cmd([[let g:astro_typescript = "enable"]])
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    pin = true,
    lazy = false,
    config = function()
      require("nvim-treesitter.configs").setup({
        -- For "nvim-ts-context-commentstring"
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        },

        -- list of parsers to ignore installing (for "all")
        ignore_install = { "css" },
        -- enable syntax highlighting
        highlight = {
          enable = true,                  -- false will disable the whole extension
          disable = function(lang, bufnr) -- Disable in large C++ buffers
            local file = (lang == "markdown" and vim.api.nvim_buf_line_count(bufnr) > 500)
            return file
          end,
        },
        -- enable indentation
        indent = {
          enable = true,
          disable = { "python", "shell" }
        },
        -- enable autotagging (w/ nvim-ts-autotag plugin)
        autotag = { enable = true },
        -- ensure these language parsers are installed
        ensure_installed = {
          "astro",
          "bash",
          "go",
          "html",
          "java",
          "javascript",
          "lua",
          "markdown",
          "markdown_inline",
          "php",
          "python",
          "sql",
          "typescript",
        },
        -- auto install above language parsers
        auto_install = false,
      })
    end
  }
}
