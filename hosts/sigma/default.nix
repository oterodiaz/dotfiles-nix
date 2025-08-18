{ inputs }:

inputs.nix-darwin.lib.darwinSystem rec {
  system = "aarch64-darwin";
  specialArgs = {
    pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
  };
  modules = [
    ../../modules/common
    ../../modules/darwin
    inputs.home-manager.darwinModules.home-manager
    rec {
      user = "diego";
      homeDirectory = /Users/${user};
      gitName = "oterodiaz";
      gitEmail = "44239644+oterodiaz@users.noreply.github.com";
      computerName = "Sigma";
      hostName = "Sigma";
    }
    {
      brewFormulae = [
        "trash"
      ];
      brewCasks = [
        "arc"
        "zen-browser"
        "1password"
        "1password-cli" 
        "zed"
        "ghostty"
        "obsidian"
        "stats" # Menu bar hardware status info
        "aldente" # Limit battery charge
        "altserver" # Install iOS apps from outside the App Store
        "betterdisplay" # Better text rendering, color modes, etc.
        "coconutbattery" # Detailed battery info for Mac and iPhone
        "cyberduck" # FTP Client
        "iina" # Mac-native MPV frontend
        "middleclick" # Three-finger click to simulate middle click on trackpad
        "mos" # Smooth scrolling with mice
        "nightfall" # Easier dark/light mode switching
        "rectangle" # Better window tiling
        "transmission" # Torrent client
        "utm" # Virtual machines
        "whisky" # Play Windows games on Mac
        "xcodes" # Manage different Xcode versions
        "font-sf-mono-nerd-font-ligaturized" # TODO: fork and create a nix package
      ];
    }
    {
      themectl.enable = true;
      neovim.enable = true;
      zed.enable = true;
      ghostty.enable = true;
      zsh.enable = true;
      fish.enable = true;
      tmux.enable = true;
    }
  ];
}
