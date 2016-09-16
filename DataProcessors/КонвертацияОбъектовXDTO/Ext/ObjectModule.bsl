﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбъявлениеПеременных

Перем ПолеОбработкаДляЗагрузкиДанных;

#КонецОбласти

#Область ПрограммныйИнтерфейс

#Область ЭкспортныеСвойства

// Функция-свойство: результат выполнения обмена данными.
//
// Тип: ПеречислениеСсылка.РезультатыВыполненияОбмена
//
Функция РезультатВыполненияОбмена() Экспорт
	
	Если КомпонентыОбмена = Неопределено Тогда
		Возврат Перечисления.РезультатыВыполненияОбмена.Отменено;
	КонецЕсли;
	
	РезультатВыполненияОбмена = КомпонентыОбмена.СостояниеОбменаДанными.РезультатВыполненияОбмена;
	Если РезультатВыполненияОбмена = Неопределено Тогда
		Возврат Перечисления.РезультатыВыполненияОбмена.Выполнено;
	КонецЕсли;
	
	Возврат РезультатВыполненияОбмена;
	
КонецФункции

// Функция-свойство: результат выполнения обмена данными.
//
// Тип: Строка
//
Функция РезультатВыполненияОбменаСтрокой() Экспорт
	
	Возврат ОбщегоНазначения.ИмяЗначенияПеречисления(РезультатВыполненияОбмена());
	
КонецФункции


// Функция-свойство: количество объектов, которые были загружены.
//
// Тип: Число
//
Функция СчетчикЗагруженныхОбъектов() Экспорт
	
	Если КомпонентыОбмена = Неопределено Тогда
		Возврат 0;
	КонецЕсли;
	
	Возврат КомпонентыОбмена.СчетчикЗагруженныхОбъектов;
	
КонецФункции

// Функция-свойство: количество объектов, которые были выгружены.
//
// Тип: Число
//
Функция СчетчикВыгруженныхОбъектов() Экспорт
	
	Если КомпонентыОбмена = Неопределено Тогда
		Возврат 0;
	КонецЕсли;
	
	Возврат КомпонентыОбмена.СчетчикВыгруженныхОбъектов;
	
КонецФункции

// Функция-свойство: строка, которая содержит сообщение об ошибке при обмене данными.
//
// Тип: Строка
//
Функция СтрокаСообщенияОбОшибке() Экспорт
	
	Возврат КомпонентыОбмена.СтрокаСообщенияОбОшибке;
	
КонецФункции

// Функция-свойство: флаг ошибки выполнения обмена данными.
//
// Тип: Булево
//
Функция ФлагОшибки() Экспорт
	
	Возврат КомпонентыОбмена.ФлагОшибки;
	
КонецФункции

// Функция-свойство: номер сообщения обмена данными.
//
// Тип: Число
//
Функция НомерСообщения() Экспорт
	
	Возврат КомпонентыОбмена.НомерВходящегоСообщения;
	
КонецФункции

// Функция-свойство: таблица значений со статистической и дополнительной информацией о входящем сообщении обмена.
//
// Тип: ТаблицаЗначений
//
Функция ТаблицаДанныхЗаголовкаПакета() Экспорт
	
	Если КомпонентыОбмена = Неопределено Тогда
		Возврат ОбменДаннымиXDTOСервер.НоваяТаблицаДанныхЗаголовкаПакета();
	Иначе
		Возврат КомпонентыОбмена.ТаблицаДанныхЗаголовкаПакета;
	КонецЕсли;
	
КонецФункции

// Функция-свойство: соответствие с таблицами данных входящего сообщения обмена.
//
// Тип: Соответствие
//
Функция ТаблицыДанныхСообщенияОбмена() Экспорт
	
	Если КомпонентыОбмена = Неопределено Тогда
		Возврат Новый Соответствие;
	Иначе
		Возврат КомпонентыОбмена.ТаблицыДанныхСообщенияОбмена;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ВыгрузкаДанных

// Выполняет выгрузку данных
// -- Все объекты выгружаются в один файл.
//
// Параметры:
// 
Процедура ВыполнитьВыгрузкуДанных(ОбработкаДляЗагрузкиДанных = Неопределено) Экспорт
	
	ПолеОбработкаДляЗагрузкиДанных = ОбработкаДляЗагрузкиДанных;
	
	КомпонентыОбмена = ОбменДаннымиXDTOСервер.ИнициализироватьКомпонентыОбмена("Отправка");
	
	КомпонентыОбмена.ВедениеПротоколаДанных.ВыводВПротоколИнформационныхСообщений = ВыводВПротоколИнформационныхСообщений;
	КомпонентыОбмена.КлючСообщенияЖурналаРегистрации = КлючСообщенияЖурналаРегистрации;
	
	#Область НастройкаКомпонентовОбменаНаРаботуСУзлом
	КомпонентыОбмена.УзелКорреспондента = УзелДляОбмена;
	
	КомпонентыОбмена.ВерсияФорматаОбмена = ОбменДаннымиXDTOСервер.ВерсияФорматаОбменаПриВыгрузке(УзелДляОбмена);
	
	ФорматОбмена = ОбменДаннымиXDTOСервер.ФорматОбмена(
		УзелДляОбмена, КомпонентыОбмена.ВерсияФорматаОбмена);
	КомпонентыОбмена.XMLСхема = ФорматОбмена;
	
	КомпонентыОбмена.МенеджерОбмена = ОбменДаннымиXDTOСервер.МенеджерОбменаВерсииФормата(
		УзелДляОбмена, КомпонентыОбмена.ВерсияФорматаОбмена);
	
	КомпонентыОбмена.ТаблицаПравилаРегистрацииОбъектов = ОбменДаннымиXDTOСервер.ПравилаРегистрацииОбъектов(УзелДляОбмена);
	КомпонентыОбмена.СвойстваУзлаПланаОбмена = ОбменДаннымиXDTOСервер.СвойстваУзлаПланаОбмена(УзелДляОбмена);
	
	ОбменДаннымиXDTOСервер.ИнициализироватьТаблицыПравилОбмена(КомпонентыОбмена);
	#КонецОбласти
	
	ОбменДаннымиXDTOСервер.ИнициализироватьВедениеПротоколаОбмена(КомпонентыОбмена, ИмяФайлаПротоколаОбмена);
	
	// Открываем файл обмена
	ОбменДаннымиXDTOСервер.ОткрытьФайлВыгрузки(КомпонентыОбмена, ИмяФайлаОбмена);
	
	Если КомпонентыОбмена.ФлагОшибки Тогда
		КомпонентыОбмена.ФайлОбмена = Неопределено;
		ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
		Возврат;
	КонецЕсли;
	
	// ВЫГРУЗКА ДАННЫХ
	Попытка
		ОбменДаннымиXDTOСервер.ПроизвестиВыгрузкуДанных(КомпонентыОбмена);
	Исключение
		Если КомпонентыОбмена.ЭтоОбменЧерезПланОбмена Тогда
			РазблокироватьДанныеДляРедактирования(УзелДляОбмена);
		КонецЕсли;
		ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
		КомпонентыОбмена.ФайлОбмена = Неопределено;
		Возврат;
	КонецПопытки;
	
	Если ЭтоОбменЧерезВнешнееСоединение() Тогда
		ДанныеВыгрузкиXML = КомпонентыОбмена.ФайлОбмена.Закрыть();
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.ДобавитьСтроку(ДанныеВыгрузкиXML);
		ТекстовыйДокумент.Записать(ИмяВременногоФайла,,Символы.ПС);
	Иначе
		КомпонентыОбмена.ФайлОбмена.Закрыть();
	КонецЕсли;
	ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
	
	Если ЭтоОбменЧерезВнешнееСоединение() Тогда
		ОбработкаДляЗагрузкиДанных().ИмяФайлаОбмена = ИмяВременногоФайла;
		ОбработкаДляЗагрузкиДанных().ВыполнитьЗагрузкуДанных();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ЗагрузкаДанных

// Выполняет загрузку данных из файла сообщения обмена.
// Данные загружаются в информационную базу.
//
// Параметры:
// 
Процедура ВыполнитьЗагрузкуДанных() Экспорт
	
	КомпонентыОбмена = ОбменДаннымиXDTOСервер.ИнициализироватьКомпонентыОбмена("Получение");
	КомпонентыОбмена.КлючСообщенияЖурналаРегистрации = КлючСообщенияЖурналаРегистрации;
	КомпонентыОбмена.УзелКорреспондента = УзелОбменаЗагрузкаДанных;
	
	КомпонентыОбмена.ВедениеПротоколаДанных.ВыводВПротоколИнформационныхСообщений = ВыводВПротоколИнформационныхСообщений;
	РежимЗагрузкиДанных = "ЗагрузкаВИнформационнуюБазу";
	
	КомпонентыОбмена.СостояниеОбменаДанными.ДатаНачала = ТекущаяДатаСеанса();
	
	ОбменДаннымиXDTOСервер.ИнициализироватьВедениеПротоколаОбмена(КомпонентыОбмена, ИмяФайлаПротоколаОбмена);
	
	Если ПустаяСтрока(ИмяФайлаОбмена) Тогда
		ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, 15);
		ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
		Возврат;
	КонецЕсли;
	
	Если ПродолжитьПриОшибке Тогда
		ИспользоватьТранзакции = Ложь;
		КомпонентыОбмена.ИспользоватьТранзакции = Ложь;
	КонецЕсли;
	
	ОбменДаннымиXDTOСервер.ОткрытьФайлЗагрузки(КомпонентыОбмена, ИмяФайлаОбмена);
	
	Если КомпонентыОбмена.ФлагОшибки Тогда
		ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
		Если КомпонентыОбмена.Свойство("ФайлОбмена") Тогда
			КомпонентыОбмена.ФайлОбмена.Закрыть();
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	РезультатПодсчетаДанныхКЗагрузке = ОбменДаннымиСервер.РезультатПодсчетаДанныхКЗагрузке(ИмяФайлаОбмена, Истина);
	КомпонентыОбмена.Вставить("РазмерФайлаСообщенияОбмена", РезультатПодсчетаДанныхКЗагрузке.РазмерФайлаСообщенияОбмена);
	КомпонентыОбмена.Вставить("КоличествоОбъектовКЗагрузке", РезультатПодсчетаДанныхКЗагрузке.КоличествоОбъектовКЗагрузке);
	
	ОбменДаннымиXDTOСервер.ИнициализироватьТаблицыПравилОбмена(КомпонентыОбмена);
	
	Попытка
		ОбменДаннымиXDTOСервер.ПроизвестиЧтениеДанных(КомпонентыОбмена);
	Исключение
		
		СтрокаСообщения = НСтр("ru = 'Ошибка при загрузке данных: %1'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ОписаниеОшибки());
		ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, СтрокаСообщения,,,,,Истина);
		КомпонентыОбмена.ФлагОшибки = Истина;
	КонецПопытки;
	
	ОбменДаннымиXDTOСервер.УдалитьВременныеОбъектыСозданныеПоСсылкам(КомпонентыОбмена);
	
	КомпонентыОбмена.ФайлОбмена.Закрыть();
	
	Если Не КомпонентыОбмена.ФлагОшибки Тогда
		
		// Запишем информацию о номере входящего сообщения.
		ОбъектУзла = УзелОбменаЗагрузкаДанных.ПолучитьОбъект();
		ОбъектУзла.НомерПринятого = КомпонентыОбмена.НомерВходящегоСообщения;
		ОбъектУзла.ДополнительныеСвойства.Вставить("ПолучениеСообщенияОбмена");
		ОбъектУзла.Записать();
		
	КонецЕсли;
	
	ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
	
КонецПроцедуры

// Выполняет загрузку данных из файла сообщения обмена в Информационную Базу только заданных типов объектов.
//
// Параметры:
//  ТаблицыДляЗагрузки - Массив - массив типов, которые необходимо загрузить из сообщения обмена; элемент массива -
//                                Строка.
//  Например, для загрузки из сообщения обмена только элементов справочника Контрагенты:
//   ТаблицыДляЗагрузки = Новый Массив;
//   ТаблицыДляЗагрузки.Добавить("СправочникСсылка.Контрагенты");
// 
//  Список всех типов, которые содержаться в текущем сообщении обмена
//  можно получить вызовом процедуры ВыполнитьАнализСообщенияОбмена().
// 
Процедура ВыполнитьЗагрузкуДанныхВИнформационнуюБазу(ТаблицыДляЗагрузки) Экспорт
	
	КомпонентыОбмена = ОбменДаннымиXDTOСервер.ИнициализироватьКомпонентыОбмена("Получение");
	КомпонентыОбмена.КлючСообщенияЖурналаРегистрации = КлючСообщенияЖурналаРегистрации;
	КомпонентыОбмена.ВедениеПротоколаДанных.ВыводВПротоколИнформационныхСообщений = ВыводВПротоколИнформационныхСообщений;
	КомпонентыОбмена.УзелКорреспондента = УзелОбменаЗагрузкаДанных;
	
	РежимЗагрузкиДанных = "ЗагрузкаВИнформационнуюБазу";
	
	КомпонентыОбмена.СостояниеОбменаДанными.ДатаНачала = ТекущаяДатаСеанса();
	
	ОбменДаннымиXDTOСервер.ОткрытьФайлЗагрузки(КомпонентыОбмена, ИмяФайлаОбмена);
	
	Если КомпонентыОбмена.ФлагОшибки Тогда
		ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
		КомпонентыОбмена.ФайлОбмена.Закрыть();
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиXDTOСервер.ИнициализироватьТаблицыПравилОбмена(КомпонентыОбмена);
	
	// Запись в журнале регистрации.
	СтрокаСообщения = НСтр("ru = 'Начало процесса обмена данными для узла: %1'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, Строка(УзелОбменаЗагрузкаДанных));
	ОбменДаннымиXDTOСервер.ЗаписьЖурналаРегистрацииОбменДанными(СтрокаСообщения, КомпонентыОбмена, УровеньЖурналаРегистрации.Информация);
	
	ОбменДаннымиXDTOСервер.ПроизвестиЧтениеДанных(КомпонентыОбмена, ТаблицыДляЗагрузки);
	ОбменДаннымиXDTOСервер.УдалитьВременныеОбъектыСозданныеПоСсылкам(КомпонентыОбмена);
	
	// Запись в журнале регистрации.
	СтрокаСообщения = НСтр("ru = '%1, %2; Обработано %3 объектов'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения,
					КомпонентыОбмена.СостояниеОбменаДанными.РезультатВыполненияОбмена,
					Перечисления.ДействияПриОбмене.ЗагрузкаДанных,
					Формат(КомпонентыОбмена.СчетчикЗагруженныхОбъектов, "ЧГ=0"));
	
	ОбменДаннымиXDTOСервер.ЗаписьЖурналаРегистрацииОбменДанными(СтрокаСообщения, КомпонентыОбмена, УровеньЖурналаРегистрации.Информация);
	КомпонентыОбмена.ФайлОбмена.Закрыть();
	
КонецПроцедуры

// Выполняет последовательное чтение файла сообщения обмена при этом:
//  - удаляется регистрация изменений по номеру входящей квитанции
//  - загружаются правила обмена
//  - загружается информация о типах данных
//  - зачитывается информация сопоставления данных и записывается и ИБ
//  - собирается информация о типах объектов и их количестве.
//
// Параметры:
//  Нет.
// 
Процедура ВыполнитьАнализСообщенияОбмена(ПараметрыАнализа = Неопределено) Экспорт
	
	РежимЗагрузкиДанных = "ЗагрузкаВТаблицуЗначений";
	ИспользоватьТранзакции = Ложь;
	
	КомпонентыОбмена = ОбменДаннымиXDTOСервер.ИнициализироватьКомпонентыОбмена("Получение");
	КомпонентыОбмена.ВедениеПротоколаДанных.ВыводВПротоколИнформационныхСообщений = ВыводВПротоколИнформационныхСообщений;
	КомпонентыОбмена.КлючСообщенияЖурналаРегистрации = КлючСообщенияЖурналаРегистрации;
	КомпонентыОбмена.УзелКорреспондента = УзелОбменаЗагрузкаДанных;
	КомпонентыОбмена.РежимЗагрузкиДанныхВИнформационнуюБазу = Ложь;
	
	ОбменДаннымиXDTOСервер.ИнициализироватьВедениеПротоколаОбмена(КомпонентыОбмена, ИмяФайлаПротоколаОбмена);
	
	Если ПустаяСтрока(ИмяФайлаОбмена) Тогда
		ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, 15);
		ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
		Возврат;
	КонецЕсли;
	
	// дата начала анализа
	КомпонентыОбмена.СостояниеОбменаДанными.ДатаНачала = ТекущаяДатаСеанса();
	
	ОбменДаннымиXDTOСервер.ОткрытьФайлЗагрузки(КомпонентыОбмена, ИмяФайлаОбмена);
	
	Если КомпонентыОбмена.ФлагОшибки Тогда
		ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
		КомпонентыОбмена.ФайлОбмена.Закрыть();
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиXDTOСервер.ИнициализироватьТаблицыПравилОбмена(КомпонентыОбмена);
	
	Попытка
		
		// Зачитываем данные из сообщения обмена.
		ОбменДаннымиXDTOСервер.ПроизвестиЧтениеДанныхВРежимеАнализа(КомпонентыОбмена, ПараметрыАнализа);
		
		// Формируем временную таблицу данных.
		ТаблицаДанныхЗаголовкаПакетаВременная = КомпонентыОбмена.ТаблицаДанныхЗаголовкаПакета.Скопировать(, "ТипИсточникаСтрокой, ТипПриемникаСтрокой, ПоляПоиска, ПоляТаблицы");
		ТаблицаДанныхЗаголовкаПакетаВременная.Свернуть("ТипИсточникаСтрокой, ТипПриемникаСтрокой, ПоляПоиска, ПоляТаблицы");
		
		// Сворачиваем таблицу данных заголовка пакета.
		КомпонентыОбмена.ТаблицаДанныхЗаголовкаПакета.Свернуть(
			"ТипОбъектаСтрокой, ТипИсточникаСтрокой, ТипПриемникаСтрокой, СинхронизироватьПоИдентификатору, ЭтоКлассификатор, ЭтоУдалениеОбъекта, ИспользоватьПредварительныйПросмотр",
			"КоличествоОбъектовВИсточнике");
		
		КомпонентыОбмена.ТаблицаДанныхЗаголовкаПакета.Колонки.Добавить("ПоляПоиска",  Новый ОписаниеТипов("Строка"));
		КомпонентыОбмена.ТаблицаДанныхЗаголовкаПакета.Колонки.Добавить("ПоляТаблицы", Новый ОписаниеТипов("Строка"));
		
		Для Каждого СтрокаТаблицы Из КомпонентыОбмена.ТаблицаДанныхЗаголовкаПакета Цикл
			
			Отбор = Новый Структура;
			Отбор.Вставить("ТипИсточникаСтрокой", СтрокаТаблицы.ТипИсточникаСтрокой);
			Отбор.Вставить("ТипПриемникаСтрокой", СтрокаТаблицы.ТипПриемникаСтрокой);
			
			СтрокиВременнойТаблицы = ТаблицаДанныхЗаголовкаПакетаВременная.НайтиСтроки(Отбор);
			
			СтрокаТаблицы.ПоляПоиска  = СтрокиВременнойТаблицы[0].ПоляПоиска;
			СтрокаТаблицы.ПоляТаблицы = СтрокиВременнойТаблицы[0].ПоляТаблицы;
			
		КонецЦикла;
		
	Исключение
		СтрокаСообщения = НСтр("ru = 'Ошибка при анализе данных: %1'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ОписаниеОшибки());
		ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, СтрокаСообщения,,,,,Истина);
	КонецПопытки;
	
	КомпонентыОбмена.ФайлОбмена.Закрыть();
	
	ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
	
КонецПроцедуры

// Выполняет загрузку данных из файла сообщения обмена в Таблицу значений только заданных типов объектов.
//
// Параметры:
//  ТаблицыДляЗагрузки - Массив - массив типов, которые необходимо загрузить из сообщения обмена; элемент массива -
//                                Строка.
//  Например, для загрузки из сообщения обмена только элементов справочника Контрагенты:
//   ТаблицыДляЗагрузки = Новый Массив;
//   ТаблицыДляЗагрузки.Добавить("СправочникСсылка.Контрагенты");
// 
//  Список всех типов, которые содержаться в текущем сообщении обмена
//  можно получить вызовом процедуры ВыполнитьАнализСообщенияОбмена().
// 
Процедура ВыполнитьЗагрузкуДанныхВТаблицуЗначений(ТаблицыДляЗагрузки) Экспорт
	
	РежимЗагрузкиДанных = "ЗагрузкаВТаблицуЗначений";
	ИспользоватьТранзакции = Ложь;
	
	Если КомпонентыОбмена = Неопределено Тогда
		
		КомпонентыОбмена = ОбменДаннымиXDTOСервер.ИнициализироватьКомпонентыОбмена("Получение");
		КомпонентыОбмена.КлючСообщенияЖурналаРегистрации = КлючСообщенияЖурналаРегистрации;
		КомпонентыОбмена.ВедениеПротоколаДанных.ВыводВПротоколИнформационныхСообщений = ВыводВПротоколИнформационныхСообщений;
		КомпонентыОбмена.УзелКорреспондента = УзелОбменаЗагрузкаДанных;
	
		ОбменДаннымиXDTOСервер.ОткрытьФайлЗагрузки(КомпонентыОбмена, ИмяФайлаОбмена);
	
		Если КомпонентыОбмена.ФлагОшибки Тогда
			ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
			КомпонентыОбмена.ФайлОбмена.Закрыть();
			Возврат;
		КонецЕсли;
		
		ОбменДаннымиXDTOСервер.ИнициализироватьТаблицыПравилОбмена(КомпонентыОбмена);
	Иначе
		ОбменДаннымиXDTOСервер.ОткрытьФайлЗагрузки(КомпонентыОбмена, ИмяФайлаОбмена);
	КонецЕсли;
	
	КомпонентыОбмена.СостояниеОбменаДанными.ДатаНачала = ТекущаяДатаСеанса();
	КомпонентыОбмена.РежимЗагрузкиДанныхВИнформационнуюБазу = Ложь;
	
	// Инициализируем таблицы данных сообщения обмена.
	Для Каждого КлючТаблицыДанных Из ТаблицыДляЗагрузки Цикл
		
		МассивПодстрок = СтрРазделить(КлючТаблицыДанных, "#");
		
		ТипОбъекта = МассивПодстрок[1];
		
		КомпонентыОбмена.ТаблицыДанныхСообщенияОбмена.Вставить(КлючТаблицыДанных, ИнициализацияТаблицыДанныхСообщенияОбмена(Тип(ТипОбъекта)));
		
	КонецЦикла;
	
	ОбменДаннымиXDTOСервер.ПроизвестиЧтениеДанных(КомпонентыОбмена, ТаблицыДляЗагрузки);
	КомпонентыОбмена.ФайлОбмена.Закрыть();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область Прочее

Функция ИнициализацияТаблицыДанныхСообщенияОбмена(ТипОбъекта)
	
	ТаблицаДанныхСообщенияОбмена = Новый ТаблицаЗначений;
	
	Колонки = ТаблицаДанныхСообщенияОбмена.Колонки;
	
	// обязательные поля
	Колонки.Добавить("УникальныйИдентификатор", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(36)));
	Колонки.Добавить("ТипСтрокой",              Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(255)));
	
	ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипОбъекта);
	
	// Получаем описание всех полей объекта метаданного из конфигурации.
	ТаблицаОписанияСвойствОбъекта = ОбщегоНазначения.ПолучитьТаблицуОписанияСвойствОбъекта(ОбъектМетаданных, "Имя, Тип");
	
	Для Каждого ОписаниеСвойства Из ТаблицаОписанияСвойствОбъекта Цикл
		
		Колонки.Добавить(ОписаниеСвойства.Имя, ОписаниеСвойства.Тип);
		
	КонецЦикла;
	
	Возврат ТаблицаДанныхСообщенияОбмена;
	
КонецФункции

Функция ОбработкаДляЗагрузкиДанных()
	
	Возврат ПолеОбработкаДляЗагрузкиДанных;
	
КонецФункции

Функция ЭтоОбменЧерезВнешнееСоединение()
	
	Возврат ОбработкаДляЗагрузкиДанных() <> Неопределено;
	
КонецФункции

#КонецОбласти

#Область ОператорыОсновнойПрограммы

Параметры = Новый Структура;

#КонецОбласти

#КонецЕсли