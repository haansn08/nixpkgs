{
  stdenv,
  lib,
  fetchFromGitLab,
  cmake,
  pkg-config,
  kdePackages,
  ctestCheckHook,
  withGstreamer ? true,
  gst_all_1,
  withOmemo ? true,
  libomemo-c,
  withEncryption ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qxmpp";
  version = "1.16.2";

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = "qxmpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SI8ANd3tsdDLwBbqVnvbPy4BafBmM2PdaYEbhZ9Wl9M=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.wrapQtAppsHook
    kdePackages.extra-cmake-modules
    (kdePackages.qttools.override { withClang = true; })
  ]
  ++ lib.optionals (withGstreamer || withOmemo) [
    pkg-config
  ];
  buildInputs =
    lib.optionals withGstreamer (
      with gst_all_1;
      [
        gstreamer
        gst-plugins-bad
        gst-plugins-base
        gst-plugins-good
      ]
    )
    ++ lib.optionals withOmemo [
      kdePackages.qtbase
      kdePackages.qca
      libomemo-c
    ];
  cmakeFlags = [
    (lib.cmakeBool "BUILD_DOCUMENTATION" true)
    (lib.cmakeBool "BUILD_EXAMPLES" false)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
    (lib.cmakeBool "BUILD_OMEMO" withOmemo)
    (lib.cmakeBool "WITH_ENCRYPTION" withEncryption)
    (lib.cmakeBool "WITH_GSTREAMER" withGstreamer)
  ];

  doCheck = true;
  nativeCheckInputs = [ ctestCheckHook ];
  disabledTests = [
    "tst_QXmppIceConnection"
    "tst_QXmppTransferManager"
  ];

  DOC_DESTDIR = "$outputDoc";

  meta = {
    description = "Cross-platform C++ XMPP client and server library";
    changelog = "https://invent.kde.org/libraries/qxmpp/-/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    homepage = "https://invent.kde.org/libraries/qxmpp";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [
      astro
      haansn08
    ];
    platforms = with lib.platforms; linux;
  };
})
