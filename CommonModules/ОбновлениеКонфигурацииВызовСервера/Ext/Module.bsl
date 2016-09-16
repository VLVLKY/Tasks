﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обновление конфигурации".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Получает настройки помощника обновления из хранилища общих настроек.
//
// Подробнее - см. описание ОбновлениеКонфигурации.ПолучитьСтруктуруНастроекПомощника().
//
Функция ПолучитьСтруктуруНастроекПомощника() Экспорт
	
	Возврат ОбновлениеКонфигурации.ПолучитьСтруктуруНастроекПомощника();
	
КонецФункции

// Записывает настройки помощника обновления в хранилище общих настроек.
//
// Подробнее - см. описание ОбновлениеКонфигурации.ЗаписатьСтруктуруНастроекПомощника().
//
Процедура ЗаписатьСтруктуруНастроекПомощника(НастройкиОбновленияКонфигурации, СообщенияДляЖурналаРегистрации = Неопределено) Экспорт
	
	ОбновлениеКонфигурации.ЗаписатьСтруктуруНастроекПомощника(НастройкиОбновленияКонфигурации, СообщенияДляЖурналаРегистрации);
	
КонецПроцедуры

#КонецОбласти
