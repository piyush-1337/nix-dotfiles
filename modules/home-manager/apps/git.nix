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
        merge-editor = "nvim";
      };
    };
  };
}
