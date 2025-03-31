{ config, pkgs, pkgs-unstable, lib, ... }:

{
  options = {
    zed.enable = lib.mkEnableOption "Zed";
  };

  config = lib.mkIf config.zed.enable {
    home-manager.users.${config.user} = {
      home.file = {
        ".config/zed/themes/custom-modest-dark.json".source = ./custom-modest-dark.json;
      };

      programs.zed-editor = {
        # Installed with Homebrew on macOS, but we still want to manage the config with home-manager
        package = if pkgs.stdenv.isDarwin then pkgs.emptyDirectory else pkgs-unstable.zed-editor;
        enable = true;
        extensions = [
          "html"
          "catppuccin"
          "toml"
          "dockerfile"
          "git-firefly"
          "sql"
          "svelte"
          "zig"
          "lua"
          "swift"
          "nix"
          "fish"
        ];

        userKeymaps = [
          {
            context = "Editor && vim_mode == insert";
            bindings = {
              "j j" = [ "workspace::SendKeystrokes" "escape" ];
            };
          }
          {
            context = "vim_mode == normal";
            bindings = {
              ";" = "command_palette::Toggle";
              "space t w" = "editor::ToggleSoftWrap";
              "space t n" = "editor::ToggleRelativeLineNumbers";
            };
          }
          {
            context = "EmptyPane || SharedScreen";
            bindings = {
              ";" = "command_palette::Toggle";
            };
          }
          {
            # netrw compatibility
            context = "ProjectPanel && not_editing";
            bindings = {
              ";" = "command_palette::Toggle";
            };
          }
        ];

        userSettings = {
          icon_theme = "Zed (Default)";
          assistant = {
            enable_experimental_live_diffs = true;
            dock = "left";
            version = "2";
            default_model = {
              provider = "zed.dev";
              model = "claude-3-7-sonnet-latest";
            };
          };
          project_panel = {
            dock = "right";
          };
          telemetry = {
            diagnostics = false;
            metrics = false;
          };
          vim_mode = true;
          vim.use_system_clipboard = "on_yank";
          base_keymap = "VSCode";
          ui_font_family = ".SystemUIFont";
          buffer_font_family = "Liga SFMono Nerd Font";
          ui_font_size = 16;
          buffer_font_size = 13;
          ensure_final_newline_on_save = true;
          remove_trailing_whitespace_on_save = true;
          format_on_save = "on";
          confirm_quit = true;
          wrap_guides = [100];
          redact_private_values = true;
          vertical_scroll_margin = 5;
          use_system_path_prompts = false;
          autosave.after_delay.milliseconds = 750;
          theme = {
            mode = "system";
            light = "Catppuccin Latte";
            dark = "Modest Dark (Custom)";
          };
          terminal = {
            line_height = "standard";
            blinking = "on";
            env = {
              IDE_SESSION = "true";
              TERM = "xterm-256color";
            };
          };
          calls = {
            mute_on_join = true;
            share_on_join = false;
          };
          inlay_hints = {
            enabled = false;
            show_background = true;
          };
          tabs = {
            git_status = true;
            close_position = "left";
            file_icons = true;
            activate_on_close = "history";
          };
          languages = {
            Lua = {
              tab_size = 2;
            };
            YAML = {
              tab_size = 2;
            };
          };
        };
      };
    };
  };
}
