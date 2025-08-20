{
  config, lib, pkgs,... }:
let
in
{
  imports = [
          ./hardware-configuration.nix
  ];

  boot.loader.grub = {
    efiSupport = false;
    device="/dev/vda";
  };

  networking.hostName = "deb-nix";
  networking.useDHCP = false;
  networking.bridges = {
    "br0" = {
      interfaces = [ "enp1s0" ];
    };
  };

  networking.interfaces.br0.ipv4.addresses = [ {
    address = "192.168.122.30";
    prefixLength = 24;
  } ];

  networking.defaultGateway = "192.168.122.1";
  networking.nameservers = [ "192.168.122.1" ];

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "fr_FR.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
    useXkbConfig = false;
  };

  environment.systemPackages = with pkgs; [
    wget
    vim
    htop
    bridge-utils
    git
    wireguard-tools
    iptables
    dig
    xfsprogs
    btrfs-progs
    nmap
    fwupd
    liquidprompt
  ];

  services.openssh.enable = true;

  users.users.root.initialPassword = "password";

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMy0zk45FEZIRfYolYTXmFaTmNB13QoQJBwRBc/iEyMZ emil@asn"
  ];


  environment.etc."bashrc.local"= {
    text = ''
      if [[ -r ${pkgs.liquidprompt}/bin/liquidprompt ]]; then
         . ${pkgs.liquidprompt}/bin/liquidprompt
      fi
    '';
  };


  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05";
}
