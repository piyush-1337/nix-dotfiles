{ pkgs, ... }:

{

  programs.fish = {
    enable = true;
    shellAliases = {
      c = "clear";
      nrs = "sudo nixos-rebuild switch --flake /etc/nixos-dotfiles#piyushbtw -L";
      nfu = "sudo nix flake update --flake /etc/nixos-dotfiles/";
    };
    functions = {
      mkcd = "mkdir -p $argv[1]; and cd $argv[1]";
    };
    interactiveShellInit = ''
      # Set fish cursor to vi-style (Kitty properly restores this after Neovim exits)
      set -g fish_cursor_default block
      set -g fish_cursor_insert line
      set -g fish_cursor_replace_one underscore
      set -g fish_cursor_visual block

      # Rebind Alt+Backspace (and Ctrl+W) to stop at punctuation like '#' (Bash behavior)
      bind \e\x7f backward-kill-word
      bind \e\b backward-kill-word
      bind \cw backward-kill-word

      if status is-interactive
        and not set -q TMUX
        # Creates a new session and replaces the fish process with it
        exec ${pkgs.tmux}/bin/tmux new-session
      end
    '';
  };
}
