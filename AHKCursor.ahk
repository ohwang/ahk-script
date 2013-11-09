;; Shortcuts for cursor movement/text edit
;; as well as something else

;; ISSUES:
;; 1. RAlt+wsad sometimes cannot move focus among controls in a dialog
;; 2. RAlt+ws don't work in onenote

;; arrows and home/end
*>!w::Send {Up}
*>!s::Send {Down}
*>!a::Send {Left}
*>!d::Send {Right}
; Note: different behaviour for arrow keys and normal chars
>![::Send {Home}
>!'::Send {End}

;; manipulate window -- max/min/left/right
#>!w::Send #{Up}
#>!s::Send #{Down}
#>!a::Send #{Left}
#>!d::Send #{Right}

;; ctrl + arrows
^>!w::Send ^{Up}
^>!s::Send ^{Down}
^>!a::Send ^{Left}
^>!d::Send ^{Right}

;; single character selection
+>!w::Send +{Up}
+>!s::Send +{Down}
+>!a::Send +{Left}
+>!d::Send +{Right}

;; select til home/end
+>![::Send +{Home}
+>!'::Send +{End}

;; whole word selection
^+>!w::Send ^+{Up}
^+>!s::Send ^+{Down}
^+>!a::Send ^+{Left}
^+>!d::Send ^+{Right}

;; misc
>!/::Send {Del}
>!-::Send {F11}
>!=::Send {F12}
>!q::Send {Esc}

>!f::Send #q

