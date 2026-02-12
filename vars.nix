{
  username = "dev";
  fullName = "dev";
  email = "dev@site.com";

  hosts = {
    nixos = {
      hostname = "nixos";
      profile = "gui";
      platform = "aarch64-linux";
      flakePath = "~/shared/nix-dotfiles";
    };
    headless = {
      hostname = "headless";
      profile = "headless";
      platform = "aarch64-linux";
      flakePath = "~/shared/nix-dotfiles";
    };
  };
}
