local ok, plugin_config = pcall(require, "mini.hipatterns")
if ok then
  plugin_config.setup({
    highlighters = {
      -- Highlight standalone "FIXME", "HACK", "TODO", "NOTE"
      fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
      hack  = { pattern = "%f[%w]()HACK()%f[%W]",  group = "MiniHipatternsHack"  },
      todo  = { pattern = "%f[%w]()TODO()%f[%W]",  group = "MiniHipatternsTodo"  },
      note  = { pattern = "%f[%w]()NOTE()%f[%W]",  group = "MiniHipatternsNote"  },

      -- Highlight hex color strings (`#rrggbb`) using that color
      hex_color = plugin_config.gen_highlighter.hex_color(),
    },
  })
end
