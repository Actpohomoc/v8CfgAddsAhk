var listFiles = [];
var WshShell = WScript.CreateObject("WScript.Shell");
var fso = new ActiveXObject("Scripting.FileSystemObject");


function JSTrim(vValue) {
	return  vValue.replace(/(^\s*)|(\s*$)/g, "");
}

function echo(prmTxt) {
	with (new ActiveXObject("WScript.Shell")) res = Popup("<"+prmTxt+">", 0, "title", 0);
}

function wtiteToResultFile(file_name, file_data) {
		var fso = new ActiveXObject("Scripting.FileSystemObject");
        f = fso.CreateTextFile(file_name, true);
        f.Write(file_data);
        f.Close();
}

function readFile(fileName) {
	fs = new ActiveXObject("Scripting.FileSystemObject");
	t_file = fs.OpenTextFile(fileName, 1); 
	str = "";
	try {
		str = t_file.ReadAll();
		t_file.Close();
		fs= 0;
	} catch(e) {
		
	}
	return str;
}

function SelectValue(values, header) {
        
        wtiteToResultFile("tmp/app.txt",values);

        WshShell.Run("system\\SelectValueSharp.exe tmp/app.txt", 1, true);
        str = readFile("tmp/app.txt");
        return str;
}

function SearchFile(Folder, RegExpMask){
        var FilesEnumerator = new Enumerator(Folder.Files);
        while (!FilesEnumerator.atEnd()){
                var File = FilesEnumerator.item();
                var FileName = File.Name;//��� �����
                var FilePath = File.Path;//������ ���� � �����
                var FileSize = File.Size;//������ �����
                RegExpMask.compile(RegExpMask);
                var FileByMask = RegExpMask.exec(FileName);
                if (FileByMask){
                        // Log.Write(1, FilePath);//����� ����� ��������� ����� �������� � ��������� ������
                        //WScript.StdOut.WriteLine(FilePath);
                        //listFiles += FilePath + "\r\n";

                         FileExt = fso.GetExtensionName(FilePath);
                         if (FileExt == "os") {
                         	FilePath = "system\\OneScript\\bin\\oscript.exe " + FilePath
                         } else {
                         	FilePath = "wscript " + FilePath;
                         }

                        listFiles[listFiles.length] = { key: FileName, value: FilePath };
                }
                FilesEnumerator.moveNext();
        }
        //����� � ��������� 
        var SubFoldersEnumerator = new Enumerator(Folder.SubFolders);    
        while (!SubFoldersEnumerator.atEnd()){
                var Folder = SubFoldersEnumerator.item();               
                //System.ProcessMessages();//<--����� ����� ������� �������
                //Log.Write(1, Folder.Path);//<--����� ����� ��������� ����� �������� � ��������� ������
                SearchFile(Folder, RegExpMask);
                SubFoldersEnumerator.moveNext();
        }
}


function Run() {
	var array_commands = [
	   { key: '�������� ������� �����', value: 'wscript format.js null format_block_vert' },  
	   { key: '������ ������� �����', value: 'wscript format.js null un_format_block_vert' },
	   { key: '----------------------------------------', value: '' },
	   { key: '��������� � ������� �������', value: 'system\\OneScript\\bin\\oscript.exe ����������������������.os up' },
	   { key: '��������� � ������ �������', value: 'system\\OneScript\\bin\\oscript.exe ����������������������.os down' },
	   { key: '��������� � ���������� �������', value: 'system\\OneScript\\bin\\oscript.exe ����������������������.os normal' },
	   { key: '----------------------------------------', value: '' },
	   { key: '��������� �� �����', value: 'system\\OneScript\\bin\\oscript.exe format.os align-equal-sign' },
	   { key: '��������� �� ������ �������', value: 'system\\OneScript\\bin\\oscript.exe format.os align-first-comma' },
	   { key: '��������� �� ���������� ��������', value: 'system\\OneScript\\bin\\oscript.exe format.os align-user-symbol' },
	   { key: '----------------------------------------', value: '' },
	   { key: '�������� ������', value: 'system\\OneScript\\bin\\oscript.exe ModuleCleaner.os' },
	   { key: '������ ������� �� ����� �����', value: 'system\\OneScript\\bin\\oscript.exe format.os rtrim' },
	   { key: '============ ������������� ����������� ============', value: '' }
	]	
	   
	var FileSystem = new ActiveXObject('Scripting.FileSystemObject');
    var RegExpMask = /.*(\.os|\.js)/igm;
    var Folder = FileSystem.GetFolder('auto');

    //listFiles = '';

    SearchFile(Folder, RegExpMask);
	len = listFiles.length;
    for (var i = 0 ; i < len; i++) {
    	//echo(listFiles[i].key)
    	array_commands[array_commands.length] = listFiles[i];
    }


	var array_run = new Array();
	str_select = "";
	for (var i = 0, len = array_commands.length; i < len; i++) {
		str_select += array_commands[i].key + '\r\n';
	}
	run_command = JSTrim(SelectValue(str_select, '�������'));

	if (run_command != "") {
		for (var i = 0, len = array_commands.length; i < len; i++) {
			if (array_commands[i].key == run_command) {
				if (array_commands[i].value != "") {
					WshShell.Run(array_commands[i].value,0,true);	
					break;
				}
			}
		}
	}
	
}

Run();