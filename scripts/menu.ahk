createMenuItems() {

    ; �����, ����� ��������� ������� ����������� ����
    Menu, Popup, Add, 
    Menu, Popup, DeleteAll 

   Menu, Popup, Add, �����&����, ���������
   Menu, Popup, Add, �����&�����, ����������
   Menu, Popup, Add, �����&���������, ��������������
   Menu, Popup, Add, �����&�������, ������������
   Menu, Popup, Add, 
   Menu, Popup, Add, ��������� �� &�����, ����������������

   ��������:
   Return

   ���������:
      SendInput, ���������;
   Return

   ����������:
      SendInput, ����������;
   Return

   ��������������:
      SendInput, ��������������;
   Return

   ������������:
      SendInput, ������������;
   Return

   ����������������:
      putSelectionInFile()
      RunWait, system\OneScript\bin\oscript.exe scripts\format.os align-equal-sign,,Hide
      pasteTextFromFile()
   Return   

}

