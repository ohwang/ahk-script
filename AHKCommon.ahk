;; AHKCommon.ahk

Get_LastActiveWinId() {
  ; global WindowList
  WinGet, WindowList, List
  WinGet, TopWindow, ID, A
  counter = 1
  while (counter <= WindowList) {
    id := WindowList%counter%
    WinGetTitle, winTitle%counter%, ahk_id %id%
    WinGetClass, winClass%counter%, ahk_id %id%
    WinGetPos, winX%counter%, winY%counter%, winWidth%counter%, winHeight%counter%, ahk_id %id%
    counter++
  }
  counter = 1
  while (WindowList%counter% <> TopWindow ) {
    counter++
  }
  counter++
  lastWinId := WindowList%counter%
  return LastWinId
}

;; partially work with metro windows
Switch_BackForth(WinClass, AppPath, ByRef LastWinId) {
  ; MsgBox, LastWinId is %LastWinId%
  IfWinExist ahk_class %WinClass%
  {
    IfWinActive ahk_class %WinClass%
    {
      if (LastWinId == "")
      {
        LastWinId := Get_LastActiveWinId()
      }

      ;; workaround for the start screen
      ;; but is is ugly, emulate win key is not a good idea in all cases
      WinGetClass, LastWinClass, ahk_id %LastWinId%
      if (LastWinClass == "ImmersiveLauncher") {
        ;; as a feature of the OS, windows key is
        ;; blocked if Ctrl or Alt is pressed (??)
        KeyWait Alt  ;; ugly
        KeyWait Ctrl ;; ugly
        SendEvent {RWin}
      } else {
        WinActivate ahk_id %LastWinId%
      }
    }
    else
    {
      WinGet, LastWinId, ID, A
      WinActivate
    }
  }
  else
  {
    WinGet, LastWinId, ID, A
    Run %AppPath%
  }
}

Inspect_ActiveWindow() {
  WinGet, id, ID, A
  WinGet, pid, PID, A
  WinGetClass, class, A
  WinGetActiveStats, Title, Width, Height, X, Y

  WinGet, procName, ProcessName, A
  WinGet, procPath, ProcessPath, A
  Msg =
  (
  Inspection of active window:`n
   Id: %id%
   Pid: %pid%
   Class: %class%

   Title: %Title%
   Width: %Width%
   Height: %Height%
   X: %X%
   Y: %Y%

   ProcName: %procName%
   ProcPath: %procPath%
  )

  MsgBox, %Msg%
}

Show_InfoBoard() {
  FormatTime, Time,, MM/dd/yyyy h:mm:ss tt
  SplashTextOn, 300, 30, Time, %Time%
  Sleep 1000
  SplashTextOff
}

Toggle_FullScreen() {
  WS_BORDER = 0xC00000
  WS_SIZEBOX = 0x40000

  WinGet, winId, ID, A
  WinSet, Style, ^0xC00000, A ; hide title bar
  WinSet, Style, ^0x40000, A  ; hide thinkframe/sizebox

  WinGet, winStyle, Style, A
  if (! (winStyle & WS_BORDER)) {
    ;; to be precise, should maually set X, Y, Width, Height
    WinMove, ahk_id %winId%, , 0, 0, A_ScreenWidth, A_ScreenHeight
  }
  else
  {
    ;; doesn't work
    ; WinRestore, ahk_id %winId%
  }
  WinSet, Redraw,, A
  ; WinHide, ahk_id winId
  ; WinShow, ahk_id winId
}

Restore_ActiveWindowIfMinimized() {
  WinGetActiveStats, _WinTitle, _WinWidth, _WinHeight, X, Y
    if (X < -30000 && Y < -30000) {
      ;; MsgBox, Window is minimized
      WinRestore, A
    }
}
