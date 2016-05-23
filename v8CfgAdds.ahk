; #include Clipboard_rus_subs.ahk
#include KeyCodes.ahk
#include WorkWithModule.ahk

Ctrl_A = ^{SC01E}
Ctrl_L = ^{SC026}
Ctrl_Shift_Z = ^+{SC02C}

; �������������� ������
F6::
	putModuleInFile()
	RunWait, perl code_beautifier.pl -f %module%
	pasteTextFromFile()
	;FileRead, text, %module%
	;SaveClipboard()
	;clipboard =
	;ClipPutText(text)
	;ClipWait
	;SendInput +{ins}
	;RestoreClipboard()
return
; ----------------------------------
; Ctrl + 1 ����� ������ ��������
^1::
	module = tmp\module.1s
	PutCurrentModuleTextIntoFileFast(module)
	SendInput, {home}
	RunWait, wscript scripts.js %module% proclist
	if (ErrorLevel > 0) {
		nStr := ErrorLevel
		SendInput ^%KeyG%%nStr%{ENTER}
	}
	SendInput, {home}
	SendInput, ^{NumpadAdd}
return

;-----------------------------------------------
; --- ����� � ����������� ����������� ---
; Alt + f - ����� � ���.�����������
!f::
   module = tmp\module.1s
   PutCurrentModuleTextIntoFileFast(module)
   SendInput, {home}
   RunWait, wscript scripts.js %module% search
   if (ErrorLevel > 0) {
	  nStr := ErrorLevel
	  Sleep 1
	  SendInput ^%KeyG%%nStr%{ENTER}
   }   
   SendInput, {home}
   SendInput, ^{NumpadAdd}
return
;-----------------------------------------------
; Alt + r - ���������� ���������� ������
!r::
   SendInput, {home}
   RunWait, wscript scripts.js null search-last
   if (ErrorLevel > 0) {
	  nStr := ErrorLevel
	  SendInput ^%KeyG%%nStr%{ENTER}
   }   
   SendInput, {home}
   SendInput, ^{NumpadAdd}
return

; --- ������ ---
; ctrl + / (ctrl + .) - ��������������� ������:
^/:: Send, {home}//

; Ctrl + i - ���������� ������: 
^i:: SendInput, ^+{NumpadAdd}

; Ctrl+y - �������� ������
$^SC015:: SendInput %Ctrl_L%

; Ctrl-, - ������ '<'
$^,:: SendInput <

; Ctrl-. ������ '>'
$^.:: SendInput >

; Ctrl-\ ������ '|'
$^\:: SendInput |

; Alt - [ - ������ '['
$!SC01A::Send [ 

; Alt + ] - ������ ']'
$!SC01B::Send ] 

; Ctrl - & - ������ '&'
$^SC008::Send &

; Ctrl + D - ����������� ������� ������ � ������� � ���������
^d:: Send, {HOME}{SHIFTDOWN}{END}{SHIFTUP}{CTRLDOWN}{INS}{CTRLUP}{END}{ENTER}{SHIFTDOWN}{INS}{SHIFTUP}

; ----------------------------------------
; ��������� �����������
; ----------------------------------------
runAuthorComments(prmVar)
{
	putSelectionInFile()
	RunWait, wscript author.js %prmVar%
	pasteTextFromFile()
}

!s::	runAuthorComments("new") ; alt+s - ���� ��������
!e::	runAuthorComments("edit") ; alt+e - ���� �������
!d::	runAuthorComments("del") ; alt+d - ���� ������

; ����� ��������� �����������
; ----------------------------------------

;�������� ���� ��������� Ctrl+z (�� ���� ��������)
;$^SC02C::SendInput %Ctrl_Shift_Z%

;-----------------------------------
; �������� �� ���������� � ����� OpenConf
;
; Ctrl + Enter - ������� � ��������� (��� � OpenConf)
^Enter::
	SendInput, {F12}
return

; Alt + - ������� �� ���������� ������� (��� � OpenConf)
!left::
	SendInput, ^-
return
;------------------------------------

; Alt+h - ���������� ������ �� �������� � ������
!h::
	putSelectionInFile()
	RunWait, wscript generator.js null simple-managment
	pasteTextFromFile()
return

; Alt+g - ����� ����������� ����
!g::
	putSelectionInFile()
	RunWait, wscript generator.js null generator
	pasteTextFromFile()	
return


; Alt+7 - ������������ �������
!SC008::
	set_locale_ru()
	RunWait, wscript scripts.js null preprocmenu
	set_locale_ru()
	FileRead, text, tmp\module.txt
	set_locale_ru()
	SendInput, %text%
return

; Ctrl + m - ������ �������
^m::
	putSelectionInFile()
	RunWait, wscript scripts_manager.js
	pasteTextFromFile()
return

; Ctrl + w ����� ����� ���������� �����
^w::
	putModuleInFile()
	RunWait, wscript scripts.js tmp\module.txt words
	pasteTextFromFile()
return

; Alt + J - ����� �� ����������
!j::
	SendInput, ^+%KeyC%
	Sleep 10
	SendInput ^%KeyF%
return

; Ctrl + b - � ������ ������
^b::
	getTextUp()
	RunWait, wscript scripts.js tmp\module.txt BeginMethod
	if (ErrorLevel > 0) {
		nStr := ErrorLevel
		SendInput ^%KeyG%%nStr%{ENTER}
	}   
	SendInput, {home}
return

; Ctrl + e - � ����� ������
^e::
	getTextUp()
	RunWait, wscript scripts.js tmp\module.txt EndMethod
	if (ErrorLevel > 0) {
		nStr := ErrorLevel
		SendInput ^%KeyG%%nStr%{ENTER}
		SendInput ^{SC01A}
	}   
	SendInput, {home}
return

; Ctrl + 2 - ����� ������ ������
^2::
	putModuleInFile()
	SendInput, {home}
	RunWait, wscript scripts.js tmp\module.txt sectionslist
	if (ErrorLevel > 0) {
		nStr := ErrorLevel
		SendInput ^%KeyG%%nStr%{ENTER}
	}
	SendInput, {home}
	SendInput, ^{NumpadAdd}
return

; Ctrl + 3 - �������� ������� ������
^3::
	RunWait, wscript ExtFiles.js
	FileRead, newText, tmp\module.txt
	Clipboard := newText
	ClipWait
	Sleep 1
	set_locale_ru()
	SendInput, !%KeyA%
	SendInput, {DOWN}{DOWN}{Enter}
	Sleep 1000
	SendInput, ^%KeyV%
	Sleep 1000
	SendInput, {Enter}
return