return {
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require("toggleterm").setup({
        -- size can be a number or function which is passed the current terminal
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<Space>t]],
        hide_numbers = true,      -- hide the number column in toggleterm buffers
        shade_filetypes = {},
        autochdir = false,        -- when neovim changes it current directory the terminal will change it's own when next it's opened
        shade_terminals = true,   -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
        shading_factor = '0',     -- the percentage by which to lighten terminal background, default: -30 (gets multiplied by -3 if background is light)
        start_in_insert = false,
        insert_mappings = false,  -- whether or not the open mapping applies in insert mode
        terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
        persist_size = true,
        persist_mode = true,      -- if set to true (default) the previous terminal mode will be remembered
        direction = 'horizontal',
        close_on_exit = true,     -- close the terminal window when the process exits
        -- Change the default shell. Can be a string or a function returning a string
        shell = vim.o.shell,
        auto_scroll = true, -- automatically scroll to the bottom on terminal output
      })
    end

  } }