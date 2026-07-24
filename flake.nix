{
	description = "Unofficial Google Photos Desktop GUI Client";

	inputs = {
		flake-parts = { type="github"; owner="hercules-ci"; repo="flake-parts"; };
		nixpkgs = { type="github"; owner="NixOS"; repo="nixpkgs"; ref="nixpkgs-unstable"; };
		mtsync = {
			url = "https://github.com/gavindi/mtsync/releases/latest/download/mtsync_0.9.13_ubuntu26.04_x86_64.deb";
			flake = false;
		};
	};

	outputs = inputs@{ flake-parts, ... }:
		flake-parts.lib.mkFlake { inherit inputs; } {
			systems = ["x86_64-linux"];
			perSystem = { config, self', inputs', pkgs, system, ... }: {
				packages = {
					default = self'.packages.mtsync;
					mtsync = pkgs.stdenv.mkDerivation {
						name = "mtsync";
						src = inputs.mtsync;
						
						nativeBuildInputs = with pkgs; [ dpkg autoPatchelfHook ];
						buildInputs = with pkgs; [ gtkmm4 libadwaita libsoup_3 glib cairo stdenv.cc.cc.lib ];
						
						unpackPhase = ''
								dpkg --extract -- $src ./tree/
								cd ./tree/usr/
						'';
						
						installPhase = ''
								mkdir -p $out/
								mv ./bin/ ./share/ $out/
						'';
					};
				};
			};
		};
}		 
