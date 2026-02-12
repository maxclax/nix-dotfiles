# Headless host home-manager configuration (shared only)
{
  inputs,
  lib,
  config,
  pkgs,
  vars,
  ...
}: {
  imports = [
    ../../home-manager/home.nix
  ];
}
