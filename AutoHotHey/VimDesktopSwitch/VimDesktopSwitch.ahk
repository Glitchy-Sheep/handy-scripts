#NoEnv
#SingleInstance force

;;
;; This script is used to switch between virtual desktops via vim hotkeys,
;; but you can set up your favorite keys if you wish.
;;
;; Default hotkeys:
;; Right: Shift + Alt + L
;; Left:  Shift + Alt + H
;;
;; You may need to disable a special windows office hotkey with the following command in cmd:
;; REG ADD HKCU\Software\Classes\ms-officeapp\Shell\Open\Command /t REG_SZ /d rundll32

HintDelay := 80



;;;;;;;;;;;;;;;;;;;
;; Hotkeys
;;;;;;;;;;;;;;;;;;;

; Switch to right virtual desktop
+!L::
SwitchRight()

; Uncomment the following line to show desktop number on each switch
;ShowHint("Display: " + GetCurrentDesktopNumber(), HintDelay)
return


; Switch to left virtual desktop
+!H::
SwitchLeft()

; Uncomment the following line to show desktop number on each switch
;ShowHint("Display: " + GetCurrentDesktopNumber(), HintDelay)
return



;;;;;;;;;;;;;;;;;;;
;;; Functions
;;;;;;;;;;;;;;;;;;;

ShowHint(HintMsg, Delay)
{
	win_width := 110
	center_x := A_ScreenWidth // 2 - win_width
	center_y := A_ScreenHeight // 2
	SplashImage, , M1 B fs14 ctFFFF00 cwBlack x%center_x% y%center_y% w%win_width%, %HintMsg%
	sleep, %Delay%
	Splashimage,off
}


GetCurrentDesktopNumber()
{
	RegRead, cur, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\1\VirtualDesktops, CurrentVirtualDesktop
	RegRead, all, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops, VirtualDesktopIDs
	ix := floor(InStr(all,cur) / strlen(cur))
	return ix + 1
}


SwitchLeft()
{
	Send, {LControl down}#{Left}{LControl up}
}


SwitchRight()
{
	Send, {LControl down}#{Right}{LControl up}
}
