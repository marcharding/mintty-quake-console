DetectHiddenWindows, on

; path to mintty
minttyPath := "C:\Programme\Cygwin\bin\mintty.exe"

; width of window border (we hide borders offscreen)
borderWith := 4

; height of menubar (we hide this offscreen)
menuWith := 29

; height of console window
heightConsoleWindow := 384

#^::
IfWinExist ahk_class mintty
{
	IfWinActive ahk_class mintty
	{
		WinHide ahk_class mintty
		; reset focus to last active window
		WinActivate, ahk_id %hw_current%
	}
	else
	{
		; get last active window
		WinGet, hw_current, ID, A
		WinMove, ahk_class mintty, , -%borderWith%, -%menuWith%, A_ScreenWidth + ( %borderWith% * 2 ), %heightConsoleWindow%
		WinShow ahk_class mintty
		WinActivate ahk_class mintty
	}
}
else
{
	; get last active window
	WinGet, hw_current, ID, A
	Run %minttyPath%
	WinWait ahk_class mintty
	; i have no idea why, but ( %borderWith% * 2 ) doesn't work here
	WinMove, ahk_class mintty, , -%borderWith%, -%menuWith%, A_ScreenWidth + 8, %heightConsoleWindow%
}
