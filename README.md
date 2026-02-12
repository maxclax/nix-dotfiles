# NixOS Dotfiles

Opinionated, multi-host NixOS + Home Manager flake with GUI and headless profiles. One `vars.nix` to configure everything. Add a new host in two lines.

## Features

- **Multi-host** — single repo drives multiple machines (desktop, server, Raspberry Pi)
- **Profile-based** — `gui` (GNOME + i3) and `headless` (CLI-only) profiles, pick per host
- **Single config file** — all user/host variables in one `vars.nix`
- **Auto-generated hosts** — add a host to `vars.nix`, flake picks it up automatically
- **Per-platform support** — `aarch64-linux`, `x86_64-linux`, or any nixpkgs platform
- **Flake template** — use as a starting point for your own dotfiles
- **Shell aliases** — `nx-switch`, `nx-update`, `nx-clean` and more, auto-configured per host

## What's included

| Layer | Tool | Config |
|---|---|---|
| Shell | zsh + oh-my-zsh | `home-manager/zsh.nix` |
| Prompt | starship | `home-manager/starship.nix` |
| History | atuin | `home-manager/atuin.nix` |
| Multiplexer | tmux (gpakosz/.tmux) | `home-manager/tmux.nix` |
| Window manager | i3 + i3status + dmenu | `home-manager/i3.nix` |
| Desktop | GNOME + GDM + pipewire | `nixos/desktop.nix` |
| Base system | boot, networking, locale, SSH, packages | `nixos/base.nix` |

## Structure

```
flake.nix                         # Entry point, auto-generates hosts from vars.nix
vars.nix                          # All variables: user, hosts, platforms
nixos/
  base.nix                        # Shared NixOS: boot, network, locale, user, packages
  desktop.nix                     # GNOME, X11, sound, printing (GUI only)
home-manager/
  home.nix                        # Shared HM: shell, git, CLI tools, aliases
  zsh.nix / tmux.nix / atuin.nix / starship.nix / i3.nix
hosts/
  gui/                            # Desktop profile
    configuration.nix / home.nix / hardware-configuration.nix
  headless/                       # Server profile
    configuration.nix / home.nix / hardware-configuration.nix
```

## Quick start

### Use as template

```bash
nix flake init -t github:maxclax/nix-dotfiles
```

Edit `vars.nix` with your username, email, hostname, and platform.

### Adding a new host

Just add an entry to `vars.nix`:

```nix
{
  username = "dev";
  fullName = "dev";
  email = "dev@site.com";

  hosts = {
    myhost = {
      hostname = "myhost";
      profile = "gui";        # or "headless"
      platform = "x86_64-linux";
      flakePath = "~/nix-dotfiles";
    };
  };
}
```

Then build: `sudo nixos-rebuild switch --flake .#myhost`

## Bootstrap (fresh NixOS install)

Run as root on a fresh NixOS minimal install:

```bash
nix-shell -p git --run "git clone https://github.com/maxclax/nix-dotfiles.git /tmp/nix-dotfiles && nixos-rebuild switch --flake /tmp/nix-dotfiles#<host-name>"
passwd dev
```

For UTM/QEMU VMs with a shared folder:

```bash
mkdir -p /mnt/shared
mount -t 9p share /mnt/shared -o trans=virtio,version=9p2000.L
cp /etc/nixos/hardware-configuration.nix /mnt/shared/nix-dotfiles/hosts/<profile>/
nix-shell -p git --run "git config --global --add safe.directory /mnt/shared/nix-dotfiles && nixos-rebuild switch --flake /mnt/shared/nix-dotfiles#<host-name>"
passwd dev
```

After reboot, log in as `dev`. All `nx-*` aliases are available.

## Daily usage

```bash
nx-switch       # Rebuild and switch
nx-update       # Update flake inputs and rebuild
nx-test         # Test build without switching
nx-diff         # Show what changed since last switch
nx-clean        # Garbage collect and optimise store
nx-rollback     # Roll back to previous generation
```

## SSH access

```bash
ssh dev@<host-ip>   # find IP with: ip a
```

## License

MIT
