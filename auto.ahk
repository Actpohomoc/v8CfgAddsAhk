Menu, Popup, Add, ���������, ���������
Menu, Folders, Add, ��� ���������, MyComputer
Menu, Folders, Add, ������ ����������, Panel
Menu, Folders, Add, �������, Bin
Menu, Popup, Add, &�������
Menu, Popup, Add, �����, :Folders
; menu, tray, add, "TestToggle&Check"

#sc02D::Menu, Popup, Show ; ���. ����. WIN+X

MButton:: ; ������� ������ ���� �� ������� �����
MouseGetPos, x, y, win
WinGetClass, class, ahk_id %win%
IfEqual, class, Progman
    Menu, Popup, Show
Else
    MouseClick, Middle
Return

���������:
   SendInput, ���������;
Return

&�������:
Run, iexplore
Return

MyComputer:
Run ::{20d04fe0-3aea-1069-a2d8-08002b30309d}
Return

Bin:
Run ::{645ff040-5081-101b-9f08-00aa002f954e}
Return

Panel:
Run rundll32.exe shell32.dll`,Control_RunDLL
Return


::tt::
   SendInput, ^+{left}^{ins}{Right}{space}{scD}{Space}+{ins}{Space}{sc4E}{Space}1
Return

#SingleInstance Force
#vk57 up::   ;Ctrl+w
   ClipBoard =
   SendInput ^{vk43}    ;  "C"
   ClipWait, 3
   Sleep, 300
   InputBox, str, ����������, %Clipboard%,, 400, 120
   if !ErrorLevel && str
   {
      FileAppend, % "`n::" . str . "::" . Clipboard, %A_ScriptFullPath%
      Reload
   }
Return

::++:: 
   SendInput, ^+{left}^{ins}{Right}{space}{scD}{Space}+{ins}{sc4E}{Space}1;
Return

::--:: 
   SendInput, ^+{left}^{ins}{Right}{space}{scD}{Space}+{ins}{sc4A}{Space}1;
Return

::-=:: 
   SendInput, ^+{left}^{ins}{Right}{space}{scD}{Space}+{ins}{sc4A}{Space}
Return

::+=:: 
   SendInput, ^+{left}^{ins}{Right}{space}{scD}{Space}+{ins}{sc4E}{Space}
Return

!^Space:: 
   ;MsgBox, hi
   ;Menu, Popup, Show ; ���. ����. WIN+X
   Menu, Popup, Show ; ���. ����. WIN+X
Return
 

