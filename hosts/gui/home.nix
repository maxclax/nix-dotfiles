# GUI host home-manager configuration
# Imports shared home.nix and adds GUI apps, GNOME dock, i3
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
    ../../home-manager/i3.nix
  ];

  # Auto-start spice-vdagent (clipboard sharing)
  xdg.configFile."autostart/spice-vdagent.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Spice VDAgent
    Exec=${pkgs.spice-vdagent}/bin/spice-vdagent -x
    Hidden=false
    NoDisplay=true
    X-GNOME-Autostart-enabled=true
  '';

  # GNOME dock - only show these favorites
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Console.desktop"
        "firefox.desktop"
        "org.keepassxc.KeePassXC.desktop"
        "emacs.desktop"
      ];
    };
  };

  # GUI packages
  home.packages = with pkgs; [
    keepassxc
    emacs
  ];
}
