local nmap = require("skypex.utils").nmap
local ls = require("luasnip")
local s, t, i, c = ls.snippet, ls.text_node, ls.insert_node, ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local lsex = require("luasnip.extras")
local rep = lsex.rep

local M = {}

local flake_snippet = t({
	"{",
	'  description = "";',
	"",
	"  inputs = {",
	'    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";',
	'    flake-utils.url = "github:numtide/flake-utils";',
	'    #naersk.url = "github:nix-community/naersk";',
	"    #fenix = {",
	'    #  url = "github:nix-community/fenix";',
	'    #  inputs.nixpkgs.follows = "nixpkgs";',
	"    #};",
	"  };",
	"",
	"  outputs = {",
	"    self,",
	"    nixpkgs,",
	"    flake-utils,",
	"    #naersk,",
	"    #fenix,",
	"    ...",
	"  }:",
	"    flake-utils.lib.eachDefaultSystem (system: let",
	'      # system = "x86_64-linux";',
	"      pkgs = import nixpkgs {inherit system;};",
	"      #fenixLib = fenix.packages.${system};",
	"      #toolchain = with fenixLib;",
	"      #  combine [",
	"      #    (stable.withComponents [",
	'      #      "rustc"',
	'      #      "cargo"',
	'      #      "rustfmt"',
	'      #      "clippy"',
	'      #      "rust-src"',
	'      #      "rust-docs"',
	'      #      "rust-std"',
	'      #      "rust-analyzer"',
	"      #    ])",
	"      #  ];",
	"",
	"      #naerskLib = (pkgs.callPackage naersk {}).override {",
	"      #  cargo = toolchain;",
	"      #  rustc = toolchain;",
	"      #};",
	"",
	"      #pcpPackage = {release}:",
	"      #  import ./default.nix {",
	"      #    src = self;",
	"      #    naersk = naerskLib;",
	"      #    pkgConfig = pkgs.pkg-config;",
	"      #    inherit release;",
	"      #  };",
	"",
	"      #checks = import ./checks.nix {",
	"      #  src = self;",
	"      #  naersk = naerskLib;",
	"      #  pkgs = pkgs;",
	"      #};",
	"",
	"      #apps = import ./apps.nix {",
	"      #  pkgs = pkgs;",
	"      #};",
	"    in {",
	"      #packages = rec {",
	"      #  default = debug;",
	"      #  debug = pcpPackage {release = false;};",
	"      #  release = pcpPackage {release = true;};",
	"      #};",
	"",
	"      devShells.default = pkgs.mkShell {",
	"        packages = [",
	"          #toolchain",
	"        ];",
	'        #env.RUST_SRC_PATH = "${toolchain}/lib/rustlib/src/rust/library";',
	"      };",
	"",
	"      #checks = checks;",
	"",
	"      #apps = apps;",
	"",
	"      #formatter = pkgs.writeShellApplication {",
	'      #  name = "fmt";',
	"      #  runtimeInputs = [pkgs.rustfmt pkgs.cargo];",
	'      #  text = "cargo fmt --all";',
	"      #};",
	"    });",
	"}",
})

local function all_snippets()
	ls.add_snippets("all", {
		s("tag", fmt("<{}>{}</{}>", { i(1, "name"), i(2), rep(1) })),
	})
end

local function js_snippets()
	ls.add_snippets("js", {
		s("jsdoc", t("/**\n * ${1}\n */")),
	})
end

local function cs_snippets()
	ls.add_snippets("cs", {
		s("sf", fmt("[SerializeField] private {1} {2};", { i(1, "Type"), i(2, "name") })),
		s("sp", fmt("[field: SerializeField] public {1} {2} {{ get; set; }}", { i(1, "Type"), i(2, "name") })),
	})
end

local function nix_snippets()
	ls.add_snippets("nix", {
		s("flake", flake_snippet),
	})
end

M.friendly_snippets = function()
	require("luasnip.loaders.from_vscode").lazy_load()
end

M.telescope = function()
	require("telescope").load_extension("luasnip")

	nmap("<leader>sn", "<cmd>Telescope luasnip<CR>", "Search Snippets")
end

M.luasnip = function()
	ls.setup({
		history = true,
		update_events = { "TextChanged", "TextChangedI" },
		enable_autosnippets = true,
	})

	all_snippets()
	js_snippets()
	cs_snippets()
	nix_snippets()

	nmap("<leader><leader>s", "<cmd>lua require('skypex.custom.snippets').all()<cr>", "Source snippets")
end

M.all = function()
	M.friendly_snippets()
	M.telescope()
	M.luasnip()
end

M.all()

return M
