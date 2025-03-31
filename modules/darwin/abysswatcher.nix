{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  name = "abysswatcher";
  src = pkgs.fetchurl {
    url = "https://github.com/oterodiaz/abysswatcher/releases/download/v1.0.0/abysswatcher";
    # To get the hash, set this to an empty string and try to run the configuration. Then just
    # get the correct hash from the error message.
    hash = "sha256-fMJCmxxN4s0WdLqaljbSe9SZZulzkDuN2AHxZCv71YQ=";
  };

  # The source file is just a binary, so we disable the unpack phase (: is a noop command)
  unpackPhase = ":";
  
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/abysswatcher
    chmod +x $out/bin/abysswatcher
  '';
}
