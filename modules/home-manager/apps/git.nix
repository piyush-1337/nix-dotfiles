{ ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "piyush-1337";
        email = "piyushkatkar9421@gmail.com";
      };

      core = {
        sshCommand = "ssh -i ~/.ssh/id_ed25519";
      };

      init.defaultBranch = "main";
    };
  };

  programs.jujutsu = {
    enable = true;

    settings = {
      user = {
        name = "piyush-1337";
        email = "piyushkatkar9421@gmail.com";
      };

      ui = {
        editor = "nvim";
        # merge-editor = "nvim";
        default-command = "log";
      };

      # merge-tools = {
      #   nvim = {
      #     program = "nvim";
      #     merge-args = [
      #       "-f"
      #       "-d"
      #       "$output"
      #       "-M"
      #       "$left"
      #       "$base"
      #       "$right"
      #       "-c"
      #       "wincmd J"
      #       "-c"
      #       "set modifiable"
      #       "-c"
      #       "set write"
      #     ];
      #     merge-tool-edits-conflict-markers = true;
      #   };
      # };
    };
  };
}
