if (-not $env:XDG_CONFIG_HOME) {
	$env:PATH += ";$PSScriptRoot/nvim/bin"
	$env:PATH += ";$PSScriptRoot/zig"
	$env:PATH += ";$PSScriptRoot/util"
	
	$env:XDG_CONFIG_HOME = "$PSScriptRoot\.config"
	$env:XDG_DATA_HOME = "$PSScriptRoot\.data"
}
$env:PATH += ";$env:APPDATA\Python\Python310\Scripts"

# 	bat
# 	delta
# 	fd
# 	fzf
# 	grex
# 	hyperfine
# 	just
# 	ninja
# 	rg
# 	ruplacer
# 	sad
# 	tokei
# 	typos

Function CD_CONFIG {cd $env:XDG_CONFIG_HOME}

Set-Alias -Name dots -Value CD_CONFIG
Set-Alias -Name wg -Value winget

$env:NVIM_LISTEN_ADDRESS = "\\.\pipe\nvim-nvr"
function nvr { nvr.exe -s --nostart $args; if ($LastExitCode -ne 0) { nvd; if ($args) { nvr.exe -s --nostart $args } } }
function nvd { neovide -- --listen "$env:NVIM_LISTEN_ADDRESS" }

oh-my-posh init pwsh --config 'C:\Program Files (x86)\oh-my-posh\themes\powerlevel10k_classic.omp.json' | Invoke-Expression

