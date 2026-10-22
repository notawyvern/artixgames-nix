{
  appimageTools,
  fetchurl,
  lib,
  stdenvNoCC,
  makeWrapper,
  unzip,
  pkgs,
}:

let
  pname = "ArtixGamesLauncher";
  version = "2.1.0";

  src = fetchurl {
    url = "https://chaoslabs.artix.com/Ruffle/${version}/ArtixGamesLauncher-Ruffle-${version}-linux-x64.zip";
    hash = "sha256-t4h0zDH70gtqLKhiv46r5dECs9fUWPI+5Q/9cDAYuH8=";
  };

  # since upstream is a zip, we extract
  # it before wrapping the appimage
  unpacked = stdenvNoCC.mkDerivation {
    pname = "${pname}-unpacked";
    inherit version src;
    nativeBuildInputs = [ unzip ];
    dontUnpack = true;

    installPhase = ''
      unzip "$src" -d "$out"
    '';
  };

  appimage = "${unpacked}/ArtixGamesLauncher.AppImage";

  appimageContents = appimageTools.extract {
    inherit pname version;
    src = appimage;
  };
in
appimageTools.wrapType2 {
  inherit pname version;
  src = appimage;
  extraPkgs =
    pkgs: with pkgs; [
      webkitgtk_4_1
      libsoup_3
      glib-networking
    ];
  nativeBuildInputs = [ makeWrapper ];

  # essential, so the launcher can use tls
  profile = ''
    export GIO_EXTRA_MODULES="${pkgs.glib-networking}/lib/gio/modules''${GIO_EXTRA_MODULES:+:$GIO_EXTRA_MODULES}"
  '';

  passthru = {
    inherit appimageContents;
  };

  extraInstallCommands = ''
      install -Dm444 ${appimageContents}/com.artix.GamesLauncher.desktop \
      $out/share/applications/com.artix.GamesLauncher.desktop

      cp -r ${appimageContents}/usr/* $out/

    substituteInPlace \
      $out/share/applications/com.artix.GamesLauncher.desktop \
      --replace-fail Exec=artix-games-launcher \
      Exec=$out/bin/${pname}
  '';

  meta = {
    description = "Play Artix Entertainment's Flash games with Ruffle";
    homepage = "https://www.artix.com/";
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;

    # the openness entirety of the project is unknown,
    # so unfree is included by nix standards
    license = with lib.licenses; [
      mit
      asl20
      bsd0
      bsd2
      bsd3
      cc0
      isc
      unlicense
      zlib
      mpl20
      unfree
    ];
  };
}
