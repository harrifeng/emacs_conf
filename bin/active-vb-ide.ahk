WinActivate ahk_class wndclass_desked_gsk
ControlFocus ,MDIClient1 , ahk_class wndclass_desked_gsk ; focus the first editor in IDE
   ; delete old code ,and paste code from Emacs Editor to current editor in vba IDE
 ; save ,then run
 Send ^a^v^s
