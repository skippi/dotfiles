#HotkeyInterval 99000000
#KeyHistory 0
#MaxHotkeysPerInterval 99000000
#MenuMaskKey vkE8
#NoEnv
#SingleInstance
#UseHook On
ListLines Off
SetBatchLines -1
SetCapsLockState AlwaysOff

!<#Down::Send #{Down}
!<#Left::Send #{Left}
!<#Right::Send #{Right}
!<#Up::Send #{Up}

!Capslock Up::SendInput ^{Esc}
!Capslock::Return
*AppsKey::RCtrl
<#Capslock::Capslock
<#Down::Return
<#Up::Return
LWin::Return

<#+Left::SendInput +{Home}
<#+Right::SendInput +{End}
<#Left::SendInput {Home}
<#Right::SendInput {End}
<#^+Left::SendInput ^+{Home}
<#^+Right::SendInput ^+{End}
<#^Left::SendInput ^{Home}
<#^Right::SendInput ^{End}

Capslock::Esc
Esc::`

!#7::Media_Prev
!#8::Media_Play_Pause
!#9::Media_Next
!#0::Volume_Mute
!#-::Volume_Down
!#=::Volume_Up
