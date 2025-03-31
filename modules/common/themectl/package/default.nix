{ pkgs, lib, ... }:

pkgs.writeShellScriptBin "themectl" (
  lib.fileContents ./themectl.sh
)
