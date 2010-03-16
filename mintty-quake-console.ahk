#NoEnv
#SingleInstance force
SendMode Input
DetectHiddenWindows, on

; get path to cygwin from registry
RegRead, cygwinRootDir, HKEY_LOCAL_MACHINE, SOFTWARE\Cygwin\setup, rootdir
cygwinBinDir := cygwinRootDir . "\bin"

; path to mintty (same folder as script), start with default shell
minttyPath := A_WorkingDir . "\mintty.exe -"

; width of dragable window border (we hide borders offscreen)
SysGet, dragableBorderWith, 69

; width of normal window border (we hide borders offscreen)
SysGet, borderWith, 5

; height of menubar (we hide this offscreen)
SysGet, menubarHeight, 30

; real height, this doesn't work for windows classic skins
; for luna skins it works, didn't test aero yet.
menubarHeight := menubarHeight + dragableBorderWith + borderWith * 2

; initial height of console window
heightConsoleWindow := 384

init()
{
	global
	; get last active window
	WinGet, hw_current, ID, A
	Run %minttyPath%, %cygwinBinDir%, Hide, hw_mintty
	WinWait ahk_pid %hw_mintty%
	; MsgBox You selected %hw_mintty%
	; i have no idea why, but ( %dragableBorderWith% * 2 ) doesn't work here
	WinMove, ahk_pid %hw_mintty%, , -%dragableBorderWith%, -%menubarHeight%, A_ScreenWidth + 8, %heightConsoleWindow%
	WinShow ahk_pid %hw_mintty%
	WinActivate ahk_pid %hw_mintty%
}

toggle()
{
	global

	IfWinActive ahk_pid %hw_mintty%
	{
		; get latest size^, remembers size when toggeling
		WinGetPos, minttyX, minttyY, minttyWidth, minttyLastHeight, ahk_pid %hw_mintty%
		WinHide ahk_pid %hw_mintty%
		; reset focus to last active window
		WinActivate, ahk_id %hw_current%
	}
	else
	{
		; get last active window
		WinGet, hw_current, ID, A
		WinMove, ahk_pid %hw_mintty%, , -%dragableBorderWith%, -%menubarHeight%, A_ScreenWidth + ( %dragableBorderWith% * 2 ), %minttyLastHeight%
		WinShow ahk_pid %hw_mintty%
		WinActivate ahk_pid %hw_mintty%
	}
}

#Escape::
IfWinExist ahk_pid %hw_mintty%
{
	toggle()
}
else
{
	init()
}
return
