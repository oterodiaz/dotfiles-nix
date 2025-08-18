{ config, pkgs, lib, ... }:

{
  options = {
    brewFormulae = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Homebrew formulae to install (system-wide)";
    };
    
    brewCasks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Homebrew casks to install (system-wide)";
    };
  };
  
  config = lib.mkIf pkgs.stdenv.isDarwin {
    # Install Xcode Command Line Tools and Homebrew first
    # TODO: this now runs as root as of nix-darwin 25.05, which might break things
    system.activationScripts.preActivation.text = ''
      if ! xcode-select --version 2> /dev/null; then
        $DRY_RUN_CMD xcode-select --install
      fi
      if ! /opt/homebrew/bin/brew --version 2> /dev/null; then
        $DRY_RUN_CMD /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi
    '';
    
    home-manager.users.${config.user}.home.sessionPath = [
      "/opt/homebrew/bin/"
      "/opt/homebrew/opt/trash/bin/"
    ];

    homebrew = {
      enable = true;
      onActivation = {
        autoUpdate = false;
        cleanup = "zap";
        upgrade = true;
      };
      
      global = {
        brewfile = true; # Run brew bundle from anywhere
        lockfiles = false; # Don't save lockfile (since running from anywhere)
      };
      
      brews = config.brewFormulae;
      
      # GUI apps don't show up in Spotlight if installed from nixpkgs, so we use homebrew for those
      casks = config.brewCasks;
    };
  };
}
