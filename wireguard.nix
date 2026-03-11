{ config, lib, pkgs, ... }:

let
  cfg = config.services.wg;
in {
  options.services.wg = {
    enable = lib.mkEnableOption "My WireGuard service";
    vpnOnlyPorts = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    sops.defaultSopsFile = ./secrets.yaml;
    sops.defaultSopsFormat = "yaml";
    sops.age.keyFile = "/var/lib/sops/master.age";
    sops.age.generateKey = false;
    sops.secrets.wg_private_key = {};

    networking.firewall = {
      enable = true;
      allowedUDPPorts = [ 51820 ];
      extraCommands = lib.concatStringsSep "\n" (map (port: ''
        iptables -I INPUT -p tcp --dport ${toString port} -s 10.100.0.0/24 -j ACCEPT
        iptables -I INPUT -p tcp --dport ${toString port} -j DROP
      '') cfg.vpnOnlyPorts);
    };

    networking.wireguard.interfaces.wg0 = {
      ips = [ "10.100.0.1/24" ];
      listenPort = 51820;
      privateKeyFile = config.sops.secrets.wg_private_key.path;
      peers = [{
        publicKey = "CS79xkpaXwUbjkcmf+hydjEqes+BnKy24B9stP/IYDw=";
        allowedIPs = [ "10.100.0.2/32" ];
      }];
    };
  };
}