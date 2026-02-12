{ config, pkgs, lib, ... }:

let
  mod = "Mod1"; # Alt key (Mod4/Super conflicts with Aerospace on macOS host)
in
{
  home.packages = with pkgs; [
    dmenu
    i3status
  ];

  xsession.windowManager.i3 = {
    enable = true;

    config = {
      modifier = mod;
      terminal = "xterm";

      startup = [
        { command = "${pkgs.spice-vdagent}/bin/spice-vdagent -x"; notification = false; always = true; }
      ];

      keybindings = lib.mkOptionDefault {
        "${mod}+Return" = "exec xterm";
        "${mod}+d" = "exec dmenu_run";
        "${mod}+Shift+q" = "kill";

        # Focus
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        # Move
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";

        # Splits
        "${mod}+b" = "split h";
        "${mod}+v" = "split v";

        # Layouts
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";
        "${mod}+f" = "fullscreen toggle";

        # Floating
        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space" = "focus mode_toggle";

        # Workspaces
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";

        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";

        # Restart / reload
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+r" = "restart";
        "${mod}+Shift+e" = "exec i3-nagbar -t warning -m 'Exit i3?' -B 'Yes' 'i3-msg exit'";
      };

      bars = [
        {
          position = "bottom";
          statusCommand = "${pkgs.i3status}/bin/i3status";
          colors = {
            background = "#282828";
            statusline = "#ebdbb2";
            separator = "#666666";
            focusedWorkspace = {
              border = "#458588";
              background = "#458588";
              text = "#ebdbb2";
            };
            inactiveWorkspace = {
              border = "#282828";
              background = "#282828";
              text = "#928374";
            };
            urgentWorkspace = {
              border = "#cc241d";
              background = "#cc241d";
              text = "#ebdbb2";
            };
          };
        }
      ];

      gaps = {
        inner = 6;
        outer = 2;
      };

      defaultWorkspace = "workspace number 1";

      colors = {
        focused = {
          border = "#458588";
          background = "#458588";
          text = "#ebdbb2";
          indicator = "#83a598";
          childBorder = "#458588";
        };
        unfocused = {
          border = "#282828";
          background = "#282828";
          text = "#928374";
          indicator = "#282828";
          childBorder = "#282828";
        };
        focusedInactive = {
          border = "#3c3836";
          background = "#3c3836";
          text = "#a89984";
          indicator = "#3c3836";
          childBorder = "#3c3836";
        };
        urgent = {
          border = "#cc241d";
          background = "#cc241d";
          text = "#ebdbb2";
          indicator = "#cc241d";
          childBorder = "#cc241d";
        };
      };
    };
  };

  xdg.configFile."i3status/config".text = ''
    general {
        colors = true
        color_good = "#b8bb26"
        color_degraded = "#fabd2f"
        color_bad = "#fb4934"
        interval = 5
    }

    order += "cpu_usage"
    order += "memory"
    order += "disk /"
    order += "ethernet _first_"
    order += "tztime local"

    cpu_usage {
        format = " CPU: %usage "
    }

    memory {
        format = " MEM: %used / %total "
        threshold_degraded = "10%"
        threshold_critical = "5%"
    }

    disk "/" {
        format = " DISK: %avail "
    }

    ethernet _first_ {
        format_up = " ETH: %ip "
        format_down = " ETH: down "
    }

    tztime local {
        format = " %Y-%m-%d %H:%M:%S "
    }
  '';
}
