{ pkgs, inputs, ... }:

{
  programs.tmux = {
    enable = true;
  };

  # Symlink main tmux.conf to gpakosz
  home.file.".tmux.conf".source = "${inputs.gpakosz-tmux}/.tmux.conf";

  # Place gpakosz defaults
  home.file.".tmux/.tmux.conf".source = "${inputs.gpakosz-tmux}/.tmux.conf";
  home.file.".tmux/.tmux.conf.local".source = "${inputs.gpakosz-tmux}/.tmux.conf.local";

  # Custom tmux config with Emacs-style keybindings
  home.file.".tmux.conf.local".text = ''
    # Import gpakosz config first
    source-file ~/.tmux/.tmux.conf.local

    # Disable window auto-rename
    set-option -g allow-rename off

    # === EMACS-STYLE TMUX CONFIGURATION ===

    # Use C-x prefix (Emacs-style)
    set -g prefix C-x
    set -g prefix2 C-x
    bind C-x send-prefix

    # Use emacs keybindings
    set -g mode-keys emacs
    set -g status-keys emacs

    # === WINDOW MANAGEMENT (Emacs-style) ===
    bind C-f next-window
    bind C-b previous-window
    bind Tab last-window

    # === PANE MANAGEMENT (Emacs-style) ===
    # C-x 2/3 for splits (like Emacs)
    bind 2 split-window -v -c "#{pane_current_path}"
    bind 3 split-window -h -c "#{pane_current_path}"

    # C-x 0/1 for pane management (like Emacs)
    bind 0 kill-pane
    bind 1 kill-pane -a

    # Pane navigation
    bind f select-pane -R
    bind b select-pane -L
    bind n select-pane -D
    bind p select-pane -U

    # C-x o to display pane numbers
    bind o display-panes
    set -g display-panes-time 4000

    # === EMACS-STYLE PANE RESIZING ===
    bind -r P resize-pane -U 2
    bind -r N resize-pane -D 2
    bind -r B resize-pane -L 2
    bind -r F resize-pane -R 2

    # === EMACS-STYLE COPY MODE ===
    bind [ copy-mode
    bind-key -T copy-mode M-w send-keys -X copy-selection-and-cancel
    bind-key -T copy-mode C-w send-keys -X copy-selection-and-cancel
    bind-key -T copy-mode C-g send-keys -X cancel
    bind-key -T copy-mode C-s send-keys -X search-forward
    bind-key -T copy-mode C-r send-keys -X search-backward
  '';
}
