{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "tmux-256color";
    prefix = "C-Space";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 50000;
    mouse = true;
    keyMode = "vi";

    # Plugins managed by Nix
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      # resurrect
      cpu
    ];

    extraConfig = ''
      # Enable true-color support and cursor shape passthrough
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'

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

      # Theme (Nord)
      bg="default"
      default_fg="#D8DEE9" 
      session_fg="#A3BE8C"
      session_selection_fg="#3B4252"
      session_selection_bg="#81A1C1"
      active_window_fg="#88C0D0"
      active_pane_border="#abb2bf"

      set -g status-left-length 200
      set -g status-right-length 200
      set -g status-left "#[fg=''${session_fg},bold,bg=''${bg}] #S #[fg=''${default_fg},nobold,bg=''${bg}] | "
      set -g status-right " #{cpu_percentage}   #{ram_percentage} "
      set -g status-justify centre
      set -g status-style "bg=''${bg}"
      set -g window-status-format "#[fg=''${default_fg},bg=default] #I:#W"
      set -g window-status-current-format "#[fg=''${active_window_fg},bold,bg=default]  #[underscore]#I:#W"
      set -g window-status-last-style "fg=''${default_fg},bg=default"
      set -g message-command-style "bg=default,fg=''${default_fg}"
      set -g message-style "bg=default,fg=''${default_fg}"
      set -g mode-style "bg=''${session_selection_bg},fg=''${session_selection_fg}"
      set -g pane-active-border-style "fg=''${active_pane_border},bg=default"
      set -g pane-border-style "fg=brightblack,bg=default"

      # Resurrect settings
      # set -g @resurrect-capture-pane-contents 'on'

      # Force load the cpu plugin script after the status line is set by the theme above
      run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
    '';
  };
}
