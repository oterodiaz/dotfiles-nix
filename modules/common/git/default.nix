{ config, pkgs, lib, ... }:

{
  options = {
    gitName = lib.mkOption {
      type = lib.types.str;
      description = "Git username";
    };
    gitEmail = lib.mkOption {
      type = lib.types.str;
      description = "Git user email";
    };
  };
  
  config = {
    home-manager.users.${config.user} = {
      programs.git = {
        enable = true;
        userName = config.gitName;
        userEmail = config.gitEmail;
      };
    };
  };
}
