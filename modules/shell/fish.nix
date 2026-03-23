{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "screen-256color";
    prefix = "C-Space";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 50000;
    mouse = true;
    keyMode = "vi";

    # Plugins managed by Nix
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      resurrect
      {
        plugin = cpu;
        extraConfig = "set -g @plugin 'hendrikmi/tmux-cpu-mem-monitor'";
      }
    ];

    extraConfig = ''
      # Enable true-color support
      set -ga terminal-overrides ",*256col*:Tc"

      # General
      set -g set-clipboard on
      set -g detach-on-destroy off
      set -g status-interval 3
      set -gq allow-passthrough on
      set -g status-position bottom
      set-option -g focus-events on
      set -g visual-activity off

      # Panes start at 1
      set -g pane-base-index 1
      set -g renumber-windows on

      # Keybindings
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf

      # Split in CWD
      unbind %
      bind \\ split-window -h -c "#{pane_current_path}"
      unbind \"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # Resize panes
      bind -r j resize-pane -D 5
      bind -r k resize-pane -U 5
      bind -r l resize-pane -R 5
      bind -r h resize-pane -L 5
      bind -r m resize-pane -Z

      # Copy Mode
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind -T copy-mode-vi 'y' send-keys -X copy-pipe-and-cancel "${pkgs.wl-clipboard}/bin/wl-copy"
      bind P paste-buffer
      unbind -T copy-mode-vi MouseDragEnd1Pane

      # Hide status bar
      bind b set-option -g status

      # Advanced Pane Management
      bind J command-prompt -p "Join pane from window:" "join-pane -h -s '%%'"
      bind B command-prompt -p "Break pane to window:" "break-pane -t '%%'"
      bind M command-prompt -p "Move current window to:" "move-window -t '%%'"
      bind H select-layout even-horizontal
      bind V select-layout even-vertical

      # Theme
      source-file ~/.config/tmux/nord-theme.conf

      # Resurrect settings
      set -g @resurrect-capture-pane-contents 'on'
    '';
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      c = "clear";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#piyushbtw";
      nfu = "sudo nix flake update --flake ~/nixos-dotfiles/";
    };
    functions = {
      mkcd = "mkdir -p $argv[1]; and cd $argv[1]";
    };
    interactiveShellInit = ''
      if status is-interactive
        and not set -q TMUX
        # Creates a new session and replaces the fish process with it
        exec ${pkgs.tmux}/bin/tmux new-session
      end
    '';
  };
}
