# Shared home-manager configuration
# Shell, git, common CLI packages — no GUI or VM-specific bits
{
  inputs,
  lib,
  config,
  pkgs,
  vars,
  ...
}: {
  imports = [
    ./zsh.nix
    ./tmux.nix
    ./atuin.nix
    ./starship.nix
  ];

  nixpkgs = {
    overlays = [];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = vars.username;
    homeDirectory = "/home/${vars.username}";
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "25.11";
  home.packages = with pkgs; [
    cowsay
    lazygit
    ranger
    atop
    inotify-tools
    eza
    yazi
    broot
    tree
  ];

  programs.git.settings = {
    user.name = vars.fullName;
    user.email = vars.email;
  };

  home.shellAliases = let
    flake = "${vars.flakePath}#${vars.hostname}";
  in {
    nx-switch  = "sudo nixos-rebuild switch --flake ${flake}";
    nx-build   = "nixos-rebuild build --flake ${flake}";
    nx-test    = "sudo nixos-rebuild test --flake ${flake}";
    nx-diff    = "nixos-rebuild build --flake ${flake} && nix store diff-closures /run/current-system ./result";
    nx-update  = "nix flake update --flake ${vars.flakePath} && sudo nixos-rebuild switch --flake ${flake}";
    nx-rollback = "sudo nixos-rebuild switch --rollback";
    nx-generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
    nx-clean   = "sudo nix-collect-garbage -d && sudo nix-store --optimise";
    nx-clean-old = "sudo nix-collect-garbage --delete-older-than 7d";
    nx-size    = "nix path-info -Sh /run/current-system";
    nx-check   = "nix flake check --no-build ${vars.flakePath}";

    # Quick edit configs
    nx-home    = "$EDITOR ${vars.flakePath}/home-manager/home.nix";
    nx-system  = "$EDITOR ${vars.flakePath}/nixos/base.nix";
    nx-flake   = "$EDITOR ${vars.flakePath}/flake.nix";
  };
}
