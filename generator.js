fso = new ActiveXObject("Scripting.FileSystemObject");
choicer = new ActiveXObject("SvcSvc.Service");

function setDefaultCfg() {
	Folder = fso.GetFolder('configs/')
	Files = new Enumerator(Folder.Files);
	cfgName = '';
	for (var i=0; i < Folder.Files.Count; i++)
	{
		if (Files.item()!=undefined) 
		{
			cfgName += Files.item().Name + "\r\n";
		}
		Files.moveNext()
	}
	vRes = SelectValue(cfgName);
	wtiteToResultFile('configs/default.txt', vRes);
	wtiteToResultFile('tmp/module.txt', '');
	WScript.Quit(1);
	return;
}


function SelectValue(values, header) {
	return choicer.FilterValue(values, 273, header, 0, 0, 0, 0);
}

function ResultList(prmStr,prmCaption)
{
	vRes = choicer.FilterValue(prmStr, 273, prmCaption, 0, 0, 0, 0);
	if (!(vRes) == "")
	{
		return vRes;
	}
}

function GetFromClipboard() {
	clip = new ActiveXObject("WshExtra.Clipboard");
	str = clip.Paste();
	clip = 0;
	return str;
}

// function SetToClipboard(dataToClip) {
	// clip = new ActiveXObject("WshExtra.Clipboard");
	// clip.Copy(dataToClip);
	// clip = 0;
// }

function choiceMDObject() {
    
	// ����� �������� ����� ����������
	File = fso.GetFile("configs/default.txt");
	TextStream = File.OpenAsTextStream(1);
	cfg_file_name = TextStream.ReadLine();
	
	File = fso.GetFile("configs/"+cfg_file_name);
	TextStream = File.OpenAsTextStream(1);
	
	// �������� ������ ��������� �������� ����������
	str = TextStream.ReadLine();
	File = 0;
	str1 = str.replace(/\,/g,"\r\n");
	
	// �������� ������
	md_obj = ResultList(str1,"");
	
	// ������� ����� ������ � ����� ��� ������� ������� ����������
	var lList = str1.split('\r').join('').split('\n');
	pos = -1;
	for (var i = 0; i < lList.length; i++) {
		if (lList[i]==md_obj) {
			pos = i;
		}
	}
	
	// �������� ��������� ������� ����������
	str = TextStream.ReadAll();
	var lList = str.split('\r').join('').split('\n');
	str = lList[pos];
	
	return str;
}


function wtiteToResultFile(file_name, file_data) {
	f = fso.CreateTextFile(file_name, true);
	f.Write(file_data);
	f.Close();
}

function ModuleFromSimpleToManagment()
{
	str = choiceMDObject();
	if (str == "") {
		wtiteToResultFile("tmp/module.txt","");
		WScript.Quit(0);
		return;
	}
	
	// �������� ��������� �����
	item_ar = str.split('|');
	str_items = item_ar[1];
	
	// �������� �������� ��������� ������
	for (var i = 2; i < item_ar.length; i++) {
		item_ar_sub = item_ar[i].split(',');
		str_items = str_items + item_ar_sub[0] + ",";
	}
	
	// ����������� �������������� ��� ������
	str_items = str_items.replace(/\,/g,'|');
	str_items = str_items.substring(0,str_items.length-1);
	
	// �������� �������� ��������� ��������� �����
	result = ResultList("������\r\n�����\r\n","��������");
	var re = new RegExp("[\\W]("+str_items+").\\W", "ig");
	str_module = GetFromClipboard();
	
	// ���������� ������ ����
	// 1. ��������� ��������� ����������� �������
	str_module = str_module.replace(/[\*\-\+\=\/\(]/g,' $& ');
	// 2. ��������� �������� ��������� ��������� � ������
	str_module = str_module.replace(re," "+result+".$&").replace(/\.\s/g, '.');
	
	// ����� ��������� � ����
	wtiteToResultFile("tmp/module.txt",str_module);
}

function printArrayToCodeGen(text, arr, start_pos, prefix) {
	for (var i = start_pos; i < arr.length; i++) {
		if (arr[i] != '') {
			text += prefix + '.' +arr[i] + ' = ;\r\n';
		}
	}
	return text;
}

function generateCodeMDObject(md_obj_part) {
	str = choiceMDObject();
	if (str == "") {
		wtiteToResultFile("tmp/module.txt","");
		WScript.Quit(0);
		return;
	}
	vars = ('���,���,������').replace(/\,/g,'\r\n');
	varName = SelectValue(vars);
	
	// �������� ��������� �����
	item_ar = str.split('|');
	md_type = item_ar[0];
	md_type_ar = md_type.split('.');
	
	text = '';
	
	if ((md_type_ar[0] == '��������') || (md_type_ar[0] == '����������')) {
		if (md_type_ar[0] == '��������') {
			text += varName + ' = ���������.' + md_type_ar[1] + '.���������������();\n'
		}
		if (md_type_ar[0] == '����������') {
			text += varName + ' = �����������.' + md_type_ar[1] + '.��������������();\n'
		}
		// �����
		text = printArrayToCodeGen(text, item_ar[1].split(','),0,varName);
		
		if (md_obj_part == '�����') {
			wtiteToResultFile('tmp/module.txt', text);
			WScript.Quit(1);
			return;
		}

		if (md_obj_part == '��������� �����') {
			text = '';

			details_list = '';
			// �������� �������� ��������� ������
			for (var i = 2; i < item_ar.length; i++) {
				item_ar_sub = item_ar[i].split(',');
				details_list += item_ar_sub[0] + '\r\n';
			}
			
			detName = SelectValue(details_list,'');
			if (detName == "") {
				wtiteToResultFile('tmp/module.txt', '');
				WScript.Quit(0);
				return;
			}
			
			for (var i = 2; i < item_ar.length; i++) {
				item_ar_sub = item_ar[i].split(',');
				if (item_ar_sub[0] == detName) {
					text += '������ = ' + varName + '.' + item_ar_sub[0] + '.��������();\r\n';
					text = printArrayToCodeGen(text, item_ar[i].split(','), 1, '������');
					text += '\r\n\r\n';
				}
			}
			
			wtiteToResultFile('tmp/module.txt', text);
			WScript.Quit(1);
			return;
		}

		
		text += '\r\n\r\n';
		// �������� �������� ��������� ������
		for (var i = 2; i < item_ar.length; i++) {
			item_ar_sub = item_ar[i].split(',');
			text += '������ = ' + varName + '.' + item_ar_sub[0] + '.��������();\r\n';
			text = printArrayToCodeGen(text, item_ar[i].split(','), 1, '������');
			text += '\r\n\r\n';
		}
	} 
	else {
		text += varName + ' = ��������.' + md_type_ar[1] + '.��������();\r\n'
		// ����������� ���������
		text += '\r\n';
		text += '// ����������� ���������';
		text += '\r\n';
		text = printArrayToCodeGen(text, item_ar[1].split(','),0,varName);
		// �������� ���������
		text += '\r\n// ���������\r\n';
		text = printArrayToCodeGen(text, item_ar[2].split(','), 0, varName);
		// �������� �������
		text += '\r\n// �������\r\n';
		text = printArrayToCodeGen(text, item_ar[3].split(','), 0, varName);
		// �������� ���������
		text += '\r\n// ���������\r\n';
		text = printArrayToCodeGen(text, item_ar[4].split(','), 0, varName);
	}
	
	wtiteToResultFile('tmp/module.txt', text);
}

function codeGenerator() {
	lstrRes = ("������ ����������,��������� �����,�����,������������ �� ���������").replace(/\,/g,'\r\n');;
	vRes = SelectValue(lstrRes);
	if (vRes == '������������ �� ���������') {
		setDefaultCfg();
	}
	else {
		generateCodeMDObject(vRes);	
	}
	
}

function Run() {
	
    arg=WScript.Arguments;

    fso = new ActiveXObject("Scripting.FileSystemObject");
	if (arg(0) != 'null') {
		f=fso.OpenTextFile(arg(0),1);
		var lTxt=f.ReadAll();
		var lList =lTxt.split('\r').join('').split('\n');
		f.close();
	}
	switch (arg(1)) {
		case "simple-managment":
			ModuleFromSimpleToManagment();
			break;
		case "generator":
			codeGenerator();
			break;
		default:
			return; // �� ������ ���� � ��������
	}
}

Run();