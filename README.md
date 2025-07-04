Config-file/README.md
# NixOS & Home Manager Configuration

This repository provides a modular, reproducible, and scalable setup for managing NixOS systems and Home Manager user environments. It includes custom modules, overlays, and packages, making it easy to maintain both system and user-level configurations.

---

## 📁 Directory Structure

```
Config-file/
├── flake.nix                # Nix Flake entry point
├── flake.lock               # Flake lock file
├── Makefile                 # Automation tasks (optional)
├── nixos/                   # System-level NixOS configuration
│   ├── configuration.nix
│   ├── hardware-configuration.nix
│   ├── modules/             # Custom NixOS modules
│   └── src/                 # Modularized system configs (networking, services, etc.)
├── home-manager/            # User-level Home Manager configuration
│   └── <user>/
│       ├── home.nix
│       ├── modules/         # Custom Home Manager modules
│       └── src/             # Modularized user configs
├── pkgs/                    # Custom Nix/NixOS packages
│   └── <package>/
│       └── default.nix
├── overlays/                # Nixpkgs overlays
│   └── default.nix
├── assets/                  # Static files (wallpapers, app configs)
│   ├── background/
│   └── config/
└── modules/                 # Shared modules (optional)
    ├── nixos/
    └── home-manager/
```

---

## 🚀 Getting Started

### 1. Prerequisites

- **Nix** installed with Flakes enabled.
- (Optional) NixOS system for full system management.

### 2. Clone the Repository

```sh
git clone <repo-url>
cd Config-file
```

### 3. Configure Your System and User

- Edit `flake.nix` to set your system hostname and user.
- Adjust `nixos/configuration.nix` and `home-manager/<user>/home.nix` as needed.

### 4. Apply the Configuration

#### For NixOS System

```sh
sudo nixos-rebuild switch --flake .#<hostname>
```

#### For Home Manager Only

```sh
home-manager switch --flake .#<username>
```

---

## 🛠️ Customization

- **System Modules:** Add or edit files in `nixos/modules/` and import them in `nixos/configuration.nix`.
- **User Modules:** Place custom Home Manager modules in `home-manager/<user>/modules/`.
- **Custom Packages:** Add new packages under `pkgs/<package>/default.nix` and reference them in your configs.
- **Overlays:** Modify or extend Nixpkgs using `overlays/default.nix`.
- **Assets:** Store wallpapers, icons, and app configs in `assets/`.

---

## 💡 Tips

- Keep system and user configs modular for easier maintenance.
- Use overlays for patching or extending upstream packages.
- Use the `src/` directories to split large configs by area (e.g., networking, services, programs).
- Document custom modules and packages for future reference.

---

## 📚 Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Pills](https://nixos.org/guides/nix-pills/)

---

## 🔒 KMITL VPN Usage

This repository includes a convenient way to connect to the KMITL VPN using OpenVPN 3.

### Setup

1. Place your official `kmitl.ovpn` file in:
   ```
   assets/vpn/kmitl.ovpn
   ```

2. Make sure you have [OpenVPN 3 Linux](https://openvpn.net/cloud-docs/openvpn-3-client-for-linux/) installed.

### Usage

Two helper commands are provided (add these to your shell profile or as scripts):

- **Start VPN:**
  ```sh
  it-kmitl-vpn start
  ```
  This will import and start the VPN connection using `assets/vpn/kmitl.ovpn`.

- **Stop VPN:**
  ```sh
  it-kmitl-vpn stop
  ```
  This will disconnect the VPN session.

#### Example Bash Script (`it-kmitl-vpn`)

```sh
#!/usr/bin/env bash
OVPN_PATH="assets/vpn/kmitl.ovpn"
PROFILE_NAME="kmitl-vpn"

case "$1" in
  start)
    sudo openvpn3 session-manage --disconnect --config $OVPN_PATH 2>/dev/null
    sudo openvpn3 config-import --config $OVPN_PATH --name $PROFILE_NAME --persistent
    sudo openvpn3 session-start --config $OVPN_PATH
    ;;
  stop)
    sudo openvpn3 session-manage --disconnect --config $OVPN_PATH
    ;;
  *)
    echo "Usage: it-kmitl-vpn {start|stop}"
    ;;
esac
```

- Make the script executable and place it in your `$PATH`.

### Shell Alias

You can add a convenient alias to your shell profile (e.g., `.bashrc`, `.zshrc`):

```sh
alias it-kmitl-vpn="$HOME/path/to/Config-file/assets/vpn/it-kmitl-vpn"
```

Replace `$HOME/path/to/Config-file` with the actual path to your repository.

After adding the alias, reload your shell or run `source ~/.bashrc` (or your shell's equivalent), and you can use `it-kmitl-vpn start` and `it-kmitl-vpn stop` from anywhere.

---

## 📝 License

MIT or your preferred license.

---

**Happy hacking with Nix!**