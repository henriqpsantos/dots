if (-not $env:XDG_CONFIG_HOME) {
	$env:PATH += ";$PSScriptRoot/../nvim/bin"
	$env:PATH += ";$PSScriptRoot/../zig"
	$env:PATH += ";$PSScriptRoot/../util"
	
	$env:XDG_CONFIG_HOME = "$PSScriptRoot"
	$env:XDG_DATA_HOME = "$PSScriptRoot/../.data"
}

if (-not $Loaded) {$env:PATH += ";$env:APPDATA\Python\Python310\Scripts"}

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

Set-Alias -Name act -Value .\.venv\Scripts\Activate.ps1
Set-Alias -Name deact -Value deactivate

$env:NVIM_LISTEN_ADDRESS = "\\.\pipe\nvim-nvr"
function nvd { neovide --multigrid -- --listen "$env:NVIM_LISTEN_ADDRESS" }
function nvr { nvr.exe -s --nostart -l $args; if ($LastExitCode -ne 0) { nvd; if ($args) { nvr.exe -s --nostart -l $args } } }

oh-my-posh init pwsh --config 'C:\Program Files (x86)\oh-my-posh\themes\powerlevel10k_classic.omp.json' | Invoke-Expression

$Loaded = 1
