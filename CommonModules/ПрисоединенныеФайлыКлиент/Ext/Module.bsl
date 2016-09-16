﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Присоединенные файлы".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает файл для просмотра или редактирования.
//  Если файл открывается для просмотра, тогда получает файл в рабочий каталог пользователя,
// при этом ищет файл в рабочем каталоге и предлагает открыть существующий или получить файл с сервера.
//  Если файл открывается для редактирования, тогда открывает файл в рабочем каталоге (если есть) или
// получает его с сервера.
//
// Параметры:
//  ДанныеФайла       - Структура - данные файла.
//  ДляРедактирования - Булево - Истина, если файл открывается для редактирования, иначе Ложь.
//
Процедура ОткрытьФайл(Знач ДанныеФайла, Знач ДляРедактирования = Истина) Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ДанныеФайла", ДанныеФайла);
	Параметры.Вставить("ДляРедактирования", ДляРедактирования);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФайлРасширениеПредложено", ПрисоединенныеФайлыСлужебныйКлиент, Параметры);
	ФайловыеФункцииСлужебныйКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения);
	
КонецПроцедуры

// Обработчик команды добавления файлов.
//  Предлагает пользователю выбирать файлы в диалоге выбора файлов и
// пытается поместить выбранные файлы в хранилище файлов, когда:
// - размер файла не превышает максимально допустимый,
// - файл имеет допустимое расширение,
// - имеется свободное место в томе (при хранении файлов в томах),
// - прочие условия.
//
// Параметры:
//  ВладелецФайла      - Ссылка - владелец файла.
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор управляемой формы.
//  Фильтр             - Строка - необязательный параметр,
//                       позволяет задать фильтр выбираемого файла,
//                       например, картинки для номенклатуры.
//
Процедура ДобавитьФайлы(Знач ВладелецФайла, Знач ИдентификаторФормы, Знач Фильтр = "") Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ВладелецФайла", ВладелецФайла);
	Параметры.Вставить("ИдентификаторФормы", ИдентификаторФормы);
	Параметры.Вставить("Фильтр", Фильтр);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьФайлыРасширениеПредложено", ПрисоединенныеФайлыСлужебныйКлиент, Параметры);
	ФайловыеФункцииСлужебныйКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения);
	
КонецПроцедуры

// Подписывает присоединенный файл.
//
// Параметры:
//  ПрисоединенныйФайл      - СправочникСсылка - ссылка на справочник с именем "*ПрисоединенныеФайлы".
//  ИдентификаторФормы      - УникальныйИдентификатор - идентификатор управляемой формы.
//  ДополнительныеПараметры - Неопределено - стандартное поведение (см. ниже).
//                          - Структура - со свойствами:
//       * ДанныеФайла            - Структура - данные файла, если свойства нет, будет вставлено.
//       * ОбработкаРезультата    - ОписаниеОповещения - при вызове передается значение типа Булево,
//                                  если Истина - файл успешно подписан, иначе не подписан,
//                                  если свойства нет, оповещение не будет вызвано.
//
Процедура ПодписатьФайл(ПрисоединенныйФайл, ИдентификаторФормы, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ПрисоединенныйФайл) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбран файл, который нужно подписать.'"));
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодпись") Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Добавление электронных подписей не поддерживается.'"));
		Возврат;
	КонецЕсли;
	
	МодульЭлектроннаяПодписьКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЭлектроннаяПодписьКлиент");
	
	Если Не МодульЭлектроннаяПодписьКлиент.ИспользоватьЭлектронныеПодписи() Тогда
		ПоказатьПредупреждение(,
			НСтр("ru = 'Чтобы добавить электронную подпись, включите
			           |в настройках программы использование электронных подписей.'"));
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = Новый Структура;
	КонецЕсли;
	
	Если Не ДополнительныеПараметры.Свойство("ДанныеФайла") Тогда
		ДополнительныеПараметры.Вставить("ДанныеФайла", ПолучитьДанныеФайла(
			ПрисоединенныйФайл, ИдентификаторФормы));
	КонецЕсли;
	
	ОбработкаРезультата = Неопределено;
	ДополнительныеПараметры.Свойство("ОбработкаРезультата", ОбработкаРезультата);
	
	ПрисоединенныеФайлыСлужебныйКлиент.ПодписатьФайл(ПрисоединенныйФайл,
		ДополнительныеПараметры.ДанныеФайла, ИдентификаторФормы, ОбработкаРезультата);
	
КонецПроцедуры

// Сохраняет файл вместе вместе с ЭП.
// Используется в обработчике команды сохранения файла.
//
// Параметры:
//  ПрисоединенныйФайл - СправочникСсылка - ссылка на справочник с именем "*ПрисоединенныеФайлы".
//  ДанныеФайла        - Структура - (необязательный) - данные файла.
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор управляемой формы.
//
Процедура СохранитьВместеСЭП(Знач ПрисоединенныйФайл, Знач ДанныеФайла, Знач ИдентификаторФормы) Экспорт
	
	Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодпись") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("ПрисоединенныйФайл", ПрисоединенныйФайл);
	Параметры.Вставить("ДанныеФайла",        ДанныеФайла);
	Параметры.Вставить("ИдентификаторФормы", ИдентификаторФормы);
	
	ОписаниеДанных = Новый Структура;
	ОписаниеДанных.Вставить("ЗаголовокДанных",     НСтр("ru = 'Файл'"));
	ОписаниеДанных.Вставить("ПоказатьКомментарий", Истина);
	ОписаниеДанных.Вставить("Объект",              ПрисоединенныйФайл);
	ОписаниеДанных.Вставить("Данные",              Новый ОписаниеОповещения(
		"ПриСохраненииДанныхФайла", ПрисоединенныеФайлыСлужебныйКлиент, Параметры));
	
	МодульЭлектроннаяПодписьКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЭлектроннаяПодписьКлиент");
	МодульЭлектроннаяПодписьКлиент.СохранитьДанныеВместеСПодписью(ОписаниеДанных);
	
КонецПроцедуры

// Сохраняет файл в каталог на диске.
// Так же используется, как вспомогательная функция при сохранении файла с ЭП.
//
// Параметры:
//  ДанныеФайла  - Структура - данные файла.
//
// Возвращаемое значение:
//  Строка - имя сохраненного файла.
//
Процедура СохранитьФайлКак(Знач ДанныеФайла) Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ДанныеФайла", ДанныеФайла);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СохранитьФайлКакРасширениеПредложено", ПрисоединенныеФайлыСлужебныйКлиент, Параметры);
	ФайловыеФункцииСлужебныйКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения);
	
КонецПроцедуры

// Открывает общую форму присоединенного файла из формы элемента
// справочника присоединенных файлов. Форма элемента закрывается.
// 
// Параметры:
//  Форма     - УправляемаяФорма - форма справочника присоединенных файлов.
//
Процедура ПерейтиКФормеПрисоединенногоФайла(Знач Форма) Экспорт
	
	ПрисоединенныйФайл = Форма.Ключ;
	
	Форма.Закрыть();
	
	Для Каждого ОкноКП Из ПолучитьОкна() Цикл
		
		Содержимое = ОкноКП.ПолучитьСодержимое();
		
		Если Содержимое = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если Содержимое.ИмяФормы = "ОбщаяФорма.ПрисоединенныйФайл" Тогда
			Если Содержимое.Параметры.Свойство("ПрисоединенныйФайл")
			   И Содержимое.Параметры.ПрисоединенныйФайл = ПрисоединенныйФайл Тогда
				ОкноКП.Активизировать();
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	ОткрытьФормуПрисоединенногоФайла(ПрисоединенныйФайл);
	
КонецПроцедуры

// Открывает форму выбора файлов.
// Используется в обработчике выбора для переопределения стандартного поведения.
//
// Параметры:
//  ВладелецФайлов       - Ссылка - ссылка на объект с файлами.
//  ЭлементФормы         - ТаблицаФормы, ПолеФормы - элемент формы, которому будет отправлено
//                         оповещение о выборе.
//  СтандартнаяОбработка - Булево - (возвращаемое значение), всегда устанавливается в Ложь.
//
Процедура ОткрытьФормуВыбораФайлов(Знач ВладелецФайлов, Знач ЭлементФормы, СтандартнаяОбработка = Ложь) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ВладелецФайла", ВладелецФайлов);
	
	ОткрытьФорму("ОбщаяФорма.ПрисоединенныеФайлы", ПараметрыФормы, ЭлементФормы);
	
КонецПроцедуры

// Открывает форму присоединенного файла.
// Может использоваться как обработчик открытия присоединенного файла.
//
// Параметры:
//  ПрисоединенныйФайл   - СправочникСсылка - ссылка на справочник с именем "*ПрисоединенныеФайлы".
//  СтандартнаяОбработка - Булево - (возвращаемое значение), всегда устанавливается в Ложь.
//
Процедура ОткрытьФормуПрисоединенногоФайла(Знач ПрисоединенныйФайл, СтандартнаяОбработка = Ложь) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(ПрисоединенныйФайл) Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ПрисоединенныйФайл", ПрисоединенныйФайл);
		
		ОткрытьФорму("ОбщаяФорма.ПрисоединенныйФайл", ПараметрыФормы, , ПрисоединенныйФайл);
	КонецЕсли;
	
КонецПроцедуры

// См. эту функцию в модуле ПрисоединенныеФайлы.
Функция ПолучитьДанныеФайла(Знач ПрисоединенныйФайл,
                            Знач ИдентификаторФормы = Неопределено,
                            Знач ПолучатьСсылкуНаДвоичныеДанные = Истина,
                            Знач ДляРедактирования = Ложь) Экспорт
	
	Возврат ПрисоединенныеФайлыСлужебныйВызовСервера.ПолучитьДанныеФайла(
		ПрисоединенныйФайл, ИдентификаторФормы, ПолучатьСсылкуНаДвоичныеДанные, ДляРедактирования);
	
КонецФункции

// Получает файл из хранилища файлов в рабочий каталог пользователя.
// Аналог интерактивного действия Просмотреть или Редактировать без открытия полученного файла.
//   Свойство ТолькоПросмотр полученного файла будет установлено в зависимости от того захвачен
// файл для редактирования или нет. Если не захвачен - устанавливается только просмотр.
//   Если в рабочем каталоге уже существует файл, тогда он будет удален и заменен файлом,
// полученным из хранилища файлов.
//
// Параметры:
//  Оповещение - ОписаниеОповещения - оповещение, которое выполняется после получения файла в
//   рабочий каталог пользователя. В качестве результата возвращается Структура со свойствами:
//     * ПолноеИмяФайла - Строка - полное имя файла (с путем).
//     * ОписаниеОшибки - Строка - текст ошибки, если получить файл не удалось.
//
//  ПрисоединенныйФайл - СправочникСсылка - ссылка на справочник с именем "*ПрисоединенныеФайлы".
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор управляемой формы.
//
//  ДополнительныеПараметры - Неопределено - использовать значения по умолчанию.
//     - Структура - с необязательными свойствами:
//         * ДляРедактирования - Булево    - начальное значение Ложь. Если Истина,
//                                           тогда файл будет захвачен для редактирования.
//         * ДанныеФайла       - Структура - свойства файла, которые можно передать для ускорения
//                                           если они ранее были получены на клиент с сервера.
//
Процедура ПолучитьПрисоединенныйФайл(Оповещение, ПрисоединенныйФайл, ИдентификаторФормы, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПрисоединенныеФайлыСлужебныйКлиент.ПолучитьПрисоединенныйФайл(Оповещение, ПрисоединенныйФайл, ИдентификаторФормы, ДополнительныеПараметры);
	
КонецПроцедуры

// Помещает файл из рабочего каталога пользователя в хранилище файлов.
// Аналог интерактивного действия Закончить редактирование.
//
// Параметры:
//  Оповещение - ОписаниеОповещения - оповещение, которое выполняется после помещения файла в
//   хранилище файлов. В качестве результата возвращается Структура со свойствами:
//     * ОписаниеОшибки - Строка - текст ошибки, если поместить файл не удалось.
//
//  ПрисоединенныйФайл - СправочникСсылка - ссылка на справочник с именем "*ПрисоединенныеФайлы".
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор управляемой формы.
//
//  ДополнительныеПараметры - Неопределено - использовать значения по умолчанию.
//     - Структура - с необязательными свойствами:
//         * ПолноеИмяФайла - Строка - если заполнено, то указанный файл будет помещен в рабочий каталог
//                                     пользователя, а затем в хранилище файлов.
//         * ДанныеФайла    - Структура - свойства файла, которые можно передать для ускорения
//                                        если они ранее были получены на клиент с сервера.
//
Процедура ПоместитьПрисоединенныйФайл(Оповещение, ПрисоединенныйФайл, ИдентификаторФормы, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПрисоединенныеФайлыСлужебныйКлиент.ПоместитьПрисоединенныйФайл(Оповещение, ПрисоединенныйФайл, ИдентификаторФормы, ДополнительныеПараметры);
	
КонецПроцедуры

// Выполняет печать файлов.
//
// Параметры:
//  ДанныеФайлов       - Массив - массив структур с данными файлов.
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор управляемой формы.
//
Процедура НапечататьФайлы(ДанныеФайлов, ИдентификаторФормы) Экспорт
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("НомерФайла", 0);
	ПараметрыВыполнения.Вставить("ДанныеФайлов", ДанныеФайлов);
	ПараметрыВыполнения.Вставить("ДанныеФайла", Неопределено);
	ПараметрыВыполнения.Вставить("ДляРедактирования", Ложь);
	ПараметрыВыполнения.Вставить("ИдентификаторФормы", ИдентификаторФормы);
	Обработчик = Новый ОписаниеОповещения("НапечататьФайлыВыполнение", ЭтотОбъект, ПараметрыВыполнения);
	ВыполнитьОбработкуОповещения(Обработчик);

КонецПроцедуры

// Процедура печати Файла
//
// Параметры:
//  ОбработчикРезультата - ОписаниеОповещения для дальнейшего вызова.
//  ПараметрыВыполнения  - Структура - со свойствами:
//        * НомерФайла               - Число - номер текущего файла,
//        * ДанныеФайла              - Структура - данные файла,
//        * УникальныйИдентификатор  - УникальныйИдентификатор.
//
Процедура НапечататьФайлыВыполнение(ОбработчикРезультата, ПараметрыВыполнения) Экспорт
	
	Если ПараметрыВыполнения.НомерФайла >= ПараметрыВыполнения.ДанныеФайлов.Количество() Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = ПараметрыВыполнения.ДанныеФайлов[ПараметрыВыполнения.НомерФайла];
	
	ПараметрыВыполнения.ДанныеФайла = ПрисоединенныеФайлыСлужебныйВызовСервера.ПолучитьДанныеФайла(ДанныеФайла, ПараметрыВыполнения.ИдентификаторФормы);
	
	Обработчик = Новый ОписаниеОповещения("НапечататьФайлПослеПолученияВерсииВРабочийКаталог", ЭтотОбъект, ПараметрыВыполнения);
	
	ПолучитьПрисоединенныйФайл(
		Обработчик,
		ДанныеФайла,
		ПараметрыВыполнения.ИдентификаторФормы,
		ПараметрыВыполнения)
	
КонецПроцедуры

// Процедура печати Файла после получения на диск
//
// Параметры:
//  ПараметрыВыполнения  - Структура - со свойствами:
//        * НомерФайла               - Число - номер текущего файла,
//        * ДанныеФайла              - Структура - данные файла,
//        * УникальныйИдентификатор  - УникальныйИдентификатор.
//
Процедура НапечататьФайлПослеПолученияВерсииВРабочийКаталог(Результат, ПараметрыВыполнения) Экспорт
	
	Если ЗначениеЗаполнено(Результат.ОписаниеОшибки) Тогда
		Возврат;
	КонецЕсли;

	Если ПараметрыВыполнения.НомерФайла >= ПараметрыВыполнения.ДанныеФайлов.Количество() Тогда
		Возврат;
	КонецЕсли;
	
	НапечататьФайлПриложением(ПараметрыВыполнения.ДанныеФайла, Результат.ПолноеИмяФайла);
	
	// переходим к печати следующего файла
	ПараметрыВыполнения.НомерФайла = ПараметрыВыполнения.НомерФайла + 1;
	Обработчик = Новый ОписаниеОповещения("НапечататьФайлыВыполнение", ЭтотОбъект, ПараметрыВыполнения);
	ВыполнитьОбработкуОповещения(Обработчик);
	
КонецПроцедуры

// Выполняет печать файла внешним приложением.
//
// Параметры
//  ИмяОткрываемогоФайла - Строка - полное имя файла.
//
Процедура НапечататьИзПриложенияПоИмениФайла(ИмяОткрываемогоФайла) Экспорт
	
	Если Не ЗначениеЗаполнено(ИмяОткрываемогоФайла) Тогда
		Возврат;
	КонецЕсли;
		
	СистемнаяИнфо = Новый СистемнаяИнформация;
	Если СистемнаяИнфо.ТипПлатформы = ТипПлатформы.Windows_x86 
	 Или СистемнаяИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
		
		Shell = Новый COMОбъект("Shell.Application");
		Shell.ShellExecute(ИмяОткрываемогоФайла, "", "", "print", 1);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура предназначена для печати файла соответствующим приложением
//
// Параметры
//  ДанныеФайла          - Структура - данные файла.
//  ИмяОткрываемогоФайла - Строка - полное имя файла.
//
Процедура НапечататьФайлПриложением(ДанныеФайла, ИмяОткрываемогоФайла)
	
	РасширенияИсключения = 
	" m3u, m4a, mid, midi, mp2, mp3, mpa, rmi, wav, wma, 
	| 3g2, 3gp, 3gp2, 3gpp, asf, asx, avi, m1v, m2t, m2ts, m2v, m4v, mkv, mov, mp2v, mp4, mp4v, mpe, mpeg, mts, vob, wm, wmv, wmx, wvx,
	| 7z, zip, rar, arc, arh, arj, ark, p7m, pak, package, 
	| app, com, exe, jar, dll, res, iso, isz, mdf, mds,
	| cf, dt, epf, erf";
	
	Расширение = НРег(ДанныеФайла.Расширение);
	Если СтрНайти(РасширенияИсключения, " "+Расширение+",") > 0 Тогда 
		
		Возврат;
	
	ИначеЕсли Расширение = "grs" Тогда
		
		Схема = Новый ГрафическаяСхема; 
		Схема.Прочитать(ИмяОткрываемогоФайла);
		Схема.Напечатать();;
		
	ИначеЕсли Расширение = "mxl" Тогда
		
		ТабличныйДокумент = Новый ТабличныйДокумент;
		ТабличныйДокумент.Прочитать(ИмяОткрываемогоФайла);
		ТабличныйДокумент.Напечатать();
		
	Иначе
		
		Попытка
			
			СистемнаяИнфо = Новый СистемнаяИнформация;
			Если СистемнаяИнфо.ТипПлатформы = ТипПлатформы.Windows_x86 
				Или СистемнаяИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
				ИмяОткрываемогоФайла = СтрЗаменить(ИмяОткрываемогоФайла, "/", "\");
			КонецЕсли;
			
			НапечататьИзПриложенияПоИмениФайла(ИмяОткрываемогоФайла);
			
		Исключение
			
			Инфо = ИнформацияОбОшибке();
			ПоказатьПредупреждение(,СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Описание=""%1""'"),
				КраткоеПредставлениеОшибки(Инфо))); 
			
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
