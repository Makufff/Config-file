{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    (python3.withPackages (ps: with ps; [ numpy pandas scikit-learn tqdm pulp ]))
    postman
    burpsuite
    mininet
  ];
  home.file = {
    ".config/waybar/config".source = ../assets/config/waybar/config;
  };
  # Enable home-manager and git
	programs.home-manager.enable = true;
	programs.zsh = {
		enable = true;
		enableCompletion = true;
		shellAliases = {
			neofetch = "fastfetch";
		};
		initContent = ''
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
	programs.neovim =
	{
		enable = true;
		defaultEditor = true;
		plugins = with pkgs.vimPlugins; [
        # colorscheme
        sonokai
        # search
        neo-tree-nvim
        fzf-lua
        # language server
			{
				plugin = (nvim-treesitter.withPlugins (p: [
					p.tree-sitter-nix
					p.tree-sitter-vim
					p.tree-sitter-bash
					p.tree-sitter-lua
					p.tree-sitter-python
					p.tree-sitter-json
					p.tree-sitter-c
					p.tree-sitter-rust
				]));
        }
        telescope-nvim
        telescope-ui-select-nvim
        mason-nvim
        mason-lspconfig-nvim
        nvim-lspconfig
        null-ls-nvim
        # dependencies
        plenary-nvim
        nvim-web-devicons
        nui-nvim
        cmp_luasnip
        friendly-snippets
        diffview-nvim
        mini-pick
        dressing-nvim
        img-clip-nvim
        render-markdown-nvim
        markdown-nvim
        # utilities
        toggleterm-nvim
        neogit
        todo-comments-nvim
        bufferline-nvim
        # completions
        cmp-nvim-lsp
        nvim-cmp
        luasnip
        copilot-cmp
        CopilotChat-nvim
        ChatGPT-nvim
        which-key-nvim
        dashboard-nvim
        nvim-autopairs
        gitsigns-nvim
        lualine-nvim
      ];
      extraConfig = ''
        " ___ ___   ____  __  _  __ __  _____  _____  _____ 
        " |   |   | /    ||  |/ ]|  |  ||     ||     ||     |
        " | _   _ ||  o  ||  ' / |  |  ||   __||   __||   __|
        " |  \_/  ||     ||    \ |  |  ||  |_  |  |_  |  |_  
        " |   |   ||  _  ||     ||  :  ||   _] |   _] |   _] 
        " |   |   ||  |  ||  .  ||     ||  |   |  |   |  |   
        " |___|___||__|__||__|\_| \__,_||__|   |__|   |__|   

        set       smartindent
        set       noexpandtab
        set       tabstop=4
        set       shiftwidth=4
        set       backspace=indent,eol,start
        set       nu
        set       list
        set       listchars+=space:⋅
        set       listchars+=tab:→\ 
        set       listchars+=eol:↴

        colorscheme sonokai
        nnoremap <C-h> <C-w>h
        nnoremap <C-l> <C-w>l
        nnoremap <C-j> <C-w>j
        nnoremap <C-k> <C-w>k

        set mouse=a
        set relativenumber

        lua <<EOF
        vim.g.mapleader = " "
        vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<ESC>:w<CR>", { desc = "save" })
        require("nvim-web-devicons").setup({default = true,})
        require("neo-tree").setup({
          window = {
            width = 30,
            mappings = {
              ["<space>"] = false,
              ["[b"] = "prev_source",
              ["]b"] = "next_source",
              ["t"] = "open_tabnew",
              ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
              ["h"] = "close_node",
              ["l"] = "open",
            },
            fuzzy_finder_mappings = {
              ["<C-j>"] = "move_cursor_down",
              ["<C-k>"] = "move_cursor_up",
            },
          },
        })

        require('nvim-treesitter.configs').setup ({
						ensure_installed = {},
						auto_install = false,
						highlight = { enable = true },
						indent = { enable = true },
        })

        require("telescope").setup({
          extensions = {
            ["ui-select"] = {
              require("telescope.themes").get_dropdown{}
            }
          },
          defaults = {
            mappings = {
              i = {
                ["<C-h>"] = "which_key"
              }
            }
          },
        })
        local builtin = require("telescope.builtin")
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "tepescope find_file" } )
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "tepescope live_grep" } )
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "tepescope buffers" } )
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "tepescope help" } )
        require("telescope").load_extension("ui-select")

        require("mason").setup()
        require("mason-lspconfig").setup({
          automatic_installation = true,
        })
        local lspconfig = require("lspconfig")
        lspconfig.lua_ls.setup({})
        lspconfig.marksman.setup{}
        lspconfig.clangd.setup({
          cmd = {"clangd"}
        })
        lspconfig.nil_ls.setup({
          cmd = {"/home/knakto/.nix-profile/bin/nixd"}
        })

        vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#121928", fg = "#50bcef" })
        vim.keymap.set('n', 'J', vim.lsp.buf.hover, { desc = "Hover to show function details with custom UI" })

        require("markdown").setup()

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "definition" })
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "code_action" })
        vim.diagnostic.config({
          virtual_text = true,
          signs = true,
          underline = true,
          update_in_insert = false,
          severity_sort = true,
        })

        vim.opt.termguicolors = true
        require("bufferline").setup({
          options = {
            separator_style = "slope",
            always_show_bufferline = true,
            show_buffer_icons = true,
            show_buffer_close_icons = true,
            show_tab_indicators = true,
            line_height = 3,
            max_name_length = 30,
            max_prefix_length = 15,
            tab_size = 30,
            offsets = {
              {
                filetype = "neo-tree",
                text = "File Explorer",
                text_align = "center",
                highlight = "Directory",
                separator = true,
              }
            }
          }
        })
        vim.keymap.set('n', 'L', ":BufferLineCycleNext<CR>", { desc = "nextbuffer" })
        vim.keymap.set('n', 'H', ":BufferLineCyclePrev<CR>", { desc = "nextbuffer" })
        vim.keymap.set('n', '<leader>bd', ":bd<CR>", { desc = "deletebuffer" })

        require("toggleterm").setup({
          function(term)
            if term.direction == "horizontal" then
              return 17
            elseif term.direction == "vertical" then
              return vim.o.columns * 0.4
            end
          end,
          open_mapping = [[<c-\>]],
          direction = "float",
        })

        local cmp = require("cmp")
        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
          snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          },
          window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-S>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "nvim_lua" },
            { name = "luasnip" },
          }, {
            { name = "buffer" },
          }),
        })

        require("CopilotChat").setup()
        vim.keymap.set({"n", "i", "v"}, "<C-c>", ":CopilotChatToggle<CR>", { desc = "copilot" })
        require("copilot_cmp").setup()

        -- local null_ls = require("null-ls")
        -- null_ls.setup({
        --   sources = {
        --     null_ls.builtins.formatting.stylua,
        --     null_ls.builtins.formatting.nixpkgs_fmt,
        --     null_ls.builtins.completion.spell,
        --   },
        -- })
        -- vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "format" })

        require("fzf-lua").setup()
        vim.keymap.set("n", '<C-g>', ":Neogit<CR>", { desc = "Neogit" })

        require("todo-comments").setup()

        vim.keymap.set("n", "<leader>nr", ":Neotree /<CR>", { desc = "find in root" })
        vim.keymap.set("n", "<leader>nh", ":Neotree ~/<CR>", { desc = "find in home" })
        vim.keymap.set("n", "<leader>nn", ":Neotree ./", { desc = "move to" })
        vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>", { desc = "Neotree" })

        function ManUnderCursor()
          local word = vim.fn.expand("<cword>")
          vim.cmd("Man " .. word)
        end
        vim.keymap.set('n', 'K', ManUnderCursor, { desc = "Open man page for word under cursor" })

        vim.api.nvim_set_keymap('n', 'gp', ':lua SearchFunctionUnderCursor()<CR><ESC>', { noremap = true, silent = true })

        function SearchFunctionUnderCursor()
          local current_word = vim.fn.expand('<cword>')
          require('telescope.builtin').live_grep({
            default_text = current_word,
            prompt_title = 'Search Function: ' .. current_word,
          })
        end

        require("which-key").setup({})
        require("dashboard").setup({})
        require("nvim-autopairs").setup({})
        require("gitsigns").setup({})
        require("lualine").setup({})
        vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
        vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })
        vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "File Explorer" })
        vim.keymap.set("n", "<leader>/", function() require('Comment.api').toggle.linewise.current() end, { desc = "Toggle comment" })
        vim.keymap.set("i", "<C-Space>", function() require("cmp").complete() end, { desc = "Trigger completion" })

EOF
      '';
      vimAlias = true;
	};
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