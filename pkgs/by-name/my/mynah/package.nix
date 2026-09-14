{
lib,
python3Packages,
fetchFromForgejo,

gobject-introspection,
wrapGAppsHook4,

writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mynah";
  version = "0.2.1";
  pyproject = true;
  __structuredAttrs = true;
  
  src = fetchFromForgejo {
    domain = "forge.starlightnet.work";
    owner = "Team";
    repo = "Mynah";
    tag = finalAttrs.version;
    hash = "sha256-r5lsSwb1BtNE0XyroB6rDliOK4604DTXTX2JeqrvHMs=";
  };
  
  #patches = [ ./entrypoint.patch ];
  
  postPatch = ''
mkdir -p src/constants src/mynah
mv __init__.py __main__.py src/mynah/
mv logic src/
mv ui src/
mv constants.py src/constants/__init__.py
  '';
  
  pythonRelaxDeps = true;
  
  build-system = [ python3Packages.setuptools ];
  
  dependencies = with python3Packages; [
    aiodns
    humanize
    janus
    keyring
    packaging
    platformdirs
    pygobject3
    setuptools
    slixmpp
    sqlcipher3
    typeguard
  ];
  
  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook4
  ];
  
  nativeCheckInputs = [ 
    writableTmpDirAsHomeHook
    python3Packages.pytestCheckHook
  ];
  enabledTestPaths = [ "tests.py" ];
  
  
})
