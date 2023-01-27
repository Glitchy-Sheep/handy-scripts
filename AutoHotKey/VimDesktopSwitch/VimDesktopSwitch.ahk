;; Set keyboard hooks to make the script more responsible
;; also don't allow to run the script twice to avoid errors

#NoEnv
#SingleInstance force
#InstallKeybdhook
#UseHook


;; Default hotkeys:
;; Shift + Alt + L - switch to the right virtual screen
;; Shift + Alt + H - switch to the left  virtual screen
;;
;; Shift == +
;; Alt   == !
;;
;; You may need to disable a special windows office hotkey with the following command in cmd:
;; REG ADD HKCU\Software\Classes\ms-officeapp\Shell\Open\Command /t REG_SZ /d rundll32

HintDelay := 50



;;;;;;;;;;;;;;;;;;;
;; Hotkeys
;;;;;;;;;;;;;;;;;;;

; Switch to right virtual desktop
+!L::
{
	SwitchRight()
	ShowHint("Display: " + GetCurrentDesktopNumber(), HintDelay)
	return
}

; Switch to left virtual desktop
+!H::
{
	SwitchLeft()
	ShowHint("Display: " + GetCurrentDesktopNumber(), HintDelay)
	return
}



;;;;;;;;;;;;;;;;;;;
;; Functions
;;;;;;;;;;;;;;;;;;;

ShowHint(HintMsg, HideDelay)
{
	win_width := 110
	center_x := A_ScreenWidth // 2 - win_width
	center_y := A_ScreenHeight // 2
	SplashImage, , M1 B fs14 ctFFFF00 cwBlack x%center_x% y%center_y% w%win_width%, %HintMsg%
	sleep, %HideDelay%
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
