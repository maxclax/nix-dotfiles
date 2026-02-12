# Headless host NixOS configuration (no desktop)
{ config, pkgs, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/base.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Connect shared folder from host to VM
  fileSystems."/mnt/shared" = {
    device = "share";
    fsType = "9p";
    options = [ "trans=virtio" "version=9p2000.L" ];
  };

  # Mount shared folder to home directory with bindfs and remap permissions
  fileSystems."/home/${vars.username}/shared" = {
    device = "/mnt/shared";
    fsType = "fuse.bindfs";
    options = [ "map=501/1000:@20/@100" ];
    depends = [ "/mnt/shared" ];
  };

  environment.systemPackages = with pkgs; [
    bindfs
  ];
}
