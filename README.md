# Artix Games Launcher for Nix

- [About](#about)
- [Testing](#testing)
- [Install](#install)

## About

This developer is not affiliated with AE. The executable is the unmodified original client, not a third-party application. The repository simplifies installing it. Only the x86_64 Linux arch is currently supported.

## Testing

Through Nix, this one-liner can run the package before install:

```sh
NIXPKGS_ALLOW_UNFREE=1 nix run --impure github:notawyvern/artixgames-nix
```

## Install

After [allowing unfree packages](https://wiki.nixos.org/wiki/Unfree_software) and inheriting inputs, use flakes or adapt it accordingly:

```nix
inputs = {
    artixgames.url = "github:notawyvern/artixgames-nix";
    artixgames.inputs.nixpkgs.follows = "nixpkgs";
};
```

```nix
enviroment.systemPackages = [
    inputs.artixgames.packages.${pkgs.stdenv.hostPlatform.system}.default
];
```
