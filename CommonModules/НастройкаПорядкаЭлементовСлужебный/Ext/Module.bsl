﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Настройка порядка элементов".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс


// Для внутреннего использования
//
Функция СоседнийЭлемент(ПеремещаемыйЭлемент, Список, Знач Направление) Экспорт
	
	// Подготовка текста запроса к основной таблице списка.
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	*
	|ИЗ
	|	&Таблица КАК Таблица
	|ГДЕ
	|	Таблица.РеквизитДопУпорядочивания > &РеквизитДопУпорядочивания
	|УПОРЯДОЧИТЬ ПО
	|	Таблица.РеквизитДопУпорядочивания";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Таблица", Список.ОсновнаяТаблица);
	
	Если Направление = "Вверх" Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ">", "<");
		ТекстЗапроса = ТекстЗапроса + " УБЫВ";
	КонецЕсли;
	
	Информация = НастройкаПорядкаЭлементов.ПолучитьИнформациюДляПеремещения(ПеремещаемыйЭлемент.Метаданные());
	
	ПостроительЗапроса = Новый ПостроительЗапроса(ТекстЗапроса);
	ПостроительЗапроса.ЗаполнитьНастройки();
	Если Информация.ЕстьРодитель Тогда
		ДобавитьПростойОтборВПостроительЗапроса(ПостроительЗапроса, "Родитель", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПеремещаемыйЭлемент, "Родитель"));
	КонецЕсли;
	
	Если Информация.ЕстьВладелец Тогда
		ДобавитьПростойОтборВПостроительЗапроса(ПостроительЗапроса, "Владелец", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПеремещаемыйЭлемент, "Владелец"));
	КонецЕсли;
	
	Если Информация.ЕстьГруппы Тогда
		Если Информация.ДляГрупп И Не Информация.ДляЭлементов Тогда
			ДобавитьПростойОтборВПостроительЗапроса(ПостроительЗапроса, "ЭтоГруппа", Истина);
		ИначеЕсли Не Информация.ДляГрупп И Информация.ДляЭлементов Тогда
			ДобавитьПростойОтборВПостроительЗапроса(ПостроительЗапроса, "ЭтоГруппа", Ложь);
		КонецЕсли;
	КонецЕсли;
	
	ПостроительЗапроса.Параметры.Вставить("РеквизитДопУпорядочивания", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПеремещаемыйЭлемент, "РеквизитДопУпорядочивания"));
	
	Запрос = ПостроительЗапроса.ПолучитьЗапрос();
	
	// Подготовка схемы компоновки данных, аналогичной списку.
	
	СхемаКомпоновкиДанных = СхемаКомпоновкиДанных(Запрос.Текст);
	
	КомпоновщикНастроекКомпоновкиДанных = Новый КомпоновщикНастроекКомпоновкиДанных;
	АдресСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных);
	КомпоновщикНастроекКомпоновкиДанных.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы));
	КомпоновщикНастроекКомпоновкиДанных.ЗагрузитьНастройки(Список.КомпоновщикНастроек.ПолучитьНастройки());
	КомпоновщикНастроекКомпоновкиДанных.Настройки.УсловноеОформление.Элементы.Очистить();

	УстановитьНастройкуСтруктурыВыводаРезультата(КомпоновщикНастроекКомпоновкиДанных.Настройки);
	
	Для Каждого Параметр Из Запрос.Параметры Цикл
		КомпоновщикНастроекКомпоновкиДанных.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра(
			Параметр.Ключ, Параметр.Значение);
	КонецЦикла;
	
	// Проверка доступности полей в отборе
	Если Не ПоляОтбораВСпискеДоступных(КомпоновщикНастроекКомпоновкиДанных.ПолучитьНастройки().Отбор.Элементы, КомпоновщикНастроекКомпоновкиДанных.ПолучитьНастройки().Отбор.ДоступныеПоляОтбора.Элементы) Тогда
		ВызватьИсключение НСтр("ru = 'Для перемещения элемента необходимо отключить все отборы в списке.'");
	КонецЕсли;
	
	// Вывод результата запроса
	
	РезультатКомпоновки = Новый ТаблицаЗначений;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,
		КомпоновщикНастроекКомпоновкиДанных.Настройки, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
		
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(РезультатКомпоновки);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	СоседнийЭлемент = Неопределено;
	Если РезультатКомпоновки.Количество() > 0 Тогда
		СоседнийЭлемент = РезультатКомпоновки[0].Ссылка;
	КонецЕсли;
	
	Возврат СоседнийЭлемент;
	
КонецФункции

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// Выполняет перемещение элемента вверх или вниз по списку.
//
// Параметры:
//  Ссылка              - Ссылка - ссылка на перемещаемый элемент;
//  Список              - ДинамическийСписок - список, в котором требуется переместить элемент;
//  ОтображениеСписком  - Булево - Истина, если у элемента формы, связанного со списком, включен режим отображения
//                                 "Список";
//  Направление         - Строка - направление перемещения элемента: "Вверх" или "Вниз" по списку.
//
// Возвращаемое значение:
//  Строка - описание ошибки.
Функция ИзменитьПорядокЭлементов(Ссылка, Список, ОтображениеСписком, Направление) Экспорт
	
	Результат = ПроверитьВозможностьПеремещения(Ссылка, Список, ОтображениеСписком);
	
	Если ПустаяСтрока(Результат) Тогда
		ПроверитьУпорядочиваниеЭлементов(Ссылка.Метаданные());
		ПередвинутьЭлемент(Ссылка, Список, Направление);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает значение реквизита доп. упорядочивания для нового объекта.
//
// Параметры:
//  Информация - Структура - информация о метаданных объекта;
//  Родитель   - Ссылка    - ссылка на родителя объекта;
//  Владелец   - Ссылка    - ссылка на владельца объекта.
//
// Возвращаемое значение:
//  Число - значение реквизита доп. упорядочивания.
Функция ПолучитьНовоеЗначениеРеквизитаДопУпорядочивания(Информация, Родитель, Владелец) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос();
	
	УсловияЗапроса = Новый Массив;
	
	Если Информация.ЕстьРодитель Тогда
		УсловияЗапроса.Добавить("Таблица.Родитель = &Родитель");
		Запрос.УстановитьПараметр("Родитель", Родитель);
	КонецЕсли;
	
	Если Информация.ЕстьВладелец Тогда
		УсловияЗапроса.Добавить("Таблица.Владелец = &Владелец");
		Запрос.УстановитьПараметр("Владелец", Владелец);
	КонецЕсли;
	
	ДополнительныеУсловия = "ИСТИНА";
	Для Каждого Условие Из УсловияЗапроса Цикл
		ДополнительныеУсловия = ДополнительныеУсловия + " И " + Условие;
	КонецЦикла;
	
	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Таблица.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания
	|ИЗ
	|	&Таблица КАК Таблица
	|ГДЕ
	|	&ДополнительныеУсловия
	|
	|УПОРЯДОЧИТЬ ПО
	|	РеквизитДопУпорядочивания УБЫВ";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Таблица", Информация.ПолноеИмя);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ДополнительныеУсловия", ДополнительныеУсловия);
	
	Запрос.Текст = ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат ?(Не ЗначениеЗаполнено(Выборка.РеквизитДопУпорядочивания), 1, Выборка.РеквизитДопУпорядочивания + 1);
	
КонецФункции

// Меняет местами выбранный элемент списка с соседним отображаемым элементом.
Процедура ПередвинутьЭлемент(Знач ПеремещаемыйЭлементСсылка, Знач Список, Знач Направление)
	
	СоседнийЭлементСсылка = СоседнийЭлемент(ПеремещаемыйЭлементСсылка, Список, Направление);
	Если СоседнийЭлементСсылка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		ЗаблокироватьДанныеДляРедактирования(ПеремещаемыйЭлементСсылка);
		ЗаблокироватьДанныеДляРедактирования(СоседнийЭлементСсылка);
		
		ПеремещаемыйЭлементОбъект = ПеремещаемыйЭлементСсылка.ПолучитьОбъект();
		СоседнийЭлементОбъект = СоседнийЭлементСсылка.ПолучитьОбъект();
		
		ПеремещаемыйЭлементОбъект.РеквизитДопУпорядочивания = ПеремещаемыйЭлементОбъект.РеквизитДопУпорядочивания
			+ СоседнийЭлементОбъект.РеквизитДопУпорядочивания;
		СоседнийЭлементОбъект.РеквизитДопУпорядочивания = ПеремещаемыйЭлементОбъект.РеквизитДопУпорядочивания
			- СоседнийЭлементОбъект.РеквизитДопУпорядочивания;
		ПеремещаемыйЭлементОбъект.РеквизитДопУпорядочивания = ПеремещаемыйЭлементОбъект.РеквизитДопУпорядочивания
			- СоседнийЭлементОбъект.РеквизитДопУпорядочивания;
	
		ПеремещаемыйЭлементОбъект.Записать();
		СоседнийЭлементОбъект.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Процедура ДобавитьПростойОтборВПостроительЗапроса(ПостроительЗапроса, ИмяПоля, Значение)
	Отбор = ПостроительЗапроса.Отбор;
	ЭлементОтбораПостроителяЗапроса = Отбор.Добавить(ИмяПоля);
	ЭлементОтбораПостроителяЗапроса.ВидСравнения = ВидСравнения.Равно;
	ЭлементОтбораПостроителяЗапроса.Значение = Значение;
	ЭлементОтбораПостроителяЗапроса.Использование = Истина;
КонецПроцедуры

Функция СписокСодержитОтборПоВладельцу(Список)
	
	ТребуемыеОтборы = Новый Массив;
	ТребуемыеОтборы.Добавить(Новый ПолеКомпоновкиДанных("Владелец"));
	ТребуемыеОтборы.Добавить(Новый ПолеКомпоновкиДанных("Owner"));
	
	Для Каждого Отбор Из Список.КомпоновщикНастроек.ПолучитьНастройки().Отбор.Элементы Цикл
		Если ТребуемыеОтборы.Найти(Отбор.ЛевоеЗначение) <> Неопределено Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция СписокСодержитОтборПоРодителю(Список)
	
	ТребуемыеОтборы = Новый Массив;
	ТребуемыеОтборы.Добавить(Новый ПолеКомпоновкиДанных("Родитель"));
	ТребуемыеОтборы.Добавить(Новый ПолеКомпоновкиДанных("Parent"));
	
	Для Каждого Отбор Из Список.КомпоновщикНастроек.ПолучитьНастройки().Отбор.Элементы Цикл
		Если ТребуемыеОтборы.Найти(Отбор.ЛевоеЗначение) <> Неопределено Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция ПроверитьВозможностьПеремещения(Ссылка, Список, ОтображениеСписком)
	
	ПараметрыДоступа = ПараметрыДоступа("Изменение", Ссылка.Метаданные(), "Ссылка");
	Если Не ПараметрыДоступа.Доступность Тогда
		Возврат НСтр("ru = 'Недостаточно прав для изменения порядка элементов.'");
	КонецЕсли;
	
	Для Каждого ЭлементГруппировки Из Список.КомпоновщикНастроек.ПолучитьНастройки().Структура Цикл
		Если ЭлементГруппировки.Использование Тогда
			Возврат НСтр("ru = 'Для изменения порядка элементов необходимо отключить все группировки.'");
		КонецЕсли;
	КонецЦикла;
	
	Информация = НастройкаПорядкаЭлементов.ПолучитьИнформациюДляПеремещения(Ссылка.Метаданные());
	
	// Для иерархических справочников может быть установлен отбор по родителю, если нет,
	// то способ отображения должен быть иерархический или в виде дерева.
	Если Информация.ЕстьРодитель И ОтображениеСписком И Не СписокСодержитОтборПоРодителю(Список) Тогда
		Возврат НСтр("ru = 'Для изменения порядка элементов необходимо установить режим просмотра ""Дерево"" или ""Иерархический список"".'");
	КонецЕсли;
	
	// Для подчиненных справочников должен быть установлен отбор по владельцу.
	Если Информация.ЕстьВладелец И Не СписокСодержитОтборПоВладельцу(Список) Тогда
		Возврат НСтр("ru = 'Для изменения порядка элементов необходимо установить отбор по полю ""Владелец"".'");
	КонецЕсли;
	
	// Проверка признака "Использование" у реквизита РеквизитДопУпорядочивания по отношению к перемещаемому элементу.
	Если Информация.ЕстьГруппы Тогда
		ЭтоГруппа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ЭтоГруппа");
		Если ЭтоГруппа И Не Информация.ДляГрупп Или Не ЭтоГруппа И Не Информация.ДляЭлементов Тогда
			Возврат НСтр("ru = 'Выбранный элемент нельзя перемещать.'");
		КонецЕсли;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Функция СхемаКомпоновкиДанных(ТекстЗапроса)
	
	СхемаКомпоновкиДанных = Новый СхемаКомпоновкиДанных;
	
	ИсточникДанных = СхемаКомпоновкиДанных.ИсточникиДанных.Добавить();
	ИсточникДанных.Имя = "ИсточникДанных1";
	ИсточникДанных.ТипИсточникаДанных = "local";
	
	НаборДанных = СхемаКомпоновкиДанных.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.ИсточникДанных = "ИсточникДанных1";
	НаборДанных.АвтоЗаполнениеДоступныхПолей = Истина;
	НаборДанных.Запрос = ТекстЗапроса;
	НаборДанных.Имя = "НаборДанных1";
	
	Возврат СхемаКомпоновкиДанных;
	
КонецФункции

Процедура УстановитьНастройкуСтруктурыВыводаРезультата(Настройки)
	
	Настройки.Структура.Очистить();
	Настройки.Выбор.Элементы.Очистить();
	
	ГруппировкаКомпоновкиДанных = Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ГруппировкаКомпоновкиДанных.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	ГруппировкаКомпоновкиДанных.Использование = Истина;
	
	ПолеГруппировки = ГруппировкаКомпоновкиДанных.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("Ссылка");
	ПолеГруппировки.Использование = Истина;
	
	ПолеВыбора = Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ПолеВыбора.Поле = Новый ПолеКомпоновкиДанных("Ссылка");
	ПолеВыбора.Использование = Истина;
	
КонецПроцедуры

Функция ПроверитьУпорядочиваниеЭлементов(МетаданныеТаблицы)
	Если Не ПравоДоступа("Изменение", МетаданныеТаблицы) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Владелец КАК Владелец,
	|	&Родитель КАК Родитель,
	|	Таблица.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания,
	|	1 КАК Количество,
	|	Таблица.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВсеЭлементы
	|ИЗ
	|	&Таблица КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВсеЭлементы.Владелец,
	|	ВсеЭлементы.Родитель,
	|	ВсеЭлементы.РеквизитДопУпорядочивания,
	|	СУММА(ВсеЭлементы.Количество) КАК Количество
	|ПОМЕСТИТЬ СтатистикаИндексов
	|ИЗ
	|	ВсеЭлементы КАК ВсеЭлементы
	|
	|СГРУППИРОВАТЬ ПО
	|	ВсеЭлементы.РеквизитДопУпорядочивания,
	|	ВсеЭлементы.Родитель,
	|	ВсеЭлементы.Владелец
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтатистикаИндексов.Владелец,
	|	СтатистикаИндексов.Родитель,
	|	СтатистикаИндексов.РеквизитДопУпорядочивания
	|ПОМЕСТИТЬ Дубли
	|ИЗ
	|	СтатистикаИндексов КАК СтатистикаИндексов
	|ГДЕ
	|	СтатистикаИндексов.Количество > 1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВсеЭлементы.Ссылка КАК Ссылка
	|ИЗ
	|	ВсеЭлементы КАК ВсеЭлементы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Дубли КАК Дубли
	|		ПО ВсеЭлементы.РеквизитДопУпорядочивания = Дубли.РеквизитДопУпорядочивания
	|			И ВсеЭлементы.Родитель = Дубли.Родитель
	|			И ВсеЭлементы.Владелец = Дубли.Владелец
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВсеЭлементы.Ссылка
	|ИЗ
	|	ВсеЭлементы КАК ВсеЭлементы
	|ГДЕ
	|	ВсеЭлементы.РеквизитДопУпорядочивания = 0";
	
	Информация = НастройкаПорядкаЭлементов.ПолучитьИнформациюДляПеремещения(МетаданныеТаблицы);
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Таблица", Информация.ПолноеИмя);
	
	ПолеРодителя = "Родитель";
	Если Не Информация.ЕстьРодитель Тогда
		ПолеРодителя = "1";
	КонецЕсли;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Родитель", ПолеРодителя);
	
	ПолеВладельца = "Владелец";
	Если Не Информация.ЕстьВладелец Тогда
		ПолеВладельца = "1";
	КонецЕсли;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Владелец", ПолеВладельца);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		Объект.РеквизитДопУпорядочивания = 0;
		Попытка
			Объект.Записать();
		Исключение
			Продолжить;
		КонецПопытки;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Функция ПолеОтбораВСпискеДоступных(ИмяПроверяемогоПоля, КоллекцияДоступныхПолейОтбора)
	Для Каждого ПолеОтбора Из КоллекцияДоступныхПолейОтбора Цикл
		Если ПолеОтбора.Поле = ИмяПроверяемогоПоля Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат Ложь;
КонецФункции

Функция ПоляОтбораВСпискеДоступных(КоллекцияПроверяемыхОтборов, КоллекцияДоступныхПолей)
	Результат = Истина;
	Для Каждого ПолеОтбора Из КоллекцияПроверяемыхОтборов Цикл
		Если ПолеОтбора.Использование Тогда
			Если ТипЗнч(ПолеОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
				Результат = Результат И ПоляОтбораВСпискеДоступных(ПолеОтбора.Элементы, КоллекцияДоступныхПолей);
			Иначе
				Результат = Результат И ПолеОтбораВСпискеДоступных(ПолеОтбора.ЛевоеЗначение, КоллекцияДоступныхПолей);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
КонецФункции

#КонецОбласти
