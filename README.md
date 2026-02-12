# NixOS Dotfiles

Multi-host NixOS + Home Manager configuration with GUI and headless profiles.

## Setup

### 1. Edit variables

All variables live in `vars.nix` — shared values plus per-host overrides for hostname and flakePath.

### 2. Bootstrap

Run as root on a fresh NixOS minimal install. Replace `<profile>`, `<host-name>` with the name from `vars.nix` (e.g. `nixos`, `headless`):

```bash
mkdir -p /mnt/shared
mount -t 9p share /mnt/shared -o trans=virtio,version=9p2000.L
cp /etc/nixos/hardware-configuration.nix /mnt/shared/nix-dotfiles/hosts/<profile>/
nix-shell -p git --run "git config --global --add safe.directory /mnt/shared/nix-dotfiles && nixos-rebuild switch --flake /mnt/shared/nix-dotfiles#<host-name>"
passwd dev
```

After reboot, log in as `dev`. All `nx-*` shell aliases are available and automatically target the correct host.

### 3. Rebuild (after bootstrap)

```bash
nx-switch   # alias for: sudo nixos-rebuild switch --flake <flakePath>#<hostname>
```

## SSH access

```bash
ssh dev@<host-ip>   # find IP with: ip a
```
