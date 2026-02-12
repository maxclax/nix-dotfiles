# GUI host NixOS configuration (desktop, SPICE, shared folders)
{ config, pkgs, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/base.nix
    ../../nixos/desktop.nix
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

  # Clipboard and display sharing for UTM/QEMU VM
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;

  # GPU acceleration for smooth graphics in QEMU/SPICE VM
  services.xserver.videoDrivers = [ "qxl" "modesetting" ];
  hardware.graphics.enable = true;

  # Enable i3 as an additional window manager session option (alongside GNOME)
  services.xserver.windowManager.i3.enable = true;

  # Extra system packages
  environment.systemPackages = with pkgs; [
    bindfs
    spice-vdagent
    xclip
  ];
}
