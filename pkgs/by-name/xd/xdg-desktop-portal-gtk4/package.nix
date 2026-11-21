{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  glib,
  gtk4,
  dbus,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xdg-desktop-portal-gtk4";
  version = "1.6.6";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "JohnRTitor";
    repo = "xdg-desktop-portal-gtk4";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F15UsZx/mqcHAxVbDkpYpDOqTxKvrUNGXY/D8FzyWcQ=";
  };

  cargoHash = "sha256-ZbYZCshfrj60tPt0HEMMyp4fO7ZXCWiHaCBs69ZPORA=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
  ];

  nativeCheckInputs = [ dbus ];

  # D-Bus tests are skipped without a session: ${src}/tests/common/mod.rs#L17
  preCheck = ''
    dbus-daemon --config-file=${dbus}/share/dbus-1/session.conf --fork \
      --print-address=3 --print-pid=4 3>dbus-address 4>dbus-pid
    export DBUS_SESSION_BUS_ADDRESS=$(<dbus-address)
  '';

  postCheck = ''
    kill $(<dbus-pid)
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "CARGO_TARGET_DIR=target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  dontCargoInstall = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Portal backend for xdg-desktop-portal using GTK4";
    homepage = "https://github.com/JohnRTitor/xdg-desktop-portal-gtk4";
    changelog = "https://github.com/JohnRTitor/xdg-desktop-portal-gtk4/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ haansn08 ];
    platforms = lib.platforms.linux;
  };
})
