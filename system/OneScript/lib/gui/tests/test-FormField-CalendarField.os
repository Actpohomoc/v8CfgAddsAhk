#Использовать asserts
#Использовать gui

Перем ВидыПоляФормы;
Перем Форма;
Перем ТекстПроверки;
Перем УправляемыйИнтерфейс;

Функция ПолучитьСписокТестов(Тестирование) Экспорт

	СписокТестов = Новый Массив;
	СписокТестов.Добавить("Тест_Должен_СоздатьПоле");
	СписокТестов.Добавить("Тест_Должен_ПровестиРаботуСоЗначением");
	СписокТестов.Добавить("Тест_Должен_УстановитьИПроверитьДействиеПриИзмении");
	СписокТестов.Добавить("Тест_Должен_ПолучитьДействие");
	
	Возврат СписокТестов;

КонецФункции

//# Работа с событиями
Процедура ПриОткрытииФормы() Экспорт
	Форма.Закрыть();
КонецПроцедуры

Функция ПолучитьФорму()

	УправляемыйИнтерфейс = Новый УправляемыйИнтерфейс();
	Форма = УправляемыйИнтерфейс.СоздатьФорму();
	Форма.УстановитьДействие(ЭтотОбъект, "ПриОткрытии", "ПриОткрытииФормы");
	ВидыПоляФормы = Форма.ВидПоляФормы;

КонецФункции


Процедура Тест_Должен_СоздатьПоле() Экспорт

	ПолучитьФорму();

	Поле1 = Форма.Элементы.Добавить("Поле1", "ПолеФормы", Неопределено);
	Поле1.Вид = ВидыПоляФормы.ПолеКалендаря;

	Ожидаем.Что(Форма.Элементы.Найти("Поле1")).Существует();

	Форма.Показать();

КонецПроцедуры

Процедура Тест_Должен_ПровестиРаботуСоЗначением() Экспорт

	ПолучитьФорму();
	
	
	ТекДата = Дата(2016,05,02);

	Поле1 = Форма.Элементы.Добавить("Поле1", "ПолеФормы", Неопределено);
	Поле1.Вид = ВидыПоляФормы.ПолеКалендаря;
	Поле1.Значение = ТекДата;

	Форма.Показать();

	Ожидаем.Что(Форма.Элементы.Найти("Поле1").Значение).Равно(ТекДата);

КонецПроцедуры

//# Работа с событиями
Процедура ПриИзменииЗначения() Экспорт
	ТекстПроверки = "Новое значение: ";
КонецПроцедуры

Процедура Тест_Должен_УстановитьИПроверитьДействиеПриИзмении() Экспорт
	ПолучитьФорму();
	
	ТекДата = Дата(2016,05,02);

	ТекстПроверки = "Событие не отработало: ПриИзменииЗначения: ";
	Поле1 = Форма.Элементы.Добавить("Поле1", "ПолеФормы", Неопределено);
	Поле1.Вид = ВидыПоляФормы.ПолеКалендаря;
	Поле1.УстановитьДействие(ЭтотОбъект, "ПриИзменении", "ПриИзменииЗначения");
	Поле1.Значение = ТекДата;
	Форма.Показать();

	Ожидаем.Что(ТекстПроверки + Форма.Элементы.Найти("Поле1").Значение).Равно("Новое значение: " + ТекДата);

КонецПроцедуры

Процедура Тест_Должен_ПолучитьДействие() Экспорт
	ПолучитьФорму();

	Поле1 = Форма.Элементы.Добавить("Поле1", "ПолеФормы", Неопределено);
	Поле1.Вид = ВидыПоляФормы.ПолеКалендаря;
	Поле1.УстановитьДействие(ЭтотОбъект, "ПриИзменении", "ПриИзменииЗначения");

	Ожидаем.Что(Форма.Элементы.Найти("Поле1").ПолучитьДействие("ПриИзменении")).ЭтоНе().Равно("");

	Форма.Показать();

КонецПроцедуры
