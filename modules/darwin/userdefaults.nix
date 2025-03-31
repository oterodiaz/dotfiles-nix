{ config, pkgs, lib, ... }:

{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    # Enable settings that home-manager doesn't support
    system = {
      activationScripts.postActivation.text = ''
        sudo chflags nohidden /Volumes
      '';

      activationScripts.postUserActivation.text = ''
        chflags nohidden ~/Library
        mkdir -p ~/Pictures/Screenshots
      '';
    };

    home-manager.users.${config.user} = {
      targets.darwin.defaults = {
        NSGlobalDomain = {
          AppleLanguages = [ "en-US" ];
          AppleLocale = "en_US";
          AppleMeasurementUnits = "Centimeters";
          AppleMetricUnits = true;
          ApplePressAndHoldEnabled = false;
          AppleShowAllExtensions = true;
          AppleTemperatureUnit = "Celsius";
          AppleInterfaceStyleSwitchesAutomatically = true;
          KeyRepeat = 1;
          InitialKeyRepeat = 21;
          NSNavPanelExpandedStateForSaveMode = true;
          NSNavPanelExpandedStateForSaveMode2 = true;
          NSWindowShouldDragOnGesture = true;
          NSUserKeyEquivalents = {
            "Save As..." = "@$S";
          };
          AppleICUForce24HourTime = true;
          AppleICUDateFormatStrings = {
            "1" = "y-MM-dd";
          };
          AppleFirstWeekday = {
            gregorian = 2;
          };

          # Enable iMac exclusive accent colors
          # 3: Yellow
          # 4: Green
          # 5: Blue
          # 6: Pink
          # 7: Purple
          # 8: Orange
          NSColorSimulateHardwareAccent = true;
          NSColorSimulatedHardwareEnclosureNumber = 7;
        };

        "com.apple.Safari" = {
          AutoFillCreditCardData = false;
          AutoFillPasswords = false;
          AutoOpenSafeDownloads = false;
          IncludeDevelopMenu = true;
          ShowOverlayStatusBar = true;
        };

        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };

        "com.apple.dock" = {
          autohide = false;
          expose-group-apps = true;
          orientation = "bottom";
          tilesize = 64;
          largesize = 72;
          magnification = true;
          show-recents = true;
        };

        "com.apple.menuextra.clock" = {
          IsAnalog = false;
          Show24Hour = true;
          ShowDate = 0; # 0 means "show date", 1 means "don't show date"
          ShowDayOfWeek = true;
        };

        "com.apple.AppleMultitouchTrackpad" = {
          Clicking = true;
          DragLog = true;
          Dragging = true;
          ForceSuppressed = false;
          TrackpadFiveFingerPinchGesture = 2;
          TrackpadFourFingerHorizSwipeGesture = 2;
          TrackpadFourFingerPinchGesture = 2;
          TrackpadFourFingerVertSwipeGesture = 2;
          TrackpadThreeFingerHorizSwipeGesture = 2;
          TrackpadThreeFingerTapGesture = 0;
          TrackpadThreeFingerVertSwipeGesture = 2;
          TrackpadTwoFingerDoubleTapGesture = 1;
          TrackpadTwoFingerFromRightEdgeSwipeGesture = 3;
        };
        "com.apple.driver.AppleBluetoothMultitouch.trackpad" = {
          Clicking = true;
          DragLog = true;
          Dragging = true;
          ForceSuppressed = false;
          TrackpadFiveFingerPinchGesture = 2;
          TrackpadFourFingerHorizSwipeGesture = 2;
          TrackpadFourFingerPinchGesture = 2;
          TrackpadFourFingerVertSwipeGesture = 2;
          TrackpadThreeFingerHorizSwipeGesture = 2;
          TrackpadThreeFingerTapGesture = 0;
          TrackpadThreeFingerVertSwipeGesture = 2;
          TrackpadTwoFingerDoubleTapGesture = 1;
          TrackpadTwoFingerFromRightEdgeSwipeGesture = 3;
        };

        "com.apple.finder".FXDefaultSearchScope = "SCcf"; # Search the current folder by default
        "com.apple.screencapture".location = "/Users/${config.user}/Pictures/Screenshots";
      };

      targets.darwin.currentHostDefaults."com.apple.controlcenter".BatteryShowPercentage = true;
    };
  };
}
