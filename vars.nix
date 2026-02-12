{
  username = "dev";
  fullName = "dev";
  email = "dev@site.com";

  hosts = {
    nixos = {
      hostname = "nixos";
      profile = "gui";
      flakePath = "~/shared/nix-dotfiles";
    };
    headless = {
      hostname = "headless";
      profile = "headless";
      flakePath = "~/shared/nix-dotfiles";
    };
  };
}
