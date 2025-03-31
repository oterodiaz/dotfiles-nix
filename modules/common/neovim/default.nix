# TODO: Create a custom neovim package that can run independently.

{ config, pkgs, lib, pkgs-unstable, ... }:

{
  options = {
    neovim.enable = lib.mkEnableOption "neovim";
    neovim.theme = lib.mkOption {
      type = lib.types.enum [ "light" "dark" ];
      default = "dark";
      description = "The theme that neovim will use if config.themectl is not enabled.";
    };
  };

  config = lib.mkIf config.neovim.enable {
    home-manager.users.${config.user} = {
      programs.neovim = {
        enable = true;
        package = pkgs-unstable.neovim-unwrapped;

        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;

        extraLuaConfig = let
          darkTheme = "mocha";
          lightTheme = "latte";
        in lib.strings.concatStrings [
          "\n"
          (lib.fileContents ./init.lua) # Main config
          "\n\n"
          (
            # If themectl is enabled, we create the sockets for `nvim-update-theme`,
            # then `updateColorscheme` will switch between themes at runtime
            if config.themectl.enable then ''
              function createSocket()
                pid = vim.fn.getpid()
                socket_name = '/tmp/nvim/nvim' .. pid .. '.sock'
                vim.fn.mkdir('/tmp/nvim', 'p')
                vim.fn.serverstart(socket_name)
              end

              api.nvim_create_autocmd('VimEnter', {
                desc = 'Create a socket for every nvim process',
                group = 'custom_startup', -- Defined in init.lua
                once = true,
                callback = createSocket
              })

              function updateColorscheme()
                exit_code = os.execute('themectl')
                if exit_code == true or exit_code == 0 then
                  vim.g.catppuccin_flavour = "${darkTheme}"
                  vim.cmd [[ colorscheme catppuccin ]]
                  vim.o.background = 'dark'
                  vim.cmd [[ hi Normal guibg=NONE ctermbg=NONE ]]
                  require('lualine').setup({ options = { theme = 'auto' } })
                else
                  vim.g.catppuccin_flavour = "${lightTheme}"
                  vim.cmd [[ colorscheme catppuccin ]]
                  vim.o.background = 'light'
                  vim.cmd [[ hi Normal guibg=NONE ctermbg=NONE ]]
                  require('lualine').setup({ options = { theme = 'catppuccin' } })
                end
              end
            ''
            # If themectl is disabled, `updateColorscheme` will just set the `config.neovim.theme`
            else ''
              function updateColorscheme()
                vim.g.catppuccin_flavour = "${if config.neovim.theme == "dark" then darkTheme else lightTheme}"
                vim.cmd [[ colorscheme catppuccin ]]
                vim.o.background = '${config.neovim.theme}'
                vim.cmd [[ hi Normal guibg=NONE ctermbg=NONE ]]
                require('lualine').setup({ options = { theme = '${if config.neovim.theme == "dark" then "auto" else "catppuccin"}' } })
              end
            ''
          )
          "\n"
          # Both implementations require this autocmd to run `updateColorscheme` when entering neovim
          ''
            api.nvim_create_autocmd('UIEnter', {
              desc = 'Set the appropriate theme on startup',
              group = 'custom_startup',
              once = true,
              callback = updateColorscheme
            })
          ''
        ];

        plugins = with pkgs.vimPlugins; [
          catppuccin-nvim
          vim-css-color
          nvim-web-devicons
          vim-fish
          {
            plugin = comment-nvim;
            config = ''
              lua << EOF
                require('Comment').setup()
              EOF
            '';
          }
          {
            plugin = nvim-autopairs;
            config = ''
              lua << EOF
                require('nvim-autopairs').setup()
              EOF
            '';
          }
          {
            plugin = nvim-tree-lua;
            config = ''
              lua << EOF
                require('nvim-tree').setup({
                  view = {
                    side = 'right',
                    width = 35
                  }
                })
              EOF
            '';
          }
          {
            plugin = lualine-nvim;
            config = ''
              lua << EOF
                require('lualine').setup({
                  options = {
                    section_separators = { left = '', right = '' },
                  },
                  sections = {
                    lualine_z = { 'location' }
                  }
                })
              EOF
            '';
          }
        ];
      };

      # Install `nvim-update-theme` only when themectl is enabled
      home.packages = lib.mkIf config.themectl.enable [
        (
          pkgs.writers.writePython3Bin "nvim-update-theme" {
            libraries = [ pkgs.python3Packages.pynvim ];
            flakeIgnore = [ "E501" "W292" ];
          } (lib.fileContents ./nvim-update-theme.py)
        )
      ];
    };
  };
}
