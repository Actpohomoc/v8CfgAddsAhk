; ��������� ����� ��� ������� {F11}
^j::
; 	WinWaitActive, ������������ - ������������
	WinWaitActive, , 
	Send, {CTRLDOWN}t{CTRLUP}{APPSKEY}
	IfWinNotActive, , , WinActivate, , 
	WinWaitActive, , 
	Send, {DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}
Return


^k::
WinWait, ������������ - ������������, ����� ��������������
IfWinNotActive, ������������ - ������������, ����� ��������������, WinActivate, ������������ - ������������, ����� ��������������
WinWaitActive, ������������ - ������������, ����� ��������������
MouseClick, left,  623,  96
Sleep, 100
Send, {CTRLDOWN}t{CTRLUP}{APPSKEY}
; WinWait, , 
IfWinNotActive, , , WinActivate, , 
WinWaitActive, , 
Send, {DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}
Return