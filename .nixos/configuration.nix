#}} Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{

  nix = {
    package = pkgs.nixFlakes; # or versioned attributes like nixVersions.nix_2_8
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      allow-import-from-derivation = true;
      auto-optimise-store = true;
      keep-derivations = true;
      keep-outputs = true;
      trusted-users = [ "root" "ian" ];
      # Binary Caches
      substituters = [
        "https://cache.iog.io"
        "https://iohk.cachix.org"
        "https://cache.zw3rk.com"
      ];
      trusted-public-keys = [
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "loony-tools:pr9m4BkM/5/eSTZlkQyRt57Jz7OMBxNSUiMC4FkcNfk="
        "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
      ];
    }; 
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./system76-nixos
      <home-manager/nixos>
    ];

  hardware = {
    system76 = {
      enableAll = true;
      model = "default";
    };
    pulseaudio.enable = true;
    bluetooth.enable = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces = {
      enp36s0.useDHCP = true;
      wlp0s20f3.useDHCP = true;
    };
  # Configure network proxy if necessary
  # proxy.default = "http://user:password@proxy:port/";
  # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # Open ports in the firewall.
  # firewall.allowedTCPPorts = [ ... ];
  # firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # firewall.enable = false;
  };
  
  sound.enable = true;
  time.timeZone = "America/New_York";
  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";

  console = {
  # font = "Lat2-Terminus16";
  # keyMap = "us";
    useXkbConfig = true;
  };

# Specialisation to boot with with system76-power nvidia mode (for external display or to run applications requiring GPU)
  specialisation = {
    external-display.configuration = {
      system.nixos.tags = [ "external-display" ];
    # Note: nvidia driver must be enabled for xserver to start when in nvidia mode
      services.xserver.videoDrivers = [ "nvidia" ];
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ian = {
    isNormalUser = true;
    initialPassword = "changeme";
    extraGroups = [ "networkmanager" "wheel" "video" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };
  
  # Packages installed in system profile
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    
    # Display
    # linuxKernel.packages.linux_latest_libre.system76-power

    # Drivers
    # pentablet-driver

    # Utils
    dconf
    direnv
    evtest
    nix-direnv
    wget
    freeglut
    gcc
    git
    gmp
    efibootmgr
    gnutls
    httpie
    jq
    libsodium
    libsodium.dev
    libtool
    light
    lm_sensors
    monitor
    ncurses
    pciutils
    pkg-config
    scrot
    smartmontools
    systemd
    tree
    unixtools.xxd
    unzip
    usbutils
    xclip
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

    firefox

    # Haskell stuff
    cabal-install
    ghc
    haskell-language-server
    hlint
    niv
    haskellPackages.apply-refact
    haskellPackages.hasktags
    haskellPackages.hindent
    haskellPackages.hoogle
    haskellPackages.zlib

    # JS stuff
    nodejs
    nodePackages.npm
    yarn

    # Deployment
    docker-compose
    heroku

    # Other languages
    kotlin
    openjdk17-bootstrap
    
    # Clojure
    # clj-kondo
    # clojure
    # clojure-lsp
    # leiningen

  ];
  # environment.variables.EDITOR = "nvim";

  virtualisation.docker.enable = true;

  # Fonts
  fonts.fonts = with pkgs; [
    mononoki
    fira-code
    inter
    nerdfonts
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    fish.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    light.enable = true; # Enable brightness control
    mtr.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  # steam.enable = true;
  };
  
  services = {
    autorandr.enable = true;
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;
    openssh.enable = true;
    
    picom = {
      enable = true;
      inactiveOpacity = 0.8;
      backend = "glx";
      vSync = true;
    # experimentalBackends = true;
    }; 
    
    # printing.enable = true; # Enable CUPS to print documents.
    
    # XP-Pen Tablet
    udev.extraHwdb = ''
      evdev:input:b0003v28BDp0905*
        KEYBOARD_KEY_70016=z
        KEYBOARD_KEY_700e2=leftctrl
        KEYBOARD_KEY_7001d=y
        KEYBOARD_KEY_7002c=p
        KEYBOARD_KEY_7000c=e
        KEYBOARD_KEY_70008=v
        KEYBOARD_KEY_70005=backspace
        KEYBOARD_KEY_d0044=0x14c
        KEYBOARD_KEY_d0045=0x14b
    '';
    
    xserver = {
      enable = true;
    # digimend.enable = true; # Enable digimend driver for XP Pen tablet
      windowManager = {
        xmonad = {
          enable = true;
      	  enableContribAndExtras = true;
	  extraPackages = haskellPackages : [
	    haskellPackages.xmonad-contrib
	    haskellPackages.xmonad-extras
	    haskellPackages.xmonad
	    ];
        };
      };
      displayManager.defaultSession = "none+xmonad";
      xkbOptions = "caps:escape";
    
      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;
    
      # XP-Pen Tablet
      inputClassSections = [
        ''
          Identifier "XP-Pen 10 inch PenTablet"
          MatchUSBID "28bd:0905"
          MatchIsTablet "on"
          MatchDevicePath "/dev/input/event*"
          Driver "wacom"
          Option "Rotate" "HALF"
          Option "Button3" "0"
        ''
        ''
          Identifier "XP-Pen 10 inch PenTablet"
          MatchUSBID "28bd:0905"
          MatchIsKeyboard "on"
          MatchDevicePath "/dev/input/event*"
          Driver "libinput"
        ''
      ];
    };
  };
  home-manager.useGlobalPkgs = true;
  home-manager.users.ian = { pkgs, ... }: {
    home = { 
      packages = with pkgs; [
        brave
        soulseekqt
        tdesktop
        (vscode-with-extensions.override {
          vscode = vscodium;
          vscodeExtensions = with vscode-extensions; [ 
            asvetliakov.vscode-neovim
            dracula-theme.theme-dracula
            haskell.haskell
            jnoortheen.nix-ide
            justusadam.language-haskell
            mkhl.direnv
          ];
        })
        zoom-us
      ];
      stateVersion = "22.11";
    };
  };

  system.autoUpgrade = {
    enable = true;
    channel = "https://nixos.org/channels/nixos-unstable";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
