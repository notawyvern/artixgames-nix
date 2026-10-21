# Artix Games Launcher for Nix

- [About](#about)
- [Testing](#testing)
- [Install](#install)

## About

This developer is not affiliated with AE. The executable is the unmodified original client, not a third-party application. The repository simplifies installing it. Only the x86_64 Linux arch is supported. The ruffle version of the launcher is used.

## Testing

Through Nix, this one-liner can run the package before install:

```sh
nix run github:notawyvern/artixgames-nix
```

## Install

Inherit inputs and use flakes or adapt it accordingly:

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
