#include Clipboard_rus_subs.ahk
#include WorkWithModule.ahk
#include KeyCodes.ahk

Ctrl_A = ^{SC01E}
Ctrl_L = ^{SC026}
Ctrl_Shift_Z = ^+{SC02C}

; �������������� ������
F6::
	module = tmp\module.1s
	PutCurrentModuleTextIntoFileFast(module)
	RunWait, perl code_beautifier.pl -f %module%
	FileRead, text, %module%
	SaveClipboard()
	clipboard =
	ClipPutText(text)
	ClipWait
	SendInput +{ins}
	RestoreClipboard()
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
	SendInput, ^{ins}
	ClipWait , 1
	RunWait, wscript author.js %prmVar%
	ClipWait , 1
	FileRead, newText, tmp\actxt.tmp
	ClipWait , 1
	Clipboard := newText
	SendInput +{ins}
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
	SendInput, ^{ins}
	ClipWait , 1
	ClipWait , 1
	RunWait, wscript generator.js null simple-managment
	ClipWait , 1
	FileRead, text, tmp\module.txt
	ClipWait , 1
	ClipPutText(text)
	ClipWait , 1
	SendInput +{ins}
return

; Alt+g - ����� ����������� ����
!g::
	SendInput, ^{ins}
	ClipWait
	RunWait, wscript generator.js null generator
	ClipWait
	FileRead, text, tmp\module.txt
	ClipWait
	ClipPutText(text)
	ClipWait
	SendInput +{ins}
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

; Ctrl+m - ������������ �������
^m::
	SendInput, ^{ins}
	ClipWait , 1
	RunWait, wscript scripts_manager.js
	FileRead, newText, tmp\module.txt
	ClipWait , 1
	Clipboard := newText
	SendInput +{ins}
return

; Ctrl +w ����� ����� ���������� �����
^w::
	set_locale_ru()
	SendInput, ^+{Home}^{ins}{Right} 
	FileAppend, %clipboard%, tmp\moduletext.txt
	SendInput, ^+{End}^{ins}{Left} 
	FileAppend, %clipboard%, tmp\moduletext.txt
	RunWait, wscript scripts.js tmp\moduletext.txt words
	FileRead, text, tmp\module.txt
	Clipboard := text
	ClipWait , 1
	SendInput +{ins}
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
	RunWait, wscript scripts.js tmp\moduletext.txt BeginMethod
	if (ErrorLevel > 0) {
		nStr := ErrorLevel
		SendInput ^%KeyG%%nStr%{ENTER}
	}   
	SendInput, {home}
return

; Ctrl + e - � ����� ������
^e::
	getTextUp()
	RunWait, wscript scripts.js tmp\moduletext.txt EndMethod
	if (ErrorLevel > 0) {
		nStr := ErrorLevel
		SendInput ^%KeyG%%nStr%{ENTER}
		SendInput ^{SC01A}
	}   
	SendInput, {home}
return

; Ctrl + 2 - ����� ������ ������
^2::
	module = tmp\module.1s
	PutCurrentModuleTextIntoFileFast(module)
	SendInput, {home}
	RunWait, wscript scripts.js %module% sectionslist
	if (ErrorLevel > 0) {
		nStr := ErrorLevel
		SendInput ^%KeyG%%nStr%{ENTER}
	}
	SendInput, {home}
	SendInput, ^{NumpadAdd}
return