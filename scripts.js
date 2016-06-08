var fso = new ActiveXObject("Scripting.FileSystemObject");
//var choicer = new ActiveXObject("SvcSvc.Service");
var WshShell = WScript.CreateObject("WScript.Shell");

function JSTrim(vValue)
{
	return  vValue.replace(/(^\s*)|(\s*$)/g, "");
}

function delFP(vValue)
{
	return  vValue.replace(/\s*(���������|�������|procedure|function|#�������|#region)\s+/i, "");
}

function getTextBeforeBracket(prmTxt)
{
	var nEnd = prmTxt.indexOf("(");
	return prmTxt.substring(0,nEnd);
}

function log(msg) {
	// OpenTextFile("C:\Test.txt", 2, True)
	f = fso.OpenTextFile("log.txt", 8,true);
	f.WriteLine(msg);
	f.Close();
	f=0;
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

function echo(prmTxt)
{
	with (new ActiveXObject("WScript.Shell")) res = Popup("<"+prmTxt+">", 0, "title", 0);
}

function ResultList(prmStr, prmCaption)
{
	wtiteToResultFile("tmp/app.txt", prmStr);

	WshShell.Run("system\\SelectValueSharp.exe tmp\\app.txt",1,true);
	str = readFile("tmp/app.txt");

	if (JSTrim(str) != "") {
		var nEnd = str.indexOf(")")
		var nStr = str.substring(1,nEnd);
		WScript.Quit(nStr);
	} else {
		WScript.Quit(0);
	}
}


// function ResultListDLL(prmStr, prmCaption)
// {
// 	vRes = choicer.FilterValue(prmStr, 273+512, prmCaption, 0, 0, 0, 0);
// 	if (!(vRes) == "")
// 	{
// 		var nEnd = vRes.indexOf(")")
// 		var nStr = vRes.substring(1,nEnd);

// 		WScript.Quit(nStr);
// 	}
// }

function SelectValue(values, header) {
	
	if (JSTrim(values) == "") {
		return "";
	}
	
	wtiteToResultFile("tmp/app.txt",values);

	WshShell.Run("system\\SelectValueSharp.exe tmp/app.txt",1,true);
	str = readFile("tmp/app.txt");
	//echo(str);
	return str;
	
	//return choicer.FilterValue(values, 273+512, header, 0, 0, 0, 0);
}

function wtiteToResultFile(file_name, file_data) {
	f = fso.CreateTextFile(file_name, true);
	f.Write(file_data);
	f.Close();
}

function GetMethList(lStrings)
{

	var re_meth = /^\s*(���������|�������|procedure|function)\s+/i;
	var lListProcFunc = "";

	for(var i=0; i<lStrings.length; i++)
	{
		lStrCurrent = "";
		lStr = lStrings[i];

		var matches = lStr.match(re_meth);
		if (matches != null)
		{
			j = i+1;
			lStrLong = JSTrim(delFP(lStr));
			FuncName = getTextBeforeBracket(lStrLong);
			lListProcFunc += "(" + j + ") "+delFP(FuncName) + "\r\n";
		}
	}
	if (JSTrim(lListProcFunc) == "") {
		echo("� ������ ��� �������� ��� �������");
	} else {
		ResultList(JSTrim(lListProcFunc),"������ ��������/�������");
	}
}


function getSectionsList(lStrings) {

	var re_meth = /^\s*(#�������)\s+/i;
	var lListProcFunc = "";

	for(var i=0; i<lStrings.length; i++)
	{
		lStrCurrent = "";
		lStr = lStrings[i];

		var matches = lStr.match(re_meth);
		if (matches != null)
		{
			j = i+1;
			lStrLong = JSTrim(delFP(lStr));
			lListProcFunc += "(" + j + ") "+delFP(lStrLong) + "\r\n";
		}
	}
	if (JSTrim(lListProcFunc) == "") {
		echo("� ������ ��� ��������");
	} else {
		ResultList(lListProcFunc,"������ ��������/�������");
	}
}

function ExtSearch(prmTxt)
{

	list = "";
	list += "^/?([^/]/?)*�����������������������������\r\n"
	list += "//+.*����������������������������\r\n";
	list += "//+.*TODO\r\n";
	list += "//+.*FIXME\r\n";
	list += "//+.*BUG\r\n";

	vRes =  SelectValue(list);
	
	if (!(vRes) == "")
	{
		var re = new RegExp(vRes,"ig");
	}
	else
	{
		return;
	}

    var i;
	var lStr = "";
	var lstrRes = "";

    for (i=0; i<prmTxt.length; i++)
    {
        if (prmTxt[i] != "")
        {
			lStr = prmTxt[i];
			var matches = lStr.match(re);
			if (matches != null)
			{
				
				if (i != 0)
				{
					j=i+1;
					
					lstrRes += "(" + j + ") "+ JSTrim(lStr).replace("|","") + "\r\n";
					// res.WriteLine(lstrRes);
					/*
					WScript.Sleep(5);
					WshShell.SendKeys("{HOME}");
					WScript.Sleep(50);
					WshShell.SendKeys("^(g)");
					WshShell.SendKeys("^(�)");
					//
					WScript.Sleep(20);
					WshShell.SendKeys(""+j);

					WScript.Sleep(5);
					WshShell.SendKeys("{HOME}");


					WScript.Sleep(10);
					WshShell.SendKeys("{ENTER}");
					WScript.Sleep(10);
					WshShell.SendKeys("%{F2}");
					WScript.Sleep(5);
					WshShell.SendKeys("{ESC}");
					*/
				}
			}
		}
    }
	wtiteToResultFile("tmp/search.txt",lstrRes);
	ResultList(lstrRes, "�������� ������");
}

function lastSearchResultShow() {
	fso = new ActiveXObject("Scripting.FileSystemObject");
	t_file = fso.OpenTextFile("tmp/search.txt", 1); 
	var str = t_file.ReadAll();
	t_file.Close();
	//fso = 0;
	return ResultList(str, "�������� ������");
}

function preroclist(arg){
	lstrRes = "&���������\r\n&���������\r\n\&���������������������";
	vRes = SelectValue(lstrRes);
	wtiteToResultFile("tmp/module.txt",vRes);
}

/*function showPrevSarchResult(prmTxt)
{
	var lstrRes = "";
    for (i=0; i<prmTxt.length; i++)
    {
        if (prmTxt[i] != "")
        {
			// lStr = prmTxt[i];
			lstrRes += prmTxt[i] + "\r\n";
		}
    }
	 // lstrRes = "sss\r\n sss\r\n";
	
	ResultList(lstrRes, "�������� ������");
}*/

function words(txt) {
	txt = txt.join('');
	txt1 = txt.replace(/(\s|>|<|\*|}|{|=|\||\"|\.|,|:|;|-|\+|\(|\)|\b|\r\n)/g, "\r\n");
	t1 = txt1.split('\r\n');
	result_str = "";
	for (var i = 0; i < t1.length; i++) {
		if (t1[i].length > 4)  {
			if (result_str.indexOf(t1[i]) == -1) 
			{
				result_str += "\r\n" + t1[i];	
			}
		} 
	}
	result_str += "\r\n";
	
	fso = new ActiveXObject("Scripting.FileSystemObject");
	t_file = fso.OpenTextFile("words.txt", 1); 
	result_str += t_file.ReadAll();
	t_file.Close();

	vRes = SelectValue(result_str,"�����");
	wtiteToResultFile("tmp/module.txt",JSTrim(vRes));
}

function methodBegin(lStrings) {
	
	var lListProcFunc = "";

	data = lStrings;

	data = lStrings.reverse();
	var re_meth = /^\s*(���������|�������|procedure|function)\s+/i;

	CntRows = data.length;
	rowBM = 1;
	for(var i=0; i < CntRows; i++)
	{
		lStr = data[i];
		var matches = lStr.match(re_meth);
		if (matches != null)
		{
			rowBM = CntRows-i;
			break;
		}
	}
	WScript.Quit(rowBM);
}

function actionGoToType(lStrings) {
	
	var lListProcFunc = "";

	data = lStrings;
	StrToChoice = '';
	UpCount = 0;

	data = lStrings.reverse();
	var re_meth = /(��������� ��)/i;

	CntRows = data.length;
	rowBM = 1;
	for(var i=0; i < CntRows; i++)
	{
		lStr = data[i];
		var matches = lStr.match(re_meth);
		if (matches != null)
		{
			break;
		}
		if (JSTrim(lStr) != "") {
			UpCount++;
			StrToChoice +=  "("+UpCount+") "+ lStr + "\r\n";
		}
	}
	if (UpCount == 1) {
		WScript.Quit(1);
	} else if (UpCount == 0) {
		WScript.Quit(0);
	} else {
		vRes = ResultList(StrToChoice,"");
	}
	//wtiteToResultFile("tmp/module.txt",JSTrim(vRes));
}

function actionGoToObject(lStrings) {
	
	var lListProcFunc = "";

	data = lStrings;
	StrToChoice = '';
	UpCount = 0;

	CntRows = data.length;
	for(var i=1; i < CntRows-1; i++)
	{
		var str = data[i];
		StrToChoice +=  str + "\r\n";
		UpCount++;
	}
	if (StrToChoice != "") {
		var resultStr = SelectValue(StrToChoice);
		wtiteToResultFile("tmp/module.txt",JSTrim(resultStr));
	} else {
		wtiteToResultFile("tmp/module.txt","");
		echo("������ ������");
	}
}


function Run()
{
    arg=WScript.Arguments;

    fso = new ActiveXObject("Scripting.FileSystemObject");
	if (arg(0) != 'null') {
		File = fso.GetFile(arg(0));
		if (File.Size > 0) {
			f=fso.OpenTextFile(arg(0),1);
			var lTxt = f.ReadAll();
			var lList = lTxt.split('\r').join('').split('\n');
			f.close();
		} else {
			var lList = [];
		}
		
	} 
	switch (arg(1)) {
		case "search":
			ExtSearch(lList);
			break;
		case "search-last":
			lastSearchResultShow();
			break;
		case "proclist":
			GetMethList(lList);
			break;
		case "preprocmenu":
			preroclist();
			break;
		case "words":
			words(lList);
			break;
		case "BeginMethod":
			methodBegin(lList);
			break;
		case "EndMethod":
			methodBegin(lList);
			break;
		case "sectionslist":
			getSectionsList(lList);
			break;
		case "gototype":
			actionGoToType(lList);
			break;
		case "gotoobject":
			actionGoToObject(lList);
			break;
		default:
			return; // �� ������ ���� � ��������
	}

}

Run();