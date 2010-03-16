#NoEnv
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

#Escape::
IfWinExist ahk_class mintty
{
	IfWinActive ahk_class mintty
	{
		; get latest size^, remembers size when toggeling
		WinGetPos, minttyX, minttyY, minttyWidth, minttyLastHeight, ahk_class mintty
		WinHide ahk_class mintty
		; reset focus to last active window
		WinActivate, ahk_id %hw_current%
	}
	else
	{
		; get last active window
		WinGet, hw_current, ID, A
		WinMove, ahk_class mintty, , -%dragableBorderWith%, -%menubarHeight%, A_ScreenWidth + ( %dragableBorderWith% * 2 ), %minttyLastHeight%
		WinShow ahk_class mintty
		WinActivate ahk_class mintty
	}
}
else
{
	; get last active window
	WinGet, hw_current, ID, A
	Run %minttyPath%,
	WinWait ahk_class mintty
	; i have no idea why, but ( %dragableBorderWith% * 2 ) doesn't work here
	WinMove, ahk_class mintty, , -%dragableBorderWith%, -%menubarHeight%, A_ScreenWidth + 8, %heightConsoleWindow%
}
return