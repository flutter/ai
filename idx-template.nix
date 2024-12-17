{ pkgs, ... }: {
  packages = [
    pkgs.curl
    pkgs.unzip
  ];
  bootstrap = ''
    mkdir "$out"
    cp -rf ${./.}/* "$out"
    mkdir "$out/.idx"
    mkdir "$out/.vscode"
    cp -rf ${./.}/.idx "$out"
    cp -rf ${./.}/.vscode "$out"
    cp -rf ${./.}/README.md "$out"
    cp -rf ${./.}/CHANGELOG.md "$out"
    cp -rf ${./.}/LICENSE "$out"
    cp -rf ${./.}/pubspec.yaml "$out"
    cp -rf ${./.}/analysis_options.yaml "$out"
    cp -rf ${./.}/.metadata "$out"
    cp -rf ${./.}/.gitignore "$out"
    rm "$out/idx-template.nix"
    rm "$out/idx-template.json"
    chmod -R u+w "$out"
  '';
}
