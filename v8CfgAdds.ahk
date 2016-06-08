; #include Clipboard_rus_subs.ahk
#include KeyCodes.ahk
#include WorkWithModule.ahk
#include actions.ahk

Ctrl_A = ^{SC01E}
Ctrl_L = ^{SC026}
Ctrl_Shift_Z = ^+{SC02C}

; ----------------------------------
; Ctrl + 1 ����� ������ ��������
^1:: actionShowMethodsList()

; Ctrl + 2 - ����� ������ ������
^2:: actionShowRegionsList()

; Ctrl + 3 - �������� ������� ������
^3:: actionShowExtFilesList()

; Ctrl + Shift + m - ������ �������
^+m:: actionShowScriptManager()

; Ctrl + w ����� ����� ���������� �����
^w:: actionShowPrevWords()

; ----------------------------------
; ������: ��������� ������ ������

; Ctrl + b - � ������ ������
^b:: actionGotoMethodBegin()

; Ctrl + e - � ����� ������
^e:: actionGotoMethodEnd()
; �����: ��������� ������ ������
; ----------------------------------

;-----------------------------------------------
; --- ����� � ����������� ����������� ---
; Alt + f - ����� � ���.�����������
!f:: actionShowRegExSearch()
;-----------------------------------------------
; Alt + r - ���������� ���������� ������
!r:: actionShowRegExSearchLastResult()

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
!s:: actionRunAuthorComments("new") ; alt+s - ���� ��������
!e:: actionRunAuthorComments("edit") ; alt+e - ���� �������
!d:: actionRunAuthorComments("del") ; alt+d - ���� ������
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
!h:: actionRunLinksToItems()

; Alt+g - ����� ����������� ����
!g:: actionShowCodeGenerator()

; Alt+7 - ������������ �������
!SC008:: actionShowPreprocMethod()

;------------------------------------
; ��������� �� ����������

; Alt + J - ����� �� ����������
^k:: actionShowSimpleMetaSearch()

; Ctrl +j - ������� � ������� ���������� �� ���� �������� ���������
$^sc24:: actionShowIncomingObjectTypes()

; Ctrl + shift + j - ������� � ������� ����������
$^+sc24:: actionShowMetadataNavigator()
;------------------------------------
