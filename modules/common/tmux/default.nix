{ config, pkgs, lib, ... }:

{
  options = {
    tmux.enable = lib.mkEnableOption "tmux";
  };
  
  config = lib.mkIf config.tmux.enable {
    home-manager.users.${config.user} = {
      programs.tmux = {
        enable = true;
        clock24 = true;
        mouse = true;
        terminal = "screen-256color";
      };
    };
  };
}