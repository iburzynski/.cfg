# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{

  nix = {
    package = pkgs.nixFlakes; # or versioned attributes like nixVersions.nix_2_8
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./system76-nixos
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  networking.useDHCP = false;
  networking.interfaces.enp36s0.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console = {
  # font = "Lat2-Terminus16";
  # keyMap = "us";
    useXkbConfig = true;
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    windowManager = {
      xmonad.enable = true;
      xmonad.enableContribAndExtras = true;
    };
    displayManager.defaultSession = "none+xmonad";
    xkbOptions = "caps:escape";
  };
  
 hardware.system76 = {
   enableAll = true;
   model = "generic";
 };
 
# Specialisation to boot with with system76-power nvidia mode (for external display or to run applications requiring GPU)
  specialisation = {
    external-display.configuration = {
      system.nixos.tags = [ "external-display" ];
    # Note: nvidia driver must be enabled for xserver to start when in nvidia mode
      services.xserver.videoDrivers = [ "nvidia" ];
    };
  };

  services.picom = {
    enable = true;
    inactiveOpacity = 0.8;
    backend = "glx";
    vSync = true;
    experimentalBackends = true;

#    settings = {
#      "unredir-if-possible" = true;
#      "backend" = "xrender"; # try "glx" if xrender doesn't help
#      "vsync" = true;
#      
#    };
  }; 

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable brightness control
  programs.light.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ian = {
    isNormalUser = true;
    initialPassword = "changeme";
    extraGroups = [ "networkmanager" "wheel" "video" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    
    # Display
    linuxKernel.packages.linux_latest_libre.system76-power

    # Utils
    dconf
    direnv
    nix-direnv
    wget
    gcc
    git
    gmp
    efibootmgr
    gnome.seahorse
    gnutls
    jq
    libsodium
    light
    lm_sensors
    monitor
    ncurses
    pciutils
    scrot
    smartmontools
    systemd
    tree
    unzip
    zlib

    # WM
    dmenu
    feh
    haskellPackages.xmobar
    lxappearance
    stalonetray
    xfce.xfce4-power-manager
    xscreensaver

    # Editors
    emacs
    vscode
    anki

    # Web
    firefox
    brave
    soulseekqt
    
    # Comm
    tdesktop
    whatsapp-for-linux
    zoom-us

    # Haskell stuff
    cabal-install
    ghc
    haskell-language-server
    hlint
    cabal2nix
    niv
    nix-prefetch-git
    haskellPackages.apply-refact
    haskellPackages.hasktags
    haskellPackages.hindent
    haskellPackages.hoogle
    haskellPackages.zlib
    stylish-haskell

    # Python
    python310
    pipenv

    # Node
    nodePackages.npm

    # Deployment
    heroku

    # Other languages
    idris2
    adoptopenjdk-bin
    
    # Clojure
    clj-kondo
    clojure
    clojure-lsp
    leiningen

  ];
  environment.variables.EDITOR = "nvim";

  # Fonts
  fonts.fonts = with pkgs; [
    mononoki
    fira-code
    nerdfonts
  ];

  # Binary Cache for Haskell.nix
  nix.settings.trusted-public-keys = [
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
  ];
  nix.settings.substituters = [
    "https://cache.iog.io"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.fish.enable = true;
  programs.mtr.enable = true;
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.steam.enable = true;

  # List services that you want to enable:
  services.autorandr.enable = true;
  services.gnome.gnome-keyring.enable = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Nix settings
  nix.settings.auto-optimise-store = true;
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}
