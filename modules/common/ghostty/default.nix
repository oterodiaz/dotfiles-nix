{ config, pkgs, pkgs-unstable, lib, ... }:

{
  options = {
    ghostty.enable = lib.mkEnableOption "Ghostty";
  };

  config = lib.mkIf config.ghostty.enable {
    home-manager.users.${config.user} = {
      programs.ghostty = {
        # Installed with Homebrew on macOS, but we still want to manage the config with home-manager
        package = if pkgs.stdenv.isDarwin then pkgs.emptyDirectory else pkgs-unstable.ghostty;
        enable = true;
        settings = {
          auto-update-channel = "stable";
          mouse-hide-while-typing = true;
          wait-after-command = false;
          window-inherit-working-directory = true;
          shell-integration = "fish";
          shell-integration-features = "no-cursor";
          clipboard-trim-trailing-spaces = true;
          clipboard-paste-protection = true;
          quick-terminal-position = "bottom";
          term = "xterm-256color";
    
          # Appearance;
          theme = "light:Tomorrow,dark:custom-dark";
          background-opacity = "0.85";
          background-blur-radius = 48;
          window-theme = "system";
          window-padding-x = 6;
          window-padding-y = 6;
          window-padding-balance = true;
    
          # Font
          font-family = "JetBrains Mono";
          font-size = 14;
          font-synthetic-style = false;
          font-thicken = true;
    
          # Enable ligatures
          font-feature = [ "calt" "liga" "dlig" ];
    
          # Keybinds
          keybind = "global:cmd+grave_accent=toggle_quick_terminal";
    
          # macOS
          macos-option-as-alt = "left";
          macos-icon = "custom-style";
          macos-icon-frame = "plastic";
          macos-icon-ghost-color = "ae81ff";
          macos-icon-screen-color = "000000";
        };
    
        themes = {
          custom-dark = {
            palette = [
              "0=#242424"
              "1=#f92672"
              "2=#a6e22e"
              "3=#f4bf75"
              "4=#66d9ef"
              "5=#ae81ff"
              "6=#a1efe4"
              "7=#f8f8f2"
              "8=#75715e"
              "9=#f92672"
              "10=#a6e22e"
              "11=#f4bf75"
              "12=#66d9ef"
              "13=#ae81ff"
              "14=#a1efe4"
              "15=#f9f8f5"
            ];
            background = "242424";
            foreground = "f8f8f2";
            cursor-color = "ae81ff";
            selection-background = "373b41";
            selection-foreground = "c5c8c6";
          };
        };
      };
    };
  };
}
