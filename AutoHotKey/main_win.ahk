#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; emacs keybind
^a::
  SetKeyDelay -1
  Send {Home DownTemp}
Return
^a up::
  SetKeyDelay -1
  Send {Home Up}
Return

^e::
  SetKeyDelay -1
  Send {End DownTemp}
Return
^e up::
  SetKeyDelay -1
  Send {End Up}
Return

^f::
  SetKeyDelay -1
  Send {Right DownTemp}
Return
^f up::
  SetKeyDelay -1
  Send {Right Up}
Return

^b::
  SetKeyDelay -1
  Send {Left DownTemp}
Return
^b up::
  SetKeyDelay -1
  Send {Left Up}
Return

^n::
  SetKeyDelay -1
  Send {Down DownTemp}
Return
^n up::
  SetKeyDelay -1
  Send {Down Up}
Return

^p::
  SetKeyDelay -1
  Send {Up DownTemp}
Return
^p up::
  SetKeyDelay -1
  Send {Up Up}
Return
