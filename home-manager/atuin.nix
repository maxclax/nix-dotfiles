{ pkgs, ... }:

{
  # Atuin Configuration
  programs.atuin = {
    enable = true;

    settings = {
      # Main settings
      auto_sync = true;
      sync_frequency = "5m";
      search_mode = "fuzzy";
      filter_mode = "global";
      enter_accept = false;
      show_preview = true;
      style = "compact";
      inline_height = 20;

      # Better defaults
      update_check = false;
      secrets_filter = true;
      workspaces = true;

      # History filter
      history_filter = [
        "^secret-cmd"
        "^innocuous-cmd .*--secret=.+"
        "^ls$"
        "^pwd$"
        "^exit$"
        "^clear$"
        "^history$"
      ];

      # Stats configuration
      stats = {
        common_subcommands = [
          "apt"
          "cargo"
          "chezmoi"
          "composer"
          "dnf"
          "docker"
          "git"
          "go"
          "home-manager"
          "ip"
          "kubectl"
          "nix"
          "nix-env"
          "nmcli"
          "npm"
          "pecl"
          "pnpm"
          "podman"
          "port"
          "sudo"
          "systemctl"
          "tmux"
          "yarn"
        ];

        ignored_commands = [
          "cd"
          "ls"
          "pwd"
          "exit"
          "clear"
        ];
      };

      # Sync configuration
      sync = {
        records = true;
      };

      # Preview configuration
      preview = {
        strategy = "auto";
      };

      # Daemon configuration
      daemon = {
        enabled = false;
        sync_frequency = 300;
      };
    };
  };
}
