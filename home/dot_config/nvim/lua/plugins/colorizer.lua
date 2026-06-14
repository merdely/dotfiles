--   red    green   blue
--   Red    Green   Blue
--   RED    GREEN   BLUE
--   #F00   #0F0    #00F
-- #FF0000 #00FF00 #0000FF
-- rgb(255,0,0) rgb(0, 255, 0) rgb(0, 0, 255)
-- bg-blue-500
-- red
-- Red
-- RED
-- red3
-- Red3
-- RED3

return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  opts = { -- set to setup table
  },
  config = function()
    require("colorizer").setup(
      {
        user_default_options = {
          names_opts = {
            uppercase = true,
            strip_digits = true,
          },
          css = true,
          tailwind = true,
          xterm = true, -- Enable xterm 256-color codes (#xNN, \e[38;5;NNNm)
        },
      }
   )
  end,
}
