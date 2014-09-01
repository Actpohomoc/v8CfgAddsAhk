; �������������� ������ ������� "|" ����� �������� ������, ��� ������������� - Enter.
; �������������� ������ �������� ����������� "//" ����� �������� ������ �� Shift+Enter, ���� �������.������ ����� �������� ������������.

#include WorkWithModule.ahk

IsContinueRowMode := false ;�������� "���������������"
IsContinueRowMode := true  ;������� "���������������"

$SC01C:: ; Enter
$SC11C:: ; Enter �� "��������" ����������
	If IsContinueRowMode
		continueRow("|", """", 1)
	Else
		Send, % "{" . SubStr(A_ThisHotkey, 2) . "}"
   Return

+$SC01C:: ; Shift+Enter
+$SC11C:: ; Shift+Enter �� "��������" ����������
	continueRow("//","//",2)
   Return

;Ctrl + Shift + |
;��������/��������� �������������� ������ ��������

$^+SC02B:: IsContinueRowMode := Not IsContinueRowMode

continueRow(prmStr,prmStrParent,prmNum)  
{
	SaveClipboard()

	_A_KeyDelay := A_KeyDelay 
	SetKeyDelay 0 ;������ ������� ������ ����� ������� �������� ������� ������, ��� ���������� �� ���������.

	SendInput +{Home}^{ins} ;{Right}
	ClipWait , 1
	
	StringReplace clipboard, clipboard, %A_Tab%
	If (StrLen(clipboard) > 0)
		SendInput {Right}
	Else
		clipboard = NULL

	FirstChar := SubStr(clipboard, 1, prmNum)
	if FirstChar = %prmStr%
		fStr := 0
	Else
		fStr := 1

	Loop, parse, clipboard, %prmStrParent%
	{
		fStr := 1 - fStr
	}

	if fStr = 1
	{
		SendInput {SC01C}%prmStr%
	}
	else
	{
		SendInput {SC01C}
	}

	RestoreClipboard()

	SetKeyDelay _A_KeyDelay
}