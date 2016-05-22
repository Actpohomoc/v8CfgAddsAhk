pasteTextFromFile() {
  FileRead, newText, tmp\module.txt
  ClipWait, 1
  Clipboard := newText
  ClipWait, 1
  SendInput +{ins}
}

set_locale_ru()
{
	SendMessage, 0x50,, 0x4190419,, A
}

set_locale_en()
{
  SendMessage, 0x50,, 0x4090409,, A 
}

;From http://forum.script-coding.info  (http://forum.script-coding.info/viewtopic.php?id=1073)
ClipPutText(Text, LocaleID=0x419)
{
  CF_TEXT:=1, CF_LOCALE:=16, GMEM_MOVEABLE:=2
  TextLen   :=StrLen(Text)
  HmemText  :=DllCall("GlobalAlloc", UInt, GMEM_MOVEABLE, UInt, TextLen+1)  ; ������ ������������
  HmemLocale:=DllCall("GlobalAlloc", UInt, GMEM_MOVEABLE, UInt, 4)  ; ������, ������������ ������.
  If(!HmemText || !HmemLocale)
    Return
  PtrText   :=DllCall("GlobalLock",  UInt, HmemText)   ; �������� ������, ������ ��������������
  PtrLocale :=DllCall("GlobalLock",  UInt, HmemLocale) ; � ��������� (������).
  DllCall("msvcrt\memcpy", UInt, PtrText, Str, Text, UInt, TextLen+1) ; ����������� ������.
  NumPut(LocaleID, PtrLocale+0)		     ; ������ �������������� ������.
  DllCall("GlobalUnlock",     UInt, HmemText)   ; ����������� ������.
  DllCall("GlobalUnlock",     UInt, HmemLocale)
  If not DllCall("OpenClipboard", UInt, 0)	; �������� ������ ������.
  {
    DllCall("GlobalFree", UInt, HmemText)    ; ������������ ������,
    DllCall("GlobalFree", UInt, HmemLocale)  ; ���� ������� �� �������.
    Return
  }
  DllCall("EmptyClipboard")			   ; �������.
  DllCall("SetClipboardData", UInt, CF_TEXT,   UInt, HmemText)   ; ��������� ������.
  DllCall("SetClipboardData", UInt, CF_LOCALE, UInt, HmemLocale)
  DllCall("CloseClipboard")						  ; ��������.
}




ClipGetText(CodePage=1251)
{
  CF_TEXT:=1, CF_UNICODETEXT:=13, Format:=0
  If not DllCall("OpenClipboard", UInt, 0)		     ; �������� ������ ������.
    Return
  Loop
  {
    Format:=DllCall("EnumClipboardFormats", UInt, Format)  ; ������� ��������.
    If(Format=0 || Format=CF_TEXT || Format=CF_UNICODETEXT)
	Break
  }
  If(Format=0)	  ; ������ �� �������.
    Return
  If(Format=CF_TEXT)
  {
    HmemText:=DllCall("GetClipboardData", UInt, CF_TEXT)  ; ��������� ������ ������.
    PtrText :=DllCall("GlobalLock",	 UInt, HmemText) ; ����������� ������ � ���������.
    TextLen :=DllCall("msvcrt\strlen",    UInt, PtrText)  ; ��������� ����� ���������� ������.
    VarSetCapacity(Text, TextLen+1)  ; ���������� ��� ���� �����.
    DllCall("msvcrt\memcpy", Str, Text, UInt, PtrText, UInt, TextLen+1) ; ����� � ����������.
    DllCall("GlobalUnlock", UInt, HmemText)  ; ����������� ������.
  }
  Else If(Format=CF_UNICODETEXT)
  {
    HmemTextW:=DllCall("GetClipboardData", UInt, CF_UNICODETEXT)
    PtrTextW :=DllCall("GlobalLock",	 UInt, HmemTextW)
    TextLen  :=DllCall("msvcrt\wcslen",    UInt, PtrTextW)
    VarSetCapacity(Text, TextLen+1)
    DllCall("WideCharToMultiByte", UInt, CodePage, UInt, 0, UInt, PtrTextW
					   , Int, TextLen+1, Str, Text, Int, TextLen+1
					   , UInt, 0, Int, 0)  ; ����������� �� Unicode � ANSI.
    DllCall("GlobalUnlock", UInt, HmemTextW)
  }
  DllCall("CloseClipboard")  ; ��������.
  Return Text
} 