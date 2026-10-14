{
  appimageTools,
  fetchurl,
  lib,
}:

let
  pname = "ArtixGamesLauncher";
  version = "2.0.5";

  src = fetchurl {
    # the latest pinnable version. further ones, as of october
    # 2026, break reproducibility through a mutable latest tag.
    url = "https://launch.artix.com/archives/Artix_Games_Launcher-x86_64_2_0_5.AppImage";
    hash = "sha256-umnUjit37tzV7Mwdr0n6yGRq8t/AkfrabnZVVnuXvg0=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  /*
    the icon size is two times it,
    but 512x512 is freedesktop standard
  */
  extraInstallCommands = ''
    install -Dm444 \
    ${appimageContents}/ArtixGamesLauncher.desktop \
      -t $out/share/applications/

    install -Dm444 \
    ${appimageContents}/ArtixLogo.png \
      -t $out/share/icons/hicolor/512x512/apps/
    substituteInPlace \
      $out/share/applications/ArtixGamesLauncher.desktop \
      --replace-fail 'Exec=ArtixGameLauncher %u' Exec=$out/bin/ArtixGamesLauncher\ %u
  '';

  meta = {
    description = "Artix Games Launcher";
    homepage = "https://www.artix.com/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
