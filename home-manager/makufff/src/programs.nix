{
	pkgs,
	...
}: {
  # Enable home-manager and git
	programs.home-manager.enable = true;
	programs.zsh = {
		enable = true;
		enableCompletion = true;
		shellAliases = {
			neofetch = "fastfetch";
		};
		initExtra = ''
			function it-kmitl() {
				case "$1" in
					start)
						sudo systemctl start openvpn-kmitl ;;
					stop)
						sudo systemctl stop openvpn-kmitl ;;
					status)
						sudo systemctl status openvpn-kmitl ;;
					*)
						echo "Usage: it-kmitl {start|stop|status}" ;;
				esac
			}
		'';
		oh-my-zsh = {
			enable = true;
			plugins = [ "git" "sudo" "docker" "kubectl" ];
			theme = "agnoster";
		};
	};
  # Remove kitty terminal, add ghostty
  programs.ghostty = {
    enable = true;
    package = pkgs.unstable.ghostty;
    settings = {
      font-family = "JetBrainsMono Nerd Font";
      font-size = 14;
      font-feature = [ "-liga" "-dlig" "-calt" ];
      theme = "catppuccin-mocha";
      background-opacity = 0.85;
      unfocused-split-opacity = 0.7;
    };
  };
  # Use LazyVim for neovim, vim, and vi
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      LazyVim
      # Add more plugins here if needed
    ];
    extraLuaConfig = ''
      vim.g.mapleader = " "
      require("lazy").setup({
        spec = {
          { "LazyVim/LazyVim", import = "lazyvim.plugins" },
          -- { import = "plugins" }, -- Uncomment if you have your own plugins
          { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = {} } },
        },
        dev = {
          path = "${pkgs.linkFarm "lazy-plugins" (builtins.map (drv: { name = drv.pname or drv.name; path = drv; }) (with pkgs.vimPlugins; [ LazyVim ]))}",
          patterns = { "" },
          fallback = true,
        },
        install = { missing = false },
        performance = {
          reset_packpath = false,
          rtp = { reset = false },
        },
      })
    '';
  };
  # Optionally, symlink your own LazyVim config:
  # xdg.configFile."nvim".source = ./dotfiles/nvim; # Uncomment and set path if you want to use your own config
	programs.fastfetch = {
		enable = true;
		settings = {
			logo = {
				source = "~/.face";
				height = 12;
				padding = {
					left = 2;
					right = 2;
					top = 1;
				};
			};
			#display = {
				#size = {
				#  binaryPrefix = "si";
				#};
				# color = "blue";
				# separator = "  ";
			#};
			modules = [
				"break"
				"title"
				"separator"
				"os"
				"host"
				"kernel"
				"packages"
				"shell"
				"de"
				"wm"
				"wmtheme"
				"cpu"
				"gpu"
				"break"
				"colors"
				"break"
			];
		};
	};
	programs.mangohud = {
		enable = true;
		settings = {
			#control="mangohud";
			fsr_steam_sharpness=5;
			#nis_steam_sharpness=10;
			legacy_layout=0;
			horizontal=true;
			battery=true;
			gpu_stats=true;
			cpu_stats=true;
			cpu_power=true;
			gpu_power=true;
			ram=true;
			fps=true;
			frametime=0;
			hud_no_margin=true;
			table_columns=14;
			frame_timing=1;
		};
	};
	
	programs.vscode = {
  enable = true;
  mutableExtensionsDir = true;
  package = pkgs.unstable.vscodium;
  profiles.default = {
    extensions = with pkgs.nix-vscode-extensions; [
      vscode-marketplace.leonardssh.vscord
      # vscode-marketplace.ms-toolsai.jupyter
      open-vsx.llvm-vs-code-extensions.vscode-clangd
      open-vsx.medo64.render-crlf
      open-vsx.jeanp413.open-remote-ssh
      open-vsx.pinage404.nix-extension-pack
      open-vsx.tomoki1207.pdf
      open-vsx.ms-azuretools.vscode-docker
      open-vsx.ms-toolsai.jupyter-renderers
      open-vsx.ms-python.python
    ];

    userSettings = {
      "editor.renderWhitespace" = "all";
      "terminal.integrated.enablePersistentSessions" = false;
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "/run/current-system/sw/bin/nixd";
      "notebook.lineNumbers" = "on";
      "extensions.autoUpdate" = false;
    };
  };
};
}
