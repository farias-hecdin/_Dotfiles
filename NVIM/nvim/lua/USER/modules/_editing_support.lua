local D = require("USER.modules.utils.dir")

-- SUMMARY
-- mini.splitjoin
-- mini.cursorword
-- mini.pairs
-- Comment.nvim
-- nvim-ts-context-commentstring
-- mini.hipatterns
-- ColorCommander

return {
  {
    -- url = "https://github.com/echasnovski/mini.splitjoin.git",
    dir = D.plugin .. "mini.splitjoin",
    keys = {
      { mode = "n", "gS", desc = "Split and join" }
    },
    config = function()
      require("mini.splitjoin").setup()
    end
  },
  {
    -- url = "https://github.com/echasnovski/mini.cursorword.git",
    dir = D.plugin .. "mini.cursorword",
    event = "InsertEnter",
    config = function()
      require("mini.cursorword").setup()
    end
  },
  {
    -- url = "https://github.com/echasnovski/mini.pairs.git",
    dir = D.plugin .. "mini.pairs",
    enabled = false,
    config = function()
      require("mini.pairs").setup()
    end
  },
  {
    -- url = "https://github.com/numToStr/Comment.nvim.git",
    dir = D.plugin .. "Comment.nvim",
    keys = {
      { mode = "n", ",c", desc = "Comment: Insert line" },
      { mode = "n", ",C", desc = "Comment: Insert block" },
      { mode = "v", "gc", desc = "Insert line-comment" },
      { mode = "v", "gC", desc = "Insert block-comment" }
    },
    config = function()
      require('Comment').setup({
        padding = true,
        sticky = true,
        ignore = nil,
        toggler = {
          line = ',c',
          block = ',C',
        },
        opleader = {
          line = 'gc',
          block = 'gC',
        },
        mappings = {
          basic = true,
          extra = false,
        },
        post_hook = nil,
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = function ()
      require('ts_context_commentstring').setup({
        enable_autocmd = false,
      })
    end
  },
  {
    -- url = "https://github.com/echasnovski/mini.hipatterns.git",
    dir = D.plugin .. "mini.hipatterns",
    event = "BufReadPre",
    config = function()
      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        highlighters = {
          bug      = { pattern = {"()BUG:()", "()FIX:()", "()FIXME:()", "()ISSUE:()", "()DEPRECATED()", "()FAILED:()"}, group = "MiniHipatternsFixme" },
          hack     = { pattern = {"()HACK:()", "()WARN:()", "()WARNING:()"}, group = "MiniHipatternsHack" },
          test     = { pattern = {"()TEST:()", "()TESTING:()", "()PASSED:()", "()TODO:()"}, group = "MiniHipatternsTodo" },
          info     = { pattern = {"()INFO:()", "()NOTE:()"}, group = "MiniHipatternsNote" },
          optimize = { pattern = {"()OPTIMIZE:()", "()OPTIM:()", "()PERFORMANCE:()", "()PERF:()"}, group = "MiniHipatternsPerf" },
          --[[
          -- Extra highlights
          -- @param, @returns and more
          -- #THIS: or !THIS: or ¡THIS:
          -- !-----!: or !=======!:
          ]]
          docs     = { pattern = {"%s()@[%l-]+()"}, group = "MiniHipatternsDocs" },
          word     = { pattern = {"![%a%s%d_-\\.]+:"}, group = "MiniHipatternsWord" },
          word2    = { pattern = {"¡[%a%s%d_-\\.]+:"}, group = "MiniHipatternsWord2" },
          word3    = { pattern = {"#[%a%s%d_-\\.]+:"}, group = "MiniHipatternsWord3" },
          split    = { pattern = {"![-_=]+!:"}, group = "MiniHipatternsSplit" },
          --[[
          -- Highlight color systems using that color
          -- #4095BF
          -- hsl(200, 50%, 50%)
          -- lch(57.81% 34.32 241.72)
          -- rgb(64, 149, 191)
          ]]
          hex_color = hipatterns.gen_highlighter.hex_color(),
          hsl_color = {
            pattern = "hsl%(%d+, %d+%p?, %d+%p?%)",
            group = function(_, match)
              local utils = require("USER.modules.utils.color_hsl")
              local h, s, l = match:match("hsl%((%d+), (%d+)%p?, (%d+)%p?%)")
              h, s, l = tonumber(h), tonumber(s), tonumber(l)
              local color = utils.hslToHex(h, s, l)
              return MiniHipatterns.compute_hex_color_group(color, "bg")
            end,
          },
          lch_color = {
            pattern = "lch%(%d*%.?%d+%p? %d*%.?%d+ %d*%.?%d+%)",
            group = function(_, match)
              local utils = require("USER.modules.utils.color_lch")
              local l, c, h = match:match("lch%((%d*%.?%d+)%p? (%d*%.?%d+) (%d*%.?%d+)%)")
              l, c, h = tonumber(l), tonumber(c), tonumber(h)
              local color = utils.lchToHex(l, c, h)
              return MiniHipatterns.compute_hex_color_group(color, "bg")
            end,
          },
          rgb_color = {
            pattern = "rgb%(%d+, %d+, %d+%)",
            group = function(_, match)
              local utils = require("USER.modules.utils.color_rgb")
              local r, g, b = match:match("rgb%((%d+), (%d+), (%d+)%)")
              r, g, b = tonumber(r), tonumber(g), tonumber(b)
              local color = utils.rgbToHex(r, g, b)
              return MiniHipatterns.compute_hex_color_group(color, "bg")
            end,
          },
        },
      })
    end
  },
  {
    -- url = "https://github.com/farias-hecdin/ColorCommander.nvim",
    dir = D.plugin .. "ColorCommander.nvim",
    cmd = { "ColorToName", "ColorNameInstall", "ColorPaste", "ColorToHsl", "ColorToLch", "ColorToRgb" },
    config = function()
      require('colorcommander').setup({
        show_virtual_text = false,
        show_virtual_text_to_hex = "lch",
        disable_keymaps = false,
        filetypes = { "css", "lua" },
      })
    end,
  },
}
