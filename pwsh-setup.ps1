".'$PSScriptroot\pwsh-init.ps1'" | Out-File -FilePath $PROFILE

Invoke-WebRequest -Uri https://www.dropbox.com/sh/bb13a11ge0vg33h/AAA16cIrio3HcLhfRn6VJUhya?dl=1 -O config.zip; Get-Item config.zip | Expand-Archive -DestinationPath "$PSScriptroot" -Force; Remove-Item config.zip
