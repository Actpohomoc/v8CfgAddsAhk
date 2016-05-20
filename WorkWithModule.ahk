; #IfWinActive ������������ ahk_class V8TopLevelFrame
#IfWinActive ahk_class V8TopLevelFrame

#include Clipboard_rus_subs.ahk

; Ctrl_A = ^{SC01E}

getTextUp()
{
	SendInput, ^+{Home}^{ins}{Right} 
	FileDelete tmp\moduletext.txt
	FileAppend, %clipboard%, tmp\moduletext.txt
}

getTextDown()
{
	SendInput, ^+{End}^{ins}{Left} 
	FileDelete tmp\moduletext.txt
	FileAppend, %clipboard%, tmp\moduletext.txt
}


PutCurrentModuleTextIntoFileFast(fileName, flagSaveClipboard = 1)
{
	set_locale_ru()
	if (flagSaveClipboard = 1)
		SaveClipboard()

	module := fileName
	;set_locale_ru()

	;Sleep 30
	SendInput ^{SC01E}^{ins}{Left}
	ClipWait , 1
	
	FileDelete %module%
	FileAppend, %clipboard%, %module%

	if (flagSaveClipboard = 1)
		RestoreClipboard()
}

; ����� ���������� ����� ������ �������� ���������� - ��� ����� ��� ��������� ��������
PutCurrentModuleTextIntoFile(fileName, flagSaveClipboard = 1)
{
	set_locale_ru()
	if (flagSaveClipboard = 1)
		SaveClipboard()

	module := fileName
	;set_locale_ru()

	;Sleep 30
	SendInput ^{SC01E} ; CTRL-A
	;Sleep 30
	SendInput, ^{ins}
	;Sleep 30
	ClipWait , 1
	
	FileDelete %module%
	FileAppend, %clipboard%, %module%

	if (flagSaveClipboard = 1)
		RestoreClipboard()
}

PutCurrentModuleTextIntoTempFile()
{
	module = tmp\module.1s
	PutCurrentModuleTextIntoFile(module)
}

gClipSavedInner45 :=

SaveClipboard()
{
	global gClipSavedInner45 ;
	gClipSavedInner45 := ClipboardAll
	clipboard =

	ClipWait , 1
}

RestoreClipboard()
{
	global gClipSavedInner45 ;
	Clipboard := gClipSavedInner45
	gClipSavedInner45 =
}