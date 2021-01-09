$Env:FZF_DEFAULT_OPTS = "--bind ctrl-a:select-all,ctrl-d:deselect-all" +
                        " --color=gutter:-1" +
                        " --marker=+"
$Env:FZF_DEFAULT_COMMAND = ("fd --hidden --follow" +
                            " --exclude .git" +
                            " --exclude node_modules" +
                            " .")
$Env:FZF_CTRL_T_COMMAND = $Env:FZF_DEFAULT_COMMAND
$Env:FZF_ALT_C_COMMAND = $Env:FZF_DEFAULT_COMMAND + " -t d"

if (Get-Command git -errorAction SilentlyContinue) {
  Set-Alias -Name cg -Value Set-LocGitRoot
  Set-Alias -Name cl -Value Set-LocAndList
  Set-Alias -Name ls -Value Start-List
}

if (Get-Module -ListAvailable -Name PSReadLine) {
  Import-Module PSReadline
} else {
  Write-Host 'profile: ignoring PSReadLine config, module not installed'
}

if (Get-Module -ListAvailable -Name PSFzf) {
  Import-Module PSFzf
  Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t'
  Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'
  Set-PsFzfOption -TabExpansion
  Set-Alias -Name fsk -Value Invoke-FuzzyKillProcess
} else {
  Write-Host 'profile: ignoring PSFzf config, module not installed'
}

function Set-LocGitRoot {
  Set-Location -Path $(git rev-parse --show-toplevel)
}

function Start-List {
  param ($path)
  if ($path -eq $null) {
    $path = Get-Location
  }
  Get-ChildItem -Path $path | Format-Wide -AutoSize -Property @{
    e={
      if ($_.PSIsContainer) {
        "$([char]27)[36;1m$($_.Name)"
      } else {
        "$($_.Name)"
      }
    }
  }
}

function Set-LocAndList {
  param ($path)
  Set-Location -Path $path && Start-List .
}
