;; xahk-mode.el -- Major mode for editing AHK (AutoHotKey) scripts. -*- coding: utf-8 -*-

;; Copyright © 2008 by Xah Lee
;; Copyright © 2011 by Joseph

;; Author: Xah Lee ( http://xahlee.org/ )
;; Modified by : Joseph
;; Keywords: ahk, AutoHotKey, hotkey, keyboard shortcut, automation

;; You can redistribute this program and/or modify it under the terms of
;; the GNU General Public License as published by the Free Software
;; Foundation; either GPL version 2 or 3.

;;; DESCRIPTION

;; A major mode for editing AutoHotKey (AHK) script.
;; for download location and documentation, see:
;; http://xahlee.org/mswin/emacs_autohotkey_mode.html

;;; INSTALL

;; Open the file, then type “Alt+x eval-buffer”. You are done. Open
;; any ahk script, then type “Alt+x xahk-mode”, you'll see the
;; source code syntax colored.

;; To have emacs automatically load the file when it restarts, and
;; automatically use the mode when opening files ending in “.ahk”, do this:

;; ① Put the file 〔xahk-mode.el〕 in the dir 〔~/.emacs.d/〕
;; ② Put the following lines in your emacs init file (usually at 〔~/.emacs〕).
;; (autoload 'xahk-mode "xahk-mode" "Load xahk-mode for editing AutoHotkey scripts." t)
;; (add-to-list 'auto-mode-alist '("\\.ahk\\'" . xahk-mode))
;; (defalias 'ahk-mode 'xahk-mode) ; make it easier to remember.

;; Then, restart emacs.

;;; HISTORY

;; version 1.2.1, 2011-10-15 Minor changes. No visible behavior change.
;; version 1.2, 2010-02-17 fixed a defect where if source contains “"C:\"”, everything after is badly syntax colored. Thanks to “xinlu.h” and “iain.tuddenham”. Detail at http://code.google.com/p/ergoemacs/issues/detail?id=66
;; version 1.1, 2010-01-14 Added indentation feature. (press Tab to indent.)
;; version 1.0, 2010-01-09 First version.

;;; Code:

(require 'thingatpt )

(setq xahk-mode-version "1.2.1")

(defgroup xahk-mode nil
  "Major mode for editing AutoHotKey script."
  :group 'languages)

(defvar xahk-mode-command-name-face 'xahk-mode-command-name-face "Face name to use for AHK command names.")

(defface xahk-mode-command-name-face
  '((((class color) (min-colors 88) (background light)) (:foreground "Blue1"))
    (((class color) (min-colors 88) (background dark)) (:foreground "LightSkyBlue"))
    (((class color) (min-colors 16) (background light)) (:foreground "Blue"))
    (((class color) (min-colors 16) (background dark)) (:foreground "LightSkyBlue"))
    (((class color) (min-colors 8)) (:foreground "blue" :weight bold))
    (t (:inverse-video t :weight bold)))
  "Face used to highlight AHK command names."
  :group 'languages)

(defvar xahk-mode-hook nil "Standard hook for xahk-mode.")

(defvar xahk-mode-version nil "xahk-mode version string.")

(defvar xahk-mode-map nil "Keymap for xahk-mode")

(if xahk-mode-map nil
  (setq xahk-mode-map (make-sparse-keymap))
  (define-key xahk-mode-map (kbd "C-c C-r") 'xahk-lookup-ahk-ref)
  (define-key xahk-mode-map (kbd "M-TAB") 'xahk-complete-symbol)

  (define-key xahk-mode-map [menu-bar] (make-sparse-keymap))

  (let ((menuMap (make-sparse-keymap "AHK")))
    (define-key xahk-mode-map [menu-bar xahk] (cons "AHK" menuMap))

    (define-key menuMap [goto-home-page] '("Goto xahk-mode website" . (lambda () (interactive) (browse-url "http://xahlee.org/mswin/emacs_autohotkey_mode.html"))))
    (define-key menuMap [about] '("About xahk-mode" . xahk-about))
    (define-key menuMap [separator] '("--"))
    (define-key menuMap [lookup-onlne-doc] '("Lookup ref on current word" . xahk-lookup-ahk-ref))
    (define-key menuMap [keyword-completion] '("Keyword Completion" . xahk-complete-symbol))))

;;; syntax table
(defvar xahk-mode-syntax-table
  (let ((synTable (make-syntax-table)))
    (modify-syntax-entry ?\= "." synTable)
    (modify-syntax-entry ?\; "< b" synTable)
    (modify-syntax-entry ?\^m "> b" synTable)
    (modify-syntax-entry ?\n "> b" synTable)
    (modify-syntax-entry ?! "." synTable)
    (modify-syntax-entry ?@ "." synTable)
    (modify-syntax-entry ?# "'" synTable)
    (modify-syntax-entry ?$ "." synTable)
    (modify-syntax-entry ?% "." synTable)
    (modify-syntax-entry ?^ "." synTable)
    (modify-syntax-entry ?& "." synTable)
    (modify-syntax-entry ?* "." synTable)
    (modify-syntax-entry ?` "\\" synTable) ; ` is escape
    (modify-syntax-entry ?~ "." synTable)
    (modify-syntax-entry ?: "." synTable)
    (modify-syntax-entry ?' "." synTable)
    (modify-syntax-entry ?| "." synTable)
    (modify-syntax-entry ?? "." synTable)
    (modify-syntax-entry ?< "." synTable)
    (modify-syntax-entry ?> "." synTable)
    (modify-syntax-entry ?, "." synTable)
    (modify-syntax-entry ?. "." synTable)
    (modify-syntax-entry ?/ "." synTable)
    (modify-syntax-entry ?- "." synTable)
    (modify-syntax-entry ?_ "_" synTable) ;; symbol
    (modify-syntax-entry ?\\ "." synTable) ; \ is path separator
    synTable)
  "Syntax table for `xahk-mode'.")

;; word w
;; symbol _
;; punct .
;; escape \
;; expression prefix '
;; " \
;;; functions

(defun xahk-about ()
  "Show the author, version number, and description about this package."
  (interactive)
  (with-output-to-temp-buffer "*About xahk-mode*"
    (princ
     (concat "Mode name: xahk-mode.\n\n"
             "Author: Xah Lee\n\n"
             "Version: " xahk-mode-version "\n\n"
             "To see inline documentation, type “Alt+x `describe-mode'” while you are in xahk-mode.\n\n"
             "Home page: URL `http://xahlee.org/mswin/emacs_autohotkey_mode.html' \n\n")
     )
    )
  )


(defun xahk-lookup-ahk-ref ()
  "Look up current word in AutoHotKey's reference doc.
If a there is a text selection (a phrase), lookup that phrase.
Launches default browser and opens the doc's url."
  (interactive)
  (let (myword myurl)
    (setq myword
          (if (region-active-p)
              (buffer-substring-no-properties (region-beginning) (region-end))
            (thing-at-point 'symbol)))

    (setq myword (replace-regexp-in-string " " "%20" myword))
    (setq myurl (concat "http://www.autohotkey.com/docs/commands/" myword ".htm" ))

    (browse-url myurl)
    ))

;;; font-lock

(defvar xahk-commands
  '("AllowSameLineComments" "ClipboardTimeout" "CommentFlag" "ErrorStdOut" "EscapeChar" "HotkeyInterval" "HotkeyModifierTimeout" "Hotstring" "IfWinActive" "IfWinExist" "IfWinNotActive" "IfWinNotExist" "Include" "IncludeAgain" "InstallKeybdHook" "InstallMouseHook" "KeyHistory" "LTrim" "MaxHotkeysPerInterval" "MaxMem" "MaxThreads" "MaxThreadsBuffer" "MaxThreadsPerHotkey" "NoEnv" "NoTrayIcon" "Persistent" "SingleInstance" "UseHook" "WinActivateForce" "AutoTrim" "BlockInput" "Break" "Click" "ClipWait" "Continue" "Control" "ControlClick" "ControlFocus" "ControlGet" "ControlGetFocus" "ControlGetPos" "ControlGetText" "ControlMove" "ControlSend" "ControlSendRaw" "ControlSetText" "CoordMode" "Critical" "DetectHiddenText" "DetectHiddenWindows" "Drive" "DriveGet" "DriveSpaceFree" "Edit" "Else" "EnvAdd" "EnvDiv" "EnvGet" "EnvMult" "EnvSet" "EnvSub" "EnvUpdate" "Exit" "ExitApp" "FileAppend" "FileCopy" "FileCopyDir" "FileCreateDir" "FileCreateShortcut" "FileDelete" "FileGetAttrib" "FileGetShortcut" "FileGetSize" "FileGetTime" "FileGetVersion" "FileInstall" "FileMove" "FileMoveDir" "FileRead" "FileReadLine" "FileRecycle" "FileRecycleEmpty" "FileRemoveDir" "FileSelectFile" "FileSelectFolder" "FileSetAttrib" "FileSetTime" "FormatTime" "GetKeyState" "Gosub" "Goto" "GroupActivate" "GroupAdd" "GroupClose" "GroupDeactivate" "Gui" "GuiControl" "GuiControlGet" "Hotkey" "If" "IfEqual" "IfExist" "IfGreater" "IfGreaterOrEqual" "IfInString" "IfLess" "IfLessOrEqual" "IfMsgBox" "IfNotEqual" "IfNotExist" "IfNotInString" "IfWinActive" "IfWinExist" "IfWinNotActive" "IfWinNotExist" "ImageSearch" "IniDelete" "IniRead" "IniWrite" "Input" "InputBox" "KeyHistory" "KeyWait" "ListHotkeys" "ListLines" "ListVars" "Loop" "Menu" "MouseClick" "MouseClickDrag" "MouseGetPos" "MouseMove" "MsgBox" "OnExit" "OutputDebug" "Pause" "PixelGetColor" "PixelSearch" "PostMessage" "Process" "Progress" "Random" "RegDelete" "RegRead" "RegWrite" "Reload" "Repeat" "Return" "Run" "RunAs" "RunWait" "Send" "SendEvent" "SendInput" "SendMessage" "SendMode" "SendPlay" "SendRaw" "SetBatchLines" "SetCapslockState" "SetControlDelay" "SetDefaultMouseSpeed" "SetEnv" "SetFormat" "SetKeyDelay" "SetMouseDelay" "SetNumlockState" "SetScrollLockState" "SetStoreCapslockMode" "SetTimer" "SetTitleMatchMode" "SetWinDelay" "SetWorkingDir" "Shutdown" "Sleep" "Sort" "SoundBeep" "SoundGet" "SoundGetWaveVolume" "SoundPlay" "SoundSet" "SoundSetWaveVolume" "SplashImage" "SplashTextOff" "SplashTextOn" "SplitPath" "StatusBarGetText" "StatusBarWait" "StringCaseSense" "StringGetPos" "StringLeft" "StringLen" "StringLower" "StringMid" "StringReplace" "StringRight" "StringSplit" "StringTrimLeft" "StringTrimRight" "StringUpper" "Suspend" "SysGet" "Thread" "ToolTip" "Transform" "TrayTip" "URLDownloadToFile" "While" "WinActivate" "WinActivateBottom" "WinClose" "WinGet" "WinGetActiveStats" "WinGetActiveTitle" "WinGetClass" "WinGetPos" "WinGetText" "WinGetTitle" "WinHide" "WinKill" "WinMaximize" "WinMenuSelectItem" "WinMinimize" "WinMinimizeAll" "WinMinimizeAllUndo" "WinMove" "WinRestore" "WinSet" "WinSetTitle" "WinShow" "WinWait" "WinWaitActive" "WinWaitClose" "WinWaitNotActive")
  "AHK keywords.")

(defvar xahk-functions
  '("Abs" "ACos" "Asc" "ASin" "ATan" "Ceil" "Chr" "Cos" "DllCall" "Exp" "FileExist" "Floor" "GetKeyState" "IL_Add" "IL_Create" "IL_Destroy" "InStr" "IsFunc" "IsLabel" "Ln" "Log" "LV_Add" "LV_Delete" "LV_DeleteCol" "LV_GetCount" "LV_GetNext" "LV_GetText" "LV_Insert" "LV_InsertCol" "LV_Modify" "LV_ModifyCol" "LV_SetImageList" "Mod" "NumGet" "NumPut" "OnMessage" "RegExMatch" "RegExReplace" "RegisterCallback" "Round" "SB_SetIcon" "SB_SetParts" "SB_SetText" "Sin" "Sqrt" "StrLen" "SubStr" "Tan" "TV_Add" "TV_Delete" "TV_GetChild" "TV_GetCount" "TV_GetNext" "TV_Get" "TV_GetParent" "TV_GetPrev" "TV_GetSelection" "TV_GetText" "TV_Modify" "VarSetCapacity" "WinActive" "WinExist")
  "AHK functions.")

(defvar xahk-keywords
  '("ACos" "ASin" "ATan" "Abort" "AboveNormal" "Abs" "Add" "All" "Alnum" "Alpha" "AltSubmit" "AltTab" "AltTabAndMenu" "AltTabMenu" "AltTabMenuDismiss" "AlwaysOnTop" "And" "Asc" "AutoSize" "Background" "BackgroundTrans" "BelowNormal" "Between" "BitAnd" "BitNot" "BitOr" "BitShiftLeft" "BitShiftRight" "BitXOr" "Border" "Bottom" "Bottom" "Button" "Buttons" "ByRef" "Cancel" "Cancel" "Capacity" "Caption" "Ceil" "Center" "Center" "Check" "Check3" "Checkbox" "Checked" "CheckedGray" "Choose" "ChooseString" "Chr" "Click" "Close" "Close" "Color" "ComboBox" "Contains" "ControlList" "Cos" "Count" "DDL" "Date" "DateTime" "Days" "Default" "Delete" "DeleteAll" "Delimiter" "Deref" "Destroy" "Digit" "Disable" "Disabled" "DropDownList" "Eject" "Enable" "Enabled" "Error" "ExStyle" "Exist" "Exp" "Expand" "FileSystem" "First" "Flash" "Float" "FloatFast" "Floor" "Focus" "Font" "Grid" "Group" "GroupBox" "GuiClose" "GuiContextMenu" "GuiDropFiles" "GuiEscape" "GuiSize" "HKCC" "HKCR" "HKCU" "HKEY_CLASSES_ROOT" "HKEY_CURRENT_CONFIG" "HKEY_CURRENT_USER" "HKEY_LOCAL_MACHINE" "HKEY_USERS" "HKLM" "HKU" "HScroll" "Hdr" "Hidden" "Hide" "High" "Hours" "ID" "IDLast" "Icon" "IconSmall" "Ignore" "ImageList" "In" "Integer" "IntegerFast" "Interrupt" "Is" "Join" "LTrim" "Label" "Label" "LastFound" "LastFoundExist" "Left" "Limit" "Lines" "List" "ListBox" "ListView" "Ln" "Lock" "Log" "Logoff" "Low" "Lower" "Lowercase" "MainWindow" "Margin" "MaxSize" "Maximize" "MaximizeBox" "MinMax" "MinSize" "Minimize" "MinimizeBox" "Minutes" "Mod" "MonthCal" "Mouse" "Move" "Multi" "NA" "No" "NoActivate" "NoDefault" "NoHide" "NoIcon" "NoMainWindow" "NoSort" "NoSortHdr" "NoStandard" "NoTab" "NoTimers" "Normal" "Not" "Number" "Number" "Off" "Ok" "On" "Or" "OwnDialogs" "Owner" "Parse" "Password" "Password" "Pic" "Picture" "Pixel" "Pos" "Pow" "Priority" "ProcessName" "REG_BINARY" "REG_DWORD" "REG_EXPAND_SZ" "REG_MULTI_SZ" "REG_SZ" "RGB" "RTrim" "Radio" "Range" "Read" "ReadOnly" "Realtime" "Redraw" "Region" "Relative" "Rename" "Report" "Resize" "Restore" "Retry" "Right" "Round" "Screen" "Seconds" "Section" "Section" "Serial" "SetLabel" "ShiftAltTab" "Show" "Sin" "Single" "Slider" "SortDesc" "Sqrt" "Standard" "Status" "StatusBar" "StatusCD" "Style" "Submit" "SysMenu" "Tab" "Tab2" "TabStop" "Tan" "Text" "Text" "Theme" "Tile" "Time" "Tip" "ToggleCheck" "ToggleEnable" "ToolWindow" "Top" "Top" "Topmost" "TransColor" "Transparent" "Tray" "TreeView" "TryAgain" "Type" "UnCheck" "Unicode" "Unlock" "UpDown" "Upper" "Uppercase" "UseErrorLevel" "VScroll" "Vis" "VisFirst" "Visible" "Wait" "WaitClose" "WantCtrlA" "WantF2" "WantReturn" "Wrap" "Xdigit" "Yes" "ahk_class" "ahk_group" "ahk_id" "ahk_pid" "bold" "global" "italic" "local" "norm" "static" "strike" "underline" "xm" "xp" "xs" "ym" "yp" "ys" "{AltDown}" "{AltUp}" "{Blind}" "{Click}" "{CtrlDown}" "{CtrlUp}" "{LWinDown}" "{LWinUp}" "{RWinDown}" "{RWinUp}" "{Raw}" "{ShiftDown}" "{ShiftUp}")
  "AHK lang keywords.")

(defvar xahk-variables
  '("A_AhkPath" "A_AhkVersion" "A_AppData" "A_AppDataCommon" "A_AutoTrim" "A_BatchLines" "A_CaretX" "A_CaretY" "A_ComputerName" "A_ControlDelay" "A_Cursor" "A_DD" "A_DDD" "A_DDDD" "A_DefaultMouseSpeed" "A_Desktop" "A_DesktopCommon" "A_DetectHiddenText" "A_DetectHiddenWindows" "A_EndChar" "A_EventInfo" "A_ExitReason" "A_FormatFloat" "A_FormatInteger" "A_Gui" "A_GuiEvent" "A_GuiControl" "A_GuiControlEvent" "A_GuiHeight" "A_GuiWidth" "A_GuiX" "A_GuiY" "A_Hour" "A_IconFile" "A_IconHidden" "A_IconNumber" "A_IconTip" "A_Index" "A_IPAddress1" "A_IPAddress2" "A_IPAddress3" "A_IPAddress4" "A_ISAdmin" "A_IsCompiled" "A_IsCritical" "A_IsPaused" "A_IsSuspended" "A_KeyDelay" "A_Language" "A_LastError" "A_LineFile" "A_LineNumber" "A_LoopField" "A_LoopFileAttrib" "A_LoopFileDir" "A_LoopFileExt" "A_LoopFileFullPath" "A_LoopFileLongPath" "A_LoopFileName" "A_LoopFileShortName" "A_LoopFileShortPath" "A_LoopFileSize" "A_LoopFileSizeKB" "A_LoopFileSizeMB" "A_LoopFileTimeAccessed" "A_LoopFileTimeCreated" "A_LoopFileTimeModified" "A_LoopReadLine" "A_LoopRegKey" "A_LoopRegName" "A_LoopRegSubkey" "A_LoopRegTimeModified" "A_LoopRegType" "A_MDAY" "A_Min" "A_MM" "A_MMM" "A_MMMM" "A_Mon" "A_MouseDelay" "A_MSec" "A_MyDocuments" "A_Now" "A_NowUTC" "A_NumBatchLines" "A_OSType" "A_OSVersion" "A_PriorHotkey" "A_ProgramFiles" "A_Programs" "A_ProgramsCommon" "A_ScreenHeight" "A_ScreenWidth" "A_ScriptDir" "A_ScriptFullPath" "A_ScriptName" "A_Sec" "A_Space" "A_StartMenu" "A_StartMenuCommon" "A_Startup" "A_StartupCommon" "A_StringCaseSense" "A_Tab" "A_Temp" "A_ThisFunc" "A_ThisHotkey" "A_ThisLabel" "A_ThisMenu" "A_ThisMenuItem" "A_ThisMenuItemPos" "A_TickCount" "A_TimeIdle" "A_TimeIdlePhysical" "A_TimeSincePriorHotkey" "A_TimeSinceThisHotkey" "A_TitleMatchMode" "A_TitleMatchModeSpeed" "A_UserName" "A_WDay" "A_WinDelay" "A_WinDir" "A_WorkingDir" "A_YDay" "A_YEAR" "A_YWeek" "A_YYYY" "Clipboard" "ClipboardAll" "ComSpec" "ErrorLevel" "ProgramFiles" "True" "False" )
  "AHK variables.")

(defvar xahk-keys
  '("Alt" "AltDown" "AltUp" "AppsKey" "BS" "BackSpace" "Browser_Back" "Browser_Favorites" "Browser_Forward" "Browser_Home" "Browser_Refresh" "Browser_Search" "Browser_Stop" "CapsLock" "Control" "Ctrl" "CtrlBreak" "CtrlDown" "CtrlUp" "Del" "Delete" "Down" "End" "Enter" "Esc" "Escape" "F1" "F10" "F11" "F12" "F13" "F14" "F15" "F16" "F17" "F18" "F19" "F2" "F20" "F21" "F22" "F23" "F24" "F3" "F4" "F5" "F6" "F7" "F8" "F9" "Home" "Ins" "Insert" "Joy1" "Joy10" "Joy11" "Joy12" "Joy13" "Joy14" "Joy15" "Joy16" "Joy17" "Joy18" "Joy19" "Joy2" "Joy20" "Joy21" "Joy22" "Joy23" "Joy24" "Joy25" "Joy26" "Joy27" "Joy28" "Joy29" "Joy3" "Joy30" "Joy31" "Joy32" "Joy4" "Joy5" "Joy6" "Joy7" "Joy8" "Joy9" "JoyAxes" "JoyButtons" "JoyInfo" "JoyName" "JoyPOV" "JoyR" "JoyU" "JoyV" "JoyX" "JoyY" "JoyZ" "LAlt" "LButton" "LControl" "LCtrl" "LShift" "LWin" "LWinDown" "LWinUp" "Launch_App1" "Launch_App2" "Launch_Mail" "Launch_Media" "Left" "MButton" "Media_Next" "Media_Play_Pause" "Media_Prev" "Media_Stop" "NumLock" "Numpad0" "Numpad1" "Numpad2" "Numpad3" "Numpad4" "Numpad5" "Numpad6" "Numpad7" "Numpad8" "Numpad9" "NumpadAdd" "NumpadClear" "NumpadDel" "NumpadDiv" "NumpadDot" "NumpadDown" "NumpadEnd" "NumpadEnter" "NumpadHome" "NumpadIns" "NumpadLeft" "NumpadMult" "NumpadPgdn" "NumpadPgup" "NumpadRight" "NumpadSub" "NumpadUp" "PGDN" "PGUP" "Pause" "PrintScreen" "RAlt" "RButton" "RControl" "RCtrl" "RShift" "RWin" "RWinDown" "RWinUp" "Right" "ScrollLock" "Shift" "ShiftDown" "ShiftUp" "Space" "Tab" "Up" "Volume_Down" "Volume_Mute" "Volume_Up" "WheelDown" "WheelLeft" "WheelRight" "WheelUp" "XButton1" "XButton2")
  "AHK keywords for keys.")

(defvar xahk-commands-regexp (regexp-opt xahk-commands 'words))
(defvar xahk-functions-regexp (regexp-opt xahk-functions 'words))
(defvar xahk-keywords-regexp (regexp-opt xahk-keywords 'words))
(defvar xahk-variables-regexp (regexp-opt xahk-variables 'words))
(defvar xahk-keys-regexp (regexp-opt xahk-keys 'words))

(setq xahk-font-lock-keywords
      `(
        (,xahk-commands-regexp . xahk-mode-command-name-face)
        (,xahk-functions-regexp . font-lock-function-name-face)
        (,xahk-keywords-regexp . font-lock-keyword-face)
        (,xahk-variables-regexp . font-lock-variable-name-face)
        (,xahk-keys-regexp . font-lock-constant-face)
        ;; note: order matters
        ))

;; keyword completion
(defvar xahk-kwdList nil "AHK keywords.")

(setq xahk-kwdList (make-hash-table :test 'equal))
(mapc (lambda (x) (puthash x t xahk-kwdList)) xahk-commands)
(mapc (lambda (x) (puthash x t xahk-kwdList)) xahk-functions)
(mapc (lambda (x) (puthash x t xahk-kwdList)) xahk-keywords)
(mapc (lambda (x) (puthash x t xahk-kwdList)) xahk-variables)
(mapc (lambda (x) (puthash x t xahk-kwdList)) xahk-keys)
(put 'xahk-kwdList 'risky-local-variable t)

(defun xahk-complete-symbol ()
  "Perform keyword completion on word before cursor.
Keywords include all AHK's event handlers, functions, and CONSTANTS."
  (interactive)
  (let ((posEnd (point))
        (meat (thing-at-point 'symbol))
        maxMatchResult)

    (when (not meat) (setq meat ""))

    (setq maxMatchResult (try-completion meat xahk-kwdList))
    (cond ((eq maxMatchResult t))
          ((null maxMatchResult)
           (message "Can't find completion for “%s”" meat)
           (ding))
          ((not (string= meat maxMatchResult))
           (delete-region (- posEnd (length meat)) posEnd)
           (insert maxMatchResult))
          (t (message "Making completion list...")
             (with-output-to-temp-buffer "*Completions*"
               (display-completion-list
                (all-completions meat xahk-kwdList)
                meat))
             (message "Making completion list...%s" "done")))))

;; clear memory
(setq xahk-commands nil)
(setq xahk-functions nil)
(setq xahk-keywords nil)
(setq xahk-variables nil)
(setq xahk-keys nil)

;;;###autoload
(defun xahk-mode ()
  "Major mode for editing AutoHotKey script (AHK).

Shortcuts             Command Name
\\[comment-dwim]       `comment-dwim'

\\[xahk-complete-symbol]      `xahk-complete-symbol'

\\[xahk-lookup-ahk-ref]     `xahk-lookup-ahk-ref'

Complete documentation at URL `http://xahlee.org/mswin/emacs_autohotkey_mode.html'."
  (interactive)
  (kill-all-local-variables)
  (c-mode) ; for indentation
  (set (make-local-variable 'c-basic-offset) 4)
  (c-set-offset 'statement-cont 0)
  (c-set-offset 'brace-list-entry 0)
  (c-set-offset 'statement 0)
  (c-set-offset 'substatement-open 0)
  (c-set-offset 'substatement 0)
  (c-set-offset 'label '+)
  (setq major-mode 'xahk-mode)
  (setq mode-name "AHK")
  (set-keymap-parent xahk-mode-map c-mode-base-map)
   (use-local-map xahk-mode-map)

  (set-syntax-table xahk-mode-syntax-table)

  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults '((xahk-font-lock-keywords) nil t))
  (set (make-local-variable 'comment-start) "; ")
  (set (make-local-variable 'comment-end) "")
  (set (make-local-variable 'comment-start-skip) ";+[\t ]*")

  ;; clear memory
  (setq xahk-commands-regexp nil)
  (setq xahk-functions-regexp nil)
  (setq xahk-keywords-regexp nil)
  (setq xahk-variables-regexp nil)
  (setq xahk-keys-regexp nil)

  (run-mode-hooks 'xahk-mode-hook))
(provide 'xahk-mode)
