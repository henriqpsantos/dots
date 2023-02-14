if (-not $env:XDG_CONFIG_HOME) {
	$env:PATH += ";$PSScriptRoot/../nvim/bin"
	$env:PATH += ";$PSScriptRoot/../util"
	
	$env:XDG_CONFIG_HOME = "$PSScriptRoot"
	$env:XDG_DATA_HOME = "$PSScriptRoot/../.data"
}

# if (-not $Loaded) {$env:PATH += ";C:\Program Files\WPy64-38123\pypy3.8-v7.3.9-win64\Scripts"}

$DOCS = [Environment]::GetFolderPath("MyDocuments")
$env:XDG_CACHE_HOME = "$DOCS/.cache"
$env:XDG_DATA_HOME = "$DOCS/.data"

Function CD_CONFIG {cd $env:XDG_CONFIG_HOME}

Set-Alias -Name dots -Value CD_CONFIG
Set-Alias -Name wg -Value winget

Set-Alias -Name act -Value .\.venv\Scripts\Activate.ps1
Set-Alias -Name deact -Value deactivate

# Set-Alias -Name cd -Value pushd -Option AllScope -Force
# Set-Alias -Name bd -Value popd -Option AllScope


Set-Alias -Name "ppd" -Value "Pop-PersistentPath" -Force -Description "Persistent Pop Location" -EA Ignore -Scope Global -Option AllScope
Set-Alias -Name "pd" -Value "Push-PersistentPath" -Force -Description "Persistent Push Location" -EA Ignore -Scope Global -Option AllScope
Set-Alias -Name "cdl" -Value "cdl_" -Force -EA Ignore -Scope Global -Option AllScope

function cdl_ { Get-PersistentPathList | fzf | cd }

# function nvr { nvr.exe -s --nostart -l $args; if ($LastExitCode -ne 0) { nvd; if ($args) { nvr.exe -s --nostart -l $args } } }

# Run neovide with remote mode as option
$env:NVIM_LISTEN_ADDRESS = "\\.\pipe\nvim-nvr"
function nvr {if (-not (Test-Path $env:NVIM_LISTEN_ADDRESS))
	{ neovide --multigrid --notabs $args.foreach{"$pwd\$_"} -- --listen "$env:NVIM_LISTEN_ADDRESS" }
	else
	{ if ($args) {nvim --server "$env:NVIM_LISTEN_ADDRESS" --remote $args.foreach{"$pwd\$_"}} } }

oh-my-posh init pwsh --config 'C:\Program Files (x86)\oh-my-posh\themes\powerlevel10k_classic.omp.json' | Invoke-Expression

$Loaded = 1

