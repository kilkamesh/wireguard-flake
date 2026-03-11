{ config, lib, pkgs, ... }:

{
  sops.defaultSopsFile = ./secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  
  sops.age.keyFile = "/var/lib/sops/master.age"; 

  sops.age.generateKey = false; 
  sops.secrets.wg_private_key = {};

  networking.firewall.allowedUDPPorts = [ 51820 ];

  networking.wireguard.interfaces.wg0 = {
    ips =[ "10.100.0.1/24" ];
    listenPort = 51820;

    privateKeyFile = config.sops.secrets.wg_private_key.path;

    peers =[
      {
        publicKey = "CS79xkpaXwUbjkcmf+hydjEqes+BnKy24B9stP/IYDw=";
        allowedIPs = [ "10.100.0.2/32" ];
      }
    ];
  };
}