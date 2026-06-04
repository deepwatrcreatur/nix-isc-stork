{
  autoPatchelfHook,
  binutils,
  fetchFromGitHub,
  fetchurl,
  lib,
  stdenvNoCC,
  stdenv,
}:
let
  upstreamVersion = "2.4.0";

  src = fetchFromGitHub {
    owner = "isc-projects";
    repo = "stork";
    rev = "v${upstreamVersion}";
    hash = "sha256-n8GQ/yAZXIVjcm5Za8GkAyancEl77ziXvbWKq7pZWXg=";
  };

  mkSourceBoundary =
    {
      pname,
      sourcePath,
      entrypoint ? null,
      description,
    }:
    stdenvNoCC.mkDerivation {
      inherit pname src;
      version = upstreamVersion;
      dontUnpack = true;

      installPhase = ''
        runHook preInstall

        mkdir -p "$out/share/${pname}"
        cp -R "${src}/${sourcePath}/." "$out/share/${pname}/"

        mkdir -p "$out/nix-support"
        cat > "$out/nix-support/source-boundary.json" <<'EOF'
        ${builtins.toJSON {
          version = upstreamVersion;
          inherit sourcePath entrypoint description;
        }}
        EOF

        runHook postInstall
      '';

      meta = {
        inherit description;
        homepage = "https://stork.isc.org";
        license = lib.licenses.mpl20;
        platforms = lib.platforms.unix;
      };
    };

  mkDebPackage =
    {
      pname,
      version,
      sha256,
      filename,
      description,
      mainProgram,
    }:
    stdenvNoCC.mkDerivation {
      inherit pname version;

      src = fetchurl {
        url = "https://dl.cloudsmith.io/public/isc/stork/deb/debian/${filename}";
        hash = sha256;
      };

      nativeBuildInputs = [
        autoPatchelfHook
        binutils
      ];

      buildInputs = [ stdenv.cc.cc.lib ];
      dontUnpack = true;

      installPhase = ''
        runHook preInstall

        workdir="$(mktemp -d)"
        trap 'rm -rf "$workdir"' EXIT
        cd "$workdir"

        ar x "$src"
        mkdir -p "$out"
        tar -xzf data.tar.gz -C "$out"

        runHook postInstall
      '';

      meta = {
        inherit description mainProgram;
        homepage = "https://stork.isc.org";
        license = lib.licenses.mpl20;
        platforms = [ "x86_64-linux" ];
      };
    };
in
rec {
  inherit src;
  version = upstreamVersion;

  isc-stork-source-layout = stdenvNoCC.mkDerivation {
    pname = "isc-stork-source-layout";
    inherit src;
    version = upstreamVersion;
    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/share/isc-stork"
      cp -R "${src}/." "$out/share/isc-stork/src"

      mkdir -p "$out/nix-support"
      cat > "$out/nix-support/source-layout.json" <<'EOF'
      ${builtins.toJSON {
        version = upstreamVersion;
        backendCmds = [
          "backend/cmd/stork-server"
          "backend/cmd/stork-agent"
          "backend/cmd/stork-tool"
          "backend/cmd/stork-code-gen"
        ];
        uiPath = "webui";
        orchestrator = "Rakefile";
      }}
      EOF

      runHook postInstall
    '';

    meta = {
      description = "Pinned ISC Stork upstream source tree with packaging-boundary metadata";
      homepage = "https://stork.isc.org";
      license = lib.licenses.mpl20;
      platforms = lib.platforms.unix;
    };
  };

  isc-stork-server-src = mkSourceBoundary {
    pname = "isc-stork-server-src";
    sourcePath = "backend";
    entrypoint = "cmd/stork-server";
    description = "ISC Stork backend source boundary for the stork-server binary";
  };

  isc-stork-agent-src = mkSourceBoundary {
    pname = "isc-stork-agent-src";
    sourcePath = "backend";
    entrypoint = "cmd/stork-agent";
    description = "ISC Stork backend source boundary for the stork-agent binary";
  };

  isc-stork-ui-src = mkSourceBoundary {
    pname = "isc-stork-ui-src";
    sourcePath = "webui";
    description = "ISC Stork web UI source boundary for staged npm packaging";
  };

  isc-stork-server = mkDebPackage {
    pname = "isc-stork-server";
    version = "2.4.0.260218163504";
    sha256 = "sha256-VnnYr4/v5rnr5ZhZY9V/6belBxgLGt2l6bHJ7rQXe2Y=";
    filename = "pool/any-version/main/i/is/isc-stork-server_2.4.0.260218163504/isc-stork-server_2.4.0.260218163504_amd64.deb";
    description = "ISC Stork server daemon and UI assets repackaged from the official Debian package";
    mainProgram = "stork-server";
  };

  isc-stork-agent = mkDebPackage {
    pname = "isc-stork-agent";
    version = "2.4.0.260218163426";
    sha256 = "sha256-5gys6Jfx1e1ZOelYONNIUMoSOjCiQg2r8Qy1GOePWJs=";
    filename = "pool/any-version/main/i/is/isc-stork-agent_2.4.0.260218163426/isc-stork-agent_2.4.0.260218163426_amd64.deb";
    description = "ISC Stork agent daemon repackaged from the official Debian package";
    mainProgram = "stork-agent";
  };
}
