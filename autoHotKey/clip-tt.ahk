Loop, parse, clipboard, `n
{
    ; msgbox got text %A_LoopField%
    new_clip = %new_clip%<tt>%A_LoopField%</tt><br>`r`n
}
clipboard = %new_clip%
return
