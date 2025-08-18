{ config, pkgs, lib, ... }:

{
  options = {
    computerName = lib.mkOption {
      type = lib.types.str;
      description = "The user-friendly name for the system";
    };
    hostName = lib.mkOption {
      type = lib.types.str;
      description = "The hostname of the system";
    };
  };
  
  config = lib.mkIf pkgs.stdenv.isDarwin {
    security.pam.services.sudo_local.touchIdAuth = true;
    
    networking.computerName = config.computerName;
    networking.hostName = config.hostName;
    networking.localHostName = config.hostName;
    
    # ssh
    services.openssh.enable = true;
    environment.etc."ssh/sshd_config.d/50-custom.conf" = {
      enable = true;
      text = ''
        Port 22
        LoginGraceTime 30s
        PermitRootLogin no
        PubkeyAuthentication yes
        PasswordAuthentication no
        AuthenticationMethods publickey
        AuthorizedKeysFile .ssh/authorized_keys
        StrictModes yes
        KbdInteractiveAuthentication no
        UsePAM yes
        X11Forwarding no
        PrintMotd no
        AcceptEnv LANG LC_*
      '';
    };
    
    environment.systemPackages = with pkgs; [
      vim
      git
      curl
      wget
    ];
    
    nix.gc.interval = {
      Hour = 12;
      Minute = 15;
      Day = 1;
    };
    
    system.stateVersion = 5;
    system.primaryUser = config.user;
  };
}
