$Env:FZF_DEFAULT_OPTS = "--bind ctrl-a:select-all,ctrl-d:deselect-all" +
                        " --layout=reverse " +
                        " --info=inline " +
                        " --color=gutter:-1" +
                        " --marker=+"
$FZF_BASE_COMMAND = ("fd --hidden --follow" +
                    " --exclude .git" +
                    " --exclude node_modules" +
                    " .")
$Env:FZF_DEFAULT_COMMAND = $FZF_BASE_COMMAND + " -t f"
$Env:FZF_CTRL_T_COMMAND = $Env:FZF_DEFAULT_COMMAND
$Env:FZF_ALT_C_COMMAND = $FZF_BASE_COMMAND + " -t d"

Set-Alias -Name .. -Value Set-LocUpper
Set-Alias -Name cg -Value Set-LocGitRoot
Set-Alias -Name cs -Value Set-LocAndList
Set-Alias -Name gs -Value Start-GitStatus
Set-Alias -Name ls -Value Start-List
Set-Alias -Name nvs -Value Start-NvimSession

if (Get-Module -ListAvailable -Name PSReadLine) {
  Import-Module PSReadline
  Set-PSReadLineKeyHandler -Key Ctrl+o -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    Set-LocAndList -
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
  }
  Set-PSReadLineKeyHandler -Key Ctrl+p -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    Set-LocAndList +
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
  }
  Set-PSReadLineKeyHandler -Key Alt+h -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    Set-LocAndList ..
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
  }
  Set-PSReadLineKeyHandler -Key Ctrl+d -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("exit")
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
  }
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

function Set-LocGitRoot { Set-Location -Path $(git rev-parse --show-toplevel) }
function Set-LocUpper { Set-LocAndList .. }
function Start-GitStatus { git status }
function Start-NvimSession { nvim -S }
