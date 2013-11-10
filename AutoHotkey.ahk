; ~/Documents/AutoHotKey.ahk
; -- will be loaded by AutoHotKey if it is started without any args

;; try to emulate the behaviours of KBC Pocker 1st gen's Fn key combinations
;; use ideas from XMonad -- Window environment should be stateful yet predictable

#SingleInstance Force

;; Default working dir is c:\windows\system32
#Include %A_ScriptDir%
#Include AHKCommon.ahk
#Include AHKCursor.ahk

;; In Case LCtl and CapLock are not switched
; LCtrl::CapsLock
; CapsLock::LCtrl
;; ------------------

^!j::
  LastWinId := Get_LastActiveWinId()
  WinActivate, ahk_id %lastWinId%
return

^!t::
  global LastActiveWinId_Terminal
  Switch_BackForth("moba/x X rl"
                 , "terminator"
                 , LastActiveWinId_Terminal)
return

;; for things like visual studio
;; 1. window class name is not meaningful
;; 2. there may be mulitple windows for single vs instance
;; 3. you have both 2012 and 2013 installed
;; so it's better to have some mechanize to ``register`` customized keys on the fly?
;; or just cycle through all vs windows ?
; ^!v::
;  global LastActiveWinId_Notepad
;  Switch_BackForth("Notepad"
;                 , "Notepad"
;                 , LastActiveWinId_Notepad)
; return

^!n::
  global LastActiveWinId_GVim
  Switch_BackForth("Vim"
                 , "C:\Program Files (x86)\Vim\Vim74\GVim.exe"
                 , LastActiveWinId_Gvim)
return

^!e::
  global LastActiveWinId_Explorer
  Switch_BackForth("CabinetWClass"
                 , "Explorer.exe"
                 , LastActiveWinId_Explorer)
return

^!b::
  global LastActiveWinId_Chrome
  Switch_BackForth("Chrome_WidgetWin_1"
                 , "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
                 , LastActiveWinId_Chrome)
return

;; cycling order is consitent with the order of windows in taskbar
^!l::
  Send !{Esc}
  Restore_ActiveWindowIfMinimized()
return

^!h::
  Send +!{Esc}
  Restore_ActiveWindowIfMinimized()
return

;; inspect current active window
^!space::
  Inspect_ActiveWindow()
return

;; the combination of ^!u and ^!r make hide/show of, particularly, the taskbar easier
;; clearly stack is a better than queue in this case

^!u::
  WinGet, CurrentWinId, ID, A
  PushTo_GlobalHideStack(CurrentWinId)
return

^!r::
  PopFrom_GlobalHideStack()
return

+^!f::
  Toggle_FullScreen()
return

^!o::
  Show_InfoBoard()
return

;; reload currently used script
+^!r::
  MsgBox, Script __%A_ScriptFullPath%__ will be reloaded
  Reload_CurrentScript()
return

;; paste plain text using Shift+Ctrl+V as in Chrome
+^v::
  Input_ClipBoardAsPlainText()
return
;; TODO: extend the clipboard by, i.e. using multiple buffers just as vim does
;;       or optionally prompt a selection box to choose from latest 10 clipboard content

>!n::
  WinGetClass, winClass, A
  if (winClass == "Vim")
  {
    SendInput gt
  }
  else
  {
    SendInput ^{Tab}
  }
return

>!p::
  WinGetClass, winClass, A
  if (winClass == "Vim")
  {
    SendInput gT
  }
  else
  {
    SendInput +^{Tab}
  }
return

;; switch to the next/prev window of the __same class__
+>!n::
  WinGetClass, winClass, A
  /*
  WinSet, Bottom,, A
  WinActivate, ahk_class %winClass%
  */
  ;; more general ?
  WinGet, oldWinId, ID, A
  WinGet, winList, List, ahk_class %winClass%
  if (winList > 1) {
    WinActivate, ahk_id %winList2%
    Restore_ActiveWindowIfMinimized()
    WinSet, Bottom,, ahk_id %oldWinId%
  }
return

+>!p::
  WinGetClass, winClass, A
  WinGet, winList, List, ahk_class %winClass%
  if (winList > 1) {
    lastMatchedWinId := winList%winList%
    ; MsgBox, winList %winList%, lastMatchedWinId %lastMatchedWinId%
    WinActivate, ahk_id %lastMatchedWinId%
    Restore_ActiveWindowIfMinimized()
  }
return
