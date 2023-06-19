{
  lib,
  pkgs,
  config,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/all-hardware.nix")
    (modulesPath + "/profiles/minimal.nix")
    (modulesPath + "/profiles/base.nix")
    ./boot.nix
    ./hardware.nix
    ./locale.nix
    ./networking.nix
    ./nix.nix
    ./security.nix
    ./users.nix
    ./tools.nix
  ];
  system.stateVersion = lib.mkForce "23.05";

  networking.hostName = "sem";
  networking.hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);
  networking.firewall.allowedTCPPorts = lib.mkDefault [
    1880 # Node-Red
    1883 # Mosquitto
    5000 # Octoprint
    3000 # Grafana
    8086 # InfluxDB
    9090 # Prometheus
  ];

  services.openssh.enable = lib.mkForce true;
  services.haveged.enable = lib.mkDefault true;
  services.fail2ban.enable = lib.mkDefault true;

  services.node-red.enable = lib.mkDefault true;
  services.influxdb2.enable = lib.mkDefault true;
  services.prometheus.enable = lib.mkDefault true;

  services.octoprint.enable = lib.mkDefault true;
  services.octoprint.plugins = plugins:
    with plugins; [
      themeify
      stlviewer
    ];
  services.octoprint.extraConfig = lib.mkDefault {
    appearance.name = "FabNet";
    api.enabled = true;
    slicing.enabled = true;
    serial = {
      port = "/dev/ttyACM0";
      autoconnect = true;
    };
    webcam = {
      stream = "http://<stream host>:<stream port>/?action=stream";
      ffmpeg = "${pkgs.ffmpeg}/bin/ffmpeg";
    };
  };

  services.grafana.enable = lib.mkDefault true;
  services.grafana.settings.server.http_port = 7878;
  services.grafana.provision.datasources.settings.datasources = lib.mkForce [
    {
      name = "influxdb";
      type = "influxdb";
      url = "http://0.0.0.0:8086";
    }
    {
      type = "prometheus";
      name = "prometheus";
      url = "http://0.0.0.0:9090";
    }
  ];

  services.mosquitto.enable = lib.mkDefault true;
  services.mosquitto.listeners = lib.mkDefault [
    {
      address = "0.0.0.0";
      acl = ["pattern readwrite #"];
      omitPasswordAuth = lib.mkDefault true;
    }
  ];
}
