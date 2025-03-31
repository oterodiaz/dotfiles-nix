{ config, pkgs, lib, ... }:

{
  options = {
    zsh.enable = lib.mkEnableOption "Z Shell";
  };

  config = lib.mkIf config.zsh.enable {
    home-manager.users.${config.user} = {
      programs.zsh = {
        enable = true;
        dotDir = ".config/zsh";
        enableCompletion = true;
        autocd = true;
        history = {
          append = true;
          extended = true;
          # findNoDups = true; # home-manager > 24.11
          ignoreDups = true;
          ignoreSpace = true;
          save = 50000;
          size = 50000;
          share = true;
        };

        # .zshrc
        initExtraFirst = let execFishEnabled = lib.boolToString true; in ''
          if command -v fish > /dev/null 2>&1 && [ "''${ZSH_EXEC_FISH:-${execFishEnabled}}" = "true" ]; then
            # Ensure that there is a terminal attached to the session
            # before executing fish so i.e. Zed can read the environment
            if ([[ -t 0 ]] && [[ -t 1 ]] && [[ -t 2 ]]); then
              exec fish
            fi
          fi
        '';

        initExtraBeforeCompInit = ''
          prompt_custom_setup () {
              local newline=$'\n'
              if [ $SSH_CLIENT ]; then
                  PS1="%B%F{magenta}╭─[%n@%m]-[%f%(?.%F{blue}.%F{red})%?%f%F{magenta}]: %f%b%F{blue}%~%f$newline%B%F{magenta}╰─[ssh]->>%f%b "
              else
                  PS1="%B%F{magenta}╭─[%n@%m]-[%f%(?.%F{blue}.%F{red})%?%f%F{magenta}]: %f%b%F{blue}%~%f$newline%B%F{magenta}╰─>>%f%b "
              fi;
              RPS1='%F{240}%D{%H:%M:%S} (zsh)%f'
              PS2="%B%F{magenta}>>>> %f%b"

              prompt_opts=( cr percent )
          }

          greeting() {
              # Skip greeting when we're in an IDE integrated terminal or if there's no greeting file
              if [ ! -n "''${IDE_SESSION+x}" ] && [ -f "$HOME/.greeting" ]; then
                  printf '%b' '\033[35m\033[1m'
                  cat "$HOME/.greeting"
                  printf '%b' '\033[0m'
              fi
          }
        '';

        initExtra = ''
          autoload edit-command-line
          zle -N edit-command-line

          # Create a zkbd compatible hash;
          # To add other keys to this hash, see: man 5 terminfo
          typeset -g -A key

          key[Home]="''${terminfo[khome]}"
          key[End]="''${terminfo[kend]}"
          key[Insert]="''${terminfo[kich1]}"
          key[Backspace]="''${terminfo[kbs]}"
          key[Delete]="''${terminfo[kdch1]}"
          key[Up]="''${terminfo[kcuu1]}"
          key[Down]="''${terminfo[kcud1]}"
          key[Left]="''${terminfo[kcub1]}"
          key[Right]="''${terminfo[kcuf1]}"
          key[PageUp]="''${terminfo[kpp]}"
          key[PageDown]="''${terminfo[knp]}"
          key[Shift-Tab]="''${terminfo[kcbt]}"
          key[Control-Left]="''${terminfo[kLFT5]}"
          key[Control-Right]="''${terminfo[kRIT5]}"

          # Setup keys accordingly
          [[ -n "''${key[Home]}"          ]] && bindkey -- "''${key[Home]}"           beginning-of-line
          [[ -n "''${key[End]}"           ]] && bindkey -- "''${key[End]}"            end-of-line
          [[ -n "''${key[Insert]}"        ]] && bindkey -- "''${key[Insert]}"         overwrite-mode
          [[ -n "''${key[Backspace]}"     ]] && bindkey -- "''${key[Backspace]}"      backward-delete-char
          [[ -n "''${key[Delete]}"        ]] && bindkey -- "''${key[Delete]}"         delete-char
          [[ -n "''${key[Left]}"          ]] && bindkey -- "''${key[Left]}"           backward-char
          [[ -n "''${key[Right]}"         ]] && bindkey -- "''${key[Right]}"          forward-char
          [[ -n "''${key[PageUp]}"        ]] && bindkey -- "''${key[PageUp]}"         beginning-of-buffer-or-history
          [[ -n "''${key[PageDown]}"      ]] && bindkey -- "''${key[PageDown]}"       end-of-buffer-or-history
          [[ -n "''${key[Shift-Tab]}"     ]] && bindkey -- "''${key[Shift-Tab]}"      reverse-menu-complete
          [[ -n "''${key[Control-Left]}"  ]] && bindkey -- "''${key[Control-Left]}"   backward-word
          [[ -n "''${key[Control-Right]}" ]] && bindkey -- "''${key[Control-Right]}"  forward-word

          # Finally, make sure the terminal is in application mode, when zle is
          # active. Only then are the values from $terminfo valid.
          if (( ''${+terminfo[smkx]} && ''${+terminfo[rmkx]} )); then
              autoload -Uz add-zle-hook-widget
              function zle_application_mode_start { echoti smkx }
              function zle_application_mode_stop { echoti rmkx }
              add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
              add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
          fi

          # Custom keybinds
          bindkey '^S'    autosuggest-accept
          bindkey '^F'    autosuggest-accept
          bindkey -M vicmd ' ' edit-command-line

          prompt_custom_setup "$@"
          greeting
        '';

        sessionVariables = {
          # Less colors
          LESS_TERMCAP_mb = ''''$(printf "%b" "\033[01;35m")''; # Magenta
          LESS_TERMCAP_md = ''''$(printf "%b" "\033[01;35m")''; # Magenta
          LESS_TERMCAP_me = ''''$(printf "%b" "\033[0m")'';
          LESS_TERMCAP_se = ''''$(printf "%b" "\033[0m")'';
          LESS_TERMCAP_so = ''''$(printf "%b" "\033[01;44;33m")''; # Yellow
          LESS_TERMCAP_ue = ''''$(printf "%b" "\033[0m")'';
          LESS_TERMCAP_us = ''''$(printf "%b" "\033[01;34m")''; # Blue
          GROFF_NO_SGR = "yes"; # This fixes colors in Fedora
        };

        shellAliases = {
          zcd = "cd $ZDOTDIR";
        };

        # Plugins
        autosuggestion.enable = true;
        historySubstringSearch = {
          enable = true;
          searchDownKey = "\${key[Down]}";
          searchUpKey = "\${key[Up]}";
        };

        syntaxHighlighting = {
          enable = true;
          styles = let command_fg = "#005FD7"; in {
            default = "fg=blue";
            arg0 = "fg=${command_fg}";
            reserved-word = "fg=cyan";
            command = "fg=${command_fg}";
            path = "fg=blue,underline";
            unknown-token = "fg=#FF0000";
            autodirectory = "fg=${command_fg}";
            double-hyphen-option = "fg=blue";
            single-hyphen-option = "fg=blue";
            precommand = "fg=${command_fg},bold";
          };
        };
      };
    };
  };
}
