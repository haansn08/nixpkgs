{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ctestCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tugz";
  version = "1.3.0";

  outputs = [
    "out"
    "dev"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "skeeto";
    repo = "tugz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ME42ejmUjSFhsyBp2zyz2Zk2Dxty40IjhvQwBcbCh+w=";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  cmakeFlags = [
    (lib.cmakeBool "TUGZ_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  nativeCheckInputs = [ ctestCheckHook ];

  disabledTests = [
    # creates a setuid file, which the sandbox forbids
    "gzip-cli"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tiny unity gzip/zip";
    homepage = "https://github.com/skeeto/tugz";
    changelog = "https://github.com/skeeto/tugz/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ haansn08 ];
    platforms = lib.platforms.unix;
    mainProgram = "gzip";
  };
})
