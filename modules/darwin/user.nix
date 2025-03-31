{ config, pkgs, lib, ... }:

let 
  themectl = import ../common/themectl/package { inherit pkgs lib; };
  abysswatcher = import ./abysswatcher.nix { inherit pkgs; };
in {
  config = lib.mkIf pkgs.stdenv.isDarwin {
    users.users.${config.user} = {
      home = config.homeDirectory;
    };
    
    home-manager.users.${config.user} = {
      home.packages = [
        abysswatcher
      ];
    };
    
    environment.userLaunchAgents = lib.mkIf config.themectl.enable {
      "com.oterodiaz.abysswatcher.plist" = {
        enable = true;
        text = ''
          <?xml version="1.0" encoding="UTF-8"?>
          <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
          <plist version="1.0">
          <dict>
              <key>ProgramArguments</key>
              <array>
                  <string>${abysswatcher}/bin/abysswatcher</string>
                  <string>${themectl}/bin/themectl</string>
                  <string>-u</string>
              </array>
              <key>KeepAlive</key>
              <true/>
              <key>Label</key>
              <string>com.oterodiaz.abysswatcher</string>
              <key>EnvironmentVariables</key>
              <dict>
                  <key>PATH</key>
                  <string>/Users/${config.user}/.nix-profile/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin:/opt/homebrew/bin/</string>
              </dict>
          </dict>
          </plist>
        '';
      };
    };
  };
}