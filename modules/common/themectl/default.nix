{ config, pkgs, lib, ... }:

let 
  themectl = import ./package { inherit pkgs lib; };
in {
  options = {
    themectl.enable = lib.mkEnableOption "themectl";
  };

  config = lib.mkIf config.themectl.enable {
    home-manager.users.${config.user} = {
      home.packages = [
        themectl
      ];
    };
  };
}
