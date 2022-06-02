if (-not $env:XDG_CONFIG_HOME) {
	$env:PATH += ";$PSScriptRoot/nvim/bin"
	$env:PATH += ";$PSScriptRoot/zig"
	$env:PATH += ";$PSScriptRoot/util"
	
	$env:XDG_CONFIG_HOME = "$PSScriptRoot\.config"
	$env:XDG_DATA_HOME = "$PSScriptRoot\.data"
}

Set-Alias -Name nvd -Value neovide

oh-my-posh init pwsh --config 'C:\Program Files (x86)\oh-my-posh\themes\powerlevel10k_classic.omp.json' | Invoke-Expression
cls

