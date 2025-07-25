{
  pkgs,
  config,
  ...
}:
{
	environment.sessionVariables = {
		LD_LIBRARY_PATH = [
			"/run/opengl-driver/lib:/run/opengl-driver-32/lib:${config.boot.kernelPackages.nvidia_x11}"
		];
		EXTRA_LDFLAGS="-L/lib -L${config.boot.kernelPackages.nvidia_x11}/lib";
	};
	
	# Alternative: Initialize conda in all shells
	environment.shellInit = ''
		# >>> conda initialize >>>
		# !! Contents within this block are managed by 'conda init' !!
		__conda_setup="$('${pkgs.conda}/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
		if [ $? -eq 0 ]; then
			eval "$__conda_setup"
		else
			if [ -f "${pkgs.conda}/etc/profile.d/conda.sh" ]; then
				. "${pkgs.conda}/etc/profile.d/conda.sh"
			else
				export PATH="${pkgs.conda}/bin:$PATH"
			fi
		fi
		unset __conda_setup
		# <<< conda initialize <<<
	'';
}
