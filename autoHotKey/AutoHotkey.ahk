; IMPORTANT INFO ABOUT GETTING STARTED: Lines that start with a
; semicolon, such as this one, are comments.  They are not executed.

; This script has a special filename and path because it is automatically
; launched when you run the program directly.  Also, any text file whose
; name ends in .ahk is associated with the program, which means that it
; can be launched simply by double-clicking it.  You can have as many .ahk
; files as you want, located in any folder.  You can also run more than
; one .ahk file simultaneously and each will get its own tray icon.

; SAMPLE HOTKEYS: Below are two sample hotkeys.  The first is Win+Z and it
; launches a web site in the default browser.  The second is Control+Alt+N
; and it launches a new Notepad window (or activates an existing one).  To
; try out these hotkeys, run AutoHotkey again, which will load this file.

VK9C::
{
    Send !{Left} ; mouse wheel 
    Sleep 100 ; avoid sending the button twice
    return
}
VK9D::
{
    Send !{Right} ; mouse wheel 
    Sleep 100
    return 
}
!a::Send !{Left}
!s::WinMinimize, A
!w::
{
	WinGet, maximized, MinMax, A
	if (maximized)
		WinRestore, A
	else
		WinMaximize, A
	return
}

; NumpadSub::Volume_Mute
; NumpadDiv::Volume_Up
; NumpadMult::Volume_Down

<^>!Enter:: run "C:\Program Files\ConEmu\ConEmu64.exe"
<^>!c:: run C:\cygwin\bin\mintty.exe -i /Cygwin-Terminal.ico -

#IfWinActive ahk_class MozillaWindowClass
!1::switch_tab(1)
!2::switch_tab(2)
!3::switch_tab(3)
!4::switch_tab(4)
!5::switch_tab(5)
!6::switch_tab(6)

switch_tab(tab)
{
    Send {Ctrl Down}
    Send %tab%
    Send {Ctrl Up}
    return
}
F11::
{
    jenkins_url(+1)
    return
}
F12::
{
    jenkins_url(-1)
    return
}

get_firefox_url()
{
    tmp = %clipboard%
    Send !d
    Sleep 100
    Send ^c
    Sleep 50
    ret = %clipboard%
    Sleep 50
    clipboard = %tmp%
    ; msgbox Got %ret%
    return %ret%
}

jenkins_url(inc)
{
    url := get_firefox_url() ; %clipboard%

    ; MsgBox Url is %url%
    FoundPos := RegExMatch(url, "job/", "")  ; Returns 7 instead of 1 due to StartingPosition 2 vs. 1.
    FoundPos1 := RegExMatch(url, ".*/([0-9]*)/", SubPat, FoundPos)  ; Returns 1 and stores "XYZ" in SubPat1.

    SubPat1_new = %SubPat1%
    SubPat1_new += %inc%

    ; the build number is surrounded by slashes, so make sure its the only thing
    ; that is changing, i.e.:
    ; http://camunxbld21/job/test_p4_checkout_job_01/1/console
    ; here there would be a replace in the job name as well
    SubPat1 = /%SubPat1%/
    SubPat1_new = /%SubPat1_new%/
    ; MsgBox %url%, %FoundPos%, %SubPat1%, %FoundPos1%, %SubPat1_new%
    NewStr := RegExReplace(url, SubPat1, SubPat1_new)  ; Returns "abc123xyz" because the $ allows a match only at the end.

    ; MsgBox %NewStr%, subpat1 is %subpat1%
    clipboard = %NewStr%
    Send ^v{enter}
    return
}

F2::
{
    url := get_firefox_url()
    FoundPos := RegExMatch(url, "http://camunxbld21")  ; Returns 4, which is the position where the match was found.
    if FoundPos
    {
        FoundPos := RegExMatch(url, "(.*)/job/([\w_]+)/", results)
        old_clip = %clipboard%
        clipboard = %results1%/job/%results2%/configure
        Send !d
        Send ^v
        Send {enter}
        clipboard = %old_clip%
        return
    }
    return
}

F6::
{
    url := get_firefox_url()
    FoundPos := RegExMatch(url, "http://camunxbld21")  ; Returns 4, which is the position where the match was found.
    if FoundPos
    {
        if RegExMatch(url, "/console$")
        {
            ; this is a console, go to the raw console if key is pressed again
            Send !d
            Send {End}
            Send Text
            Send {enter}
            return
        } else if RegExMatch(url, "/\d+/")
        {
            ; this is a build page, just open the console for this
            Send !d
            Send {End}
            Send console
            Send {Enter}
        }
        else
        {
            ; there is no build selected, go to the last build
            Send !d
            Send {End}
            Send lastBuild/console
            Send {Enter}
        }
        return
    }
    else
    {
        Send F6
    }
    return
}

^e::
{
    tmp = %clipboard%
    Send ^c ; im lazy, copy the selected text to the clipboard
    url := get_firefox_url()
    FoundPos := RegExMatch(url, "http://camunxbld21")  ; Returns 4, which is the position where the match was found.
    if FoundPos
    {
        ; this is a jenkins site
        FoundPos := RegExMatch(clipboard, "\d{6}")
        if FoundPos
        {
            ; MsgBox %clipboard%
            Run Firefox.exe http://bugdb/go/change:%clipboard%
        }
    }
    WinGetTitle, window_title
    FoundPos := RegExMatch(window_title, "SeaMonkey")
    if FoundPos
    {
        FoundPos := RegExMatch(clipboard, "http://")
        if FoundPos
        {
            Run Firefox.exe %clipboard%
            return
        }
    }
    clipboard = %tmp%
    return
}
#IfWinActive ; turns back off context sensitivity 

; #IfWinActive ahk_class Chrome_WidgetWin_1
; !1::Send {Ctrl Down}, 1, {Ctrl up}
; !2::Send {Ctrl Down}, 2, {Ctrl up}
; !3::Send {Ctrl Down}, 3, {Ctrl up}
; !4::Send {Ctrl Down}, 4, {Ctrl up}
; !5::Send {Ctrl Down}, 5, {Ctrl up}
; !6::Send {Ctrl Down}, 6, {Ctrl up}
; #IfWinActive ; turns back off context sensitivity 



; Note: From now on whenever you run AutoHotkey directly, this script
; will be loaded.  So feel free to customize it to suit your needs.

; Please read the QUICK-START TUTORIAL near the top of the help file.
; It explains how to perform common automation tasks such as sending
; keystrokes and mouse clicks.  It also explains more about hotkeys.


;#	Win (Windows logo key). In v1.0.48.01+, for Windows Vista and later, hotkeys that include the Windows key (e.g. #a) will wait for the Windows key to be released before sending any text containing an "L" keystroke. This prevents the Send within such a hotkey from locking the PC. This behavior applies to all sending modes except SendPlay (which doesn't need it) and blind mode.
;!	Alt
;^	Control
;+	Shift
;&	An ampersand may be used between any two keys or mouse buttons to combine them into a custom hotkey. See below for details. Such hotkeys are ignored (not activated) on Windows 95/98/Me.
;<	Use the left key of the pair. e.g. <!a is the same as !a except that only the left Alt key will trigger it. This symbol is ignored on Windows 95/98/ME.
;>	Use the right key of the pair. This symbol is ignored on Windows 95/98/ME.
;<^>!	
;AltGr (alternate graving). If your keyboard layout has an AltGr key instead of a right-Alt key, this series of symbols can usually be used to stand for AltGr (requires Windows NT/2k/XP or later). For example:
;
;<^>!m::MsgBox You pressed AltGr+m.
;<^<!m::MsgBox You pressed LeftControl+LeftAlt+m.
;Alternatively, to make AltGr itself into a hotkey, use the following hotkey (without any hotkeys like the above present):
;
;LControl & RAlt::MsgBox You pressed AltGr itself.
;*	
;Wildcard: Fire the hotkey even if extra modifiers are being held down. This is often used in conjunction with remapping keys or buttons. For example:
;
;*#c::Run Calc.exe  ; Win+C, Shift+Win+C, Ctrl+Win+C, etc. will all trigger this hotkey.
;*ScrollLock::Run Notepad  ; Pressing Scrolllock will trigger this hotkey even when modifer key(s) are down.
;This symbol is ignored on Windows 95/98/ME.
;
;~	
;When the hotkey fires, its key's native function will not be blocked (hidden from the system). In both of the below examples, the user's click of the mouse button will be sent to the active window:
;
;~RButton::MsgBox You clicked the right mouse button.
;~RButton & C::MsgBox You pressed C while holding down the right mouse button.
;Notes: 1) Unlike the other prefix symbols, the tilde prefix is allowed to be present on some of a hotkey's variants but absent on others; 2) Special hotkeys that are substitutes for alt-tab always ignore the tilde prefix; 3) The tilde prefix is ignored on Windows 95/98/ME
;
;$	
;This is usually only necessary if the script uses the Send command to send the keys that comprise the hotkey itself, which might otherwise cause it to trigger itself. The exact behavior of the $ prefix varies depending on operating system:
;
;On Windows NT4/2k/XP or later: The $ prefix forces the keyboard hook to be used to implement this hotkey, which as a side-effect prevents the Send command from triggering it. The $ prefix is equivalent to having specified #UseHook somewhere above the definition of this hotkey.
;
;On Windows 95/98/Me: The hotkey is disabled during the execution of its thread and re-enabled afterward. As a side-effect, if #MaxThreadsPerHotkey is set higher than 1, it will behave as though set to 1 for such hotkeys.
;
;UP
;The word UP may follow the name of a hotkey to cause the hotkey to fire upon release of the key rather than when the key is pressed down. The following example remaps LWin to become LControl:
;
;*LWin::Send {LControl Down}
;*LWin Up::Send {LControl Up}
;
;"Up" can also be used with normal hotkeys as in this example: ^!r Up::MsgBox You pressed and released Ctrl+Alt+R. It also works with combination hotkeys (e.g. F1 & e Up::)
;
;Limitations: 1) "Up" does not work with joystick buttons; 2) "Up" requires Windows NT4/2000/XP or later; and 3) An "Up" hotkey without a normal/down counterpart hotkey will completely take over that key to prevent it from getting stuck down. One way to prevent this is to add a tilde prefix (e.g. ~LControl up::)
;
;On a related note, a technique similar to the above is to make a hotkey into a prefix key. The advantage is that although the hotkey will fire upon release, it will do so only if you did not press any other key while it was held down. For example:
;
;LControl & F1::return  ; Make left-control a prefix by using it in front of "&" at least once.
;LControl::MsgBox You released LControl without having used it to modify any other key.
;
