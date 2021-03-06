Перем Обмен;

Процедура ОбработкаТекста(Данные,Приемник)
	
	ДанныеВыбора = ""
		+ "Если" + Символы.ПС + Символы.ВК  
		+ "Пока" + Символы.ПС + Символы.ВК 
		+ "Для" + Символы.ПС + Символы.ВК 
		+ "Для каждого" + Символы.ПС + Символы.ВК 
		+ "Область" + Символы.ПС + Символы.ВК 
		+ "Попытка";

	Стр = Обмен.ВыбратьИзСписка(ДанныеВыбора);
	Если (Стр = "") Тогда
		возврат;
	ИначеЕсли (Стр = "Если") Тогда
		Данные = "Если Тогда" + Символы.ВК + Данные + Символы.ВК + "КонецЕсли;";
	ИначеЕсли (Стр = "Пока") Тогда
		Данные = "Пока Цикл" + Символы.ВК + Данные + Символы.ВК + "КонецЦикла;";
	ИначеЕсли (Стр = "Для") Тогда
		Данные = "Для По Цикл" + Символы.ВК + Данные + Символы.ВК + "КонецЦикла;";
	ИначеЕсли (Стр = "Для каждого") Тогда
		Данные = "Для каждого Стр из Коллекция Цикл" + Символы.ВК + Данные + Символы.ВК + "КонецЦикла;";
	ИначеЕсли (Стр = "Попытка") Тогда
		Данные = "Попытка" + Символы.ВК + Данные + Символы.ВК + "Исключение" +  Символы.ВК + "КонецПопытки;";
	ИначеЕсли (Стр = "Область") Тогда
		ИмяОбласти = Обмен.ВвестиЗначение("");
		Если СокрЛП(ИмяОбласти) <> "" Тогда
			Данные = "#Область " + ИмяОбласти + Символы.ВК + Данные + Символы.ВК + "#КонецОбласти";
		КонецЕсли
	КонецЕсли;	
	Данные = Данные  + Символы.ПС + Символы.ВК;
	Обмен.ЗаписатьРезультатВФайл(Приемник,Данные);

КонецПроцедуры

Процедура Выполнить(Параметры)
	
	ИмяФайла = "tmp\module.txt";
	Если Параметры.Количество() > 0 Тогда
		ИмяФайла = Параметры[0];
	КонецЕсли;
	Приемник = ИмяФайла;

	Если Параметры.Количество() > 1 Тогда
		Приемник = Параметры[1];
	КонецЕсли;

	ОбработкаТекста(Обмен.ПолучитьТекстИзФайла(ИмяФайла),Приемник);

КонецПроцедуры

//Обмен = ЗагрузитьСценарий(ТекущийКаталог()+"\scripts\Обмен.os");
Обмен = ЗагрузитьСценарий("scripts\Обмен.os");

Выполнить(АргументыКоманднойСтроки);

//МассивПарамеров = новый Массив;
//МассивПарамеров.Добавить("c:\work\portable\v8CfgAddsAhk\tmp\module.txt");
//МассивПарамеров.Добавить("c:\work\portable\v8CfgAddsAhk\tmp\new.module.txt");

//Выполнить(МассивПарамеров);