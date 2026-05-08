{
  buildGoModule,
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:
let
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "isc-projects";
    repo = "stork";
    rev = "v${version}";
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
      inherit pname version src;
      dontUnpack = true;

      installPhase = ''
        runHook preInstall

        mkdir -p "$out/share/${pname}"
        cp -R "${src}/${sourcePath}/." "$out/share/${pname}/"

        mkdir -p "$out/nix-support"
        cat > "$out/nix-support/source-boundary.json" <<'EOF'
        ${builtins.toJSON {
          inherit version sourcePath entrypoint description;
        }}
        EOF

        runHook postInstall
      '';

      meta = {
        inherit description;
        homepage = "https://stork.readthedocs.io";
        license = lib.licenses.asl20;
        platforms = lib.platforms.unix;
      };
    };

  commonGoArgs = {
    inherit version src;
    sourceRoot = "${src.name}/backend";
    vendorHash = "sha256-yLC3cDORzVJw3m6kZ+L7TjMZBmWCJyV1J5G/jRegM6c=";
    proxyVendor = true;
    doCheck = false;
  };
in
rec {
  inherit src version;

  isc-stork-source-layout = stdenvNoCC.mkDerivation {
    pname = "isc-stork-source-layout";
    inherit version src;
    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/share/isc-stork"
      cp -R "${src}/." "$out/share/isc-stork/src"

      mkdir -p "$out/nix-support"
      cat > "$out/nix-support/source-layout.json" <<'EOF'
      ${builtins.toJSON {
        inherit version;
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
      homepage = "https://stork.readthedocs.io";
      license = lib.licenses.asl20;
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

  isc-stork-server = buildGoModule (commonGoArgs // {
    pname = "isc-stork-server";
    subPackages = [ "cmd/stork-server" ];

    ldflags = [
      "-s"
      "-w"
      "-X isc.org/stork/backend/version.Version=v${version}"
    ];

    meta = {
      description = "ISC Stork server daemon";
      homepage = "https://stork.readthedocs.io";
      license = lib.licenses.asl20;
      mainProgram = "stork-server";
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
    };
  });

  isc-stork-agent = buildGoModule (commonGoArgs // {
    pname = "isc-stork-agent";
    subPackages = [ "cmd/stork-agent" ];

    ldflags = [
      "-s"
      "-w"
      "-X isc.org/stork/backend/version.Version=v${version}"
    ];

    postInstall = ''
      if [ -f "$src/etc/isc-stork-agent.service" ]; then
        install -Dm644 "$src/etc/isc-stork-agent.service" \
          "$out/share/systemd/examples/isc-stork-agent.service"
      fi
    '';

    meta = {
      description = "ISC Stork agent daemon";
      homepage = "https://stork.readthedocs.io";
      license = lib.licenses.asl20;
      mainProgram = "stork-agent";
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
    };
  });
}
