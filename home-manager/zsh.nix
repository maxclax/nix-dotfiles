{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
    };

    completionInit = "autoload -Uz compinit && compinit -C";

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "colored-man-pages"
        "command-not-found"
        "sudo"
        "history"
      ];
    };

    shellAliases = {
      reload-shell = "exec $SHELL";
      r = "ranger .";
      y = "yazi .";
      br = "broot";
      ll = "eza --long --header --group-directories-first --git --group --all --color=auto";
      tree = "tree -C";
      t = "tree -C -L 2";
      t3 = "tree -C -L 3";
    };

    initContent = ''
      # Fallback for unknown terminal definitions (e.g. Ghostty via SSH)
      if [[ -n "$TERM" ]] && ! infocmp "$TERM" &>/dev/null; then
        export TERM=xterm-256color
      fi

      if [[ "$TERM" == "dumb" ]]; then
          PS1='$ '
          return
      fi

      # Completion using arrow keys (based on history)
      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward

      # Source additional configurations from .zshrc.local
      if [ -f ~/.zshrc.local ]; then
        source ~/.zshrc.local
      fi
    '';
  };
}
