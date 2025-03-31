{ config, pkgs, pkgs-unstable, lib, ... }:

{
  options = {
    fish.enable = lib.mkEnableOption "Fish";
  };

  config = lib.mkIf config.fish.enable {
    home-manager.users.${config.user} = {
      home.file = {
        ".config/fish/colorschemes/tomorrow-night.fish".source = ./tomorrow-night.fish;
        ".config/fish/colorschemes/tomorrow-day.fish".source = ./tomorrow-day.fish;
      };
      
      programs.fish = {
        enable = true;
        package = pkgs-unstable.fish;
        generateCompletions = true;
        shellAliases = {
          fcd = "cd $__fish_config_dir";
        } // lib.optionalAttrs config.zsh.enable {
          zcd = "cd $ZDOTDIR";
          zsh = "ZSH_EXEC_FISH=false command zsh";
        };

        shellAbbrs = {
          "!!" = {
            position = "anywhere";
            function = "last_history_item";
          };
        };

        functions = {
          fish_greeting = ""; # Disable the default fish greeting message
          last_history_item = "echo $history[1]";
          fish_prompt = ''
            set -g __fish_git_prompt_showdirtystate true
            set -g __fish_git_prompt_showstashstate true
            set -g __fish_git_prompt_showupstream informative
            printf "%s╭─[%s$USER%s@%s%s%s]─["(status_prompt)"]: %s%s%s\n" "$_prompt_color" "$_user_prompt_color" "$_at_prompt_color" "$_hostname_prompt_color" (hostname) "$_prompt_color" "$_pwd_prompt_color" (prompt_pwd) (fish_git_prompt)
            printf "%s╰"(custom_fish_mode_prompt)(ssh_prompt)">> %s" "$_prompt_color" (set_color normal)
          '';
          fish_right_prompt = ''
            printf '%s%s (fish)\n' "$_right_prompt_color" (date +%H:%M:%S)
            set_color normal
          '';
          fish_mode_prompt = ""; # Disable the default mode prompt to define our own
          custom_fish_mode_prompt = ''
            if test "$fish_key_bindings" = 'fish_vi_key_bindings'
            or test "$fish_key_bindings" = 'fish_hybrid_key_bindings'
                switch "$fish_bind_mode"
                    case "default"
                        set -f _symbol "$_mode_prompt_normal_color"N
                    case "insert"
                        set -f _symbol "$_mode_prompt_insert_color"I
                    case "replace_one"
                        set -f _symbol "$_mode_prompt_replace_one_color"R
                    case "replace"
                        set -f _symbol "$_mode_prompt_replace_color"R
                    case "visual"
                        set -f _symbol "$_mode_prompt_visual_color"V
                end
                printf "─[%s%s]" "$_symbol" "$_prompt_color"
            else
                printf '%s' "$_prompt_color"
            end
          '';
          status_prompt = ''
            set -f _pipestatus (fish_status_to_signal $pipestatus)
            set -f _status_list
            for _status in $_pipestatus
                if test "$_status" = '0'
                    set -a _status_list "$_status_zero_prompt_color$_status"
                else
                    set -a _status_list "$_status_error_prompt_color$_status"
                end
            end
            printf (string join "$_prompt_color|" $_status_list)"$_prompt_color"
          '';
          ssh_prompt = ''
            if set -q SSH_CLIENT
                printf '─[%sssh%s]─' "$_ssh_prompt_color" "$_prompt_color"
            else
                printf '─'
            end
          '';
          greeting = ''
            # Skip greeting when we're in an IDE integrated terminal or if there's no greeting file
            if ! set -q IDE_SESSION; and test -f "$HOME/.greeting"
                printf "$_greeting_color"
                cat "$HOME/.greeting"
                set_color normal
            end
          '';
          colorscheme = ''
            function usage
                printf 'Usage: colorscheme [-h] [-l] [COLORSCHEME]\n\n' 1>&2
                printf 'Options:\n' 1>&2
                printf '-h\tShow this message\n' 1>&2
                printf '-l\tShow all colorscheme names\n' 1>&2
            end

            if not test -d "$__fish_config_dir/colorschemes"
                mkdir -p "$__fish_config_dir/colorschemes"
            end

            if test (count $argv) -ne 1
                usage
                return 1
            end

            if test "$argv[1]" = '-l'
                if ! find "$__fish_config_dir/colorschemes" -name '*.fish' | grep -q .
                    printf '%sYou don\'t have any colorschemes installed%s\n' (set_color -o red) (set_color normal)
                    printf 'You can install them by putting *.fish files inside %s or a subfolder\n' "\$__fish_config_dir/colorschemes"
                else
                    find "$__fish_config_dir/colorschemes" -name '*.fish' -exec basename '{}' \; | sed 's/\.fish//'
                end
            else if test "$argv[1]" = '-h'
                usage 2>&1
            else
                if find "$__fish_config_dir/colorschemes" -name "$argv[1].fish" | grep -q .
                    source (find "$__fish_config_dir/colorschemes" -name "$argv[1].fish")
                    printf 'Applied colorscheme: %s\n' "$argv[1]"
                    printf '%s' "$argv[1]" > "$__fish_config_dir/colorschemes/.active_colorscheme"
                else
                    printf "The colorscheme '%s' doesn't exist\n" "$argv[1]" 1>&2
                    return 1
                end
            end
            functions -e usage
          '';
        };

        # shellInit = ""; # Always runs
        # shellInitLast = ""; # Always runs
        # loginShellInit = ""; # Only runs if login shell

        # Only runs if interactive shell:
        interactiveShellInit = let defaultColorscheme = "tomorrow-night"; in ''
          # Prompt colors
          set _main_color                    'magenta'
          set _accent_color                  'brmagenta'
          set _right_prompt_color            (set_color 585858)
          set _prompt_color                  (set_color -o "$_main_color")
          set _user_prompt_color             (set_color "$_main_color")
          set _at_prompt_color               (set_color -o "$_main_color")
          set _hostname_prompt_color         (set_color -o "$_main_color")
          set _status_zero_prompt_color      (set_color -o "$_accent_color")
          set _status_error_prompt_color     (set_color -o brred)
          set _pwd_prompt_color              (set_color normal)(set_color "$_accent_color")
          set _mode_prompt_normal_color      (set_color -o magenta)
          set _mode_prompt_insert_color      (set_color -o brmagenta)
          set _mode_prompt_replace_one_color (set_color -o yellow)
          set _mode_prompt_replace_color     (set_color -o blue)
          set _mode_prompt_visual_color      (set_color -o green)
          set _ssh_prompt_color              (set_color -o "$_accent_color")
          set _greeting_color                (set_color -o "$_main_color")

          # Keybinds (vi mode)
          if ! test "$fish_key_bindings" = "fish_vi_key_bindings"
              fish_vi_key_bindings
          end

          bind -M insert \cr history-pager
          bind -M default \cr history-pager
          bind -M insert \cf forward-char
          bind -M default \cf forward-char
          bind -M insert \cs forward-char
          bind -M default \cs forward-char
          bind -M default \x20 edit_command_buffer

          # Apply colorscheme (if necessary)
          if ! test -f "$__fish_config_dir/colorschemes/.active_colorscheme"
              colorscheme ${defaultColorscheme} > /dev/null 2>&1
          end

          greeting
        '';

        plugins = with pkgs.fishPlugins; [
          {
            name = "autopair";
            src = autopair.src;
          }
          {
            name = "bass";
            src = bass.src;
          }
        ];
      };
    };
  };
}
