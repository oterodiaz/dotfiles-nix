{ config, lib, pkgs, ... }:

{
  imports = [
    ./themectl
    ./neovim
    ./zed
    ./ghostty
    ./zsh
    ./fish
    ./git
    ./tmux
  ];

  options = {
    user = lib.mkOption {
      type = lib.types.str;
      description = "The user of the configuration.";
    };
    homeDirectory = lib.mkOption {
      type = lib.types.path;
      description = "The user's home directory.";
      default = builtins.toPath (
        if pkgs.stdenv.isDarwin then "/Users/${config.user}" else "/home/${config.user}"
      );
    };
  };

  config = {
    home-manager.users.${config.user} = {
      home.stateVersion = "25.05";
      
      home.file = lib.mkIf (config.zsh.enable || config.fish.enable) {
        ".hushlogin".text = "";
        ".greeting".source = ./misc/shell-greeting.txt;
      };
      
      home.packages = with pkgs; [
        tealdeer
        eza
        bat
        ripgrep
        fd
      ];

      home.shellAliases = {
        rm = "rm -i";
        pcat = "bat -pP --theme=$(themectl && echo OneHalfDark || echo OneHalfLight)"; # Dynamic theme workaround. See `programs.bat` section
        rs = "clear && greeting";
        diff = "diff --color=auto";
        grep = "grep --color=auto";
        ls = "eza -lg --group-directories-first --icons --sort=name --no-time --git";
        ll = "eza -lg --group-directories-first --icons --sort=name --no-time --git";
        la = "eza -lga --group-directories-first --icons --sort=name --no-time --git";
        tree = "eza -lga --group-directories-first --icons --sort=name --no-time --git -T";
        gpip = "curl ifconfig.me; printf \"\\n\"";
        glip = if pkgs.stdenv.isDarwin then
            "ipconfig getifaddr en0"
          else if pkgs.stdenv.isLinux then
            ''ip a | grep -oP "(?<=inet\s)\d+(\.\d+){3}" | grep -v "127.0.0.1"''
          else
            "printf \"Unsupported OS\\n\"";
      } // lib.optionalAttrs pkgs.stdenv.isLinux {
        ip = "ip --color=auto";
      };
    };
  };
}
