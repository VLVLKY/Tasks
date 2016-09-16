﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		
		// Удаление дублей и пустых строк.
		ВыбранныеСвойства = Новый Соответствие;
		УдаляемыеСвойства = Новый Массив;
		
		// Дополнительные реквизиты.
		Для каждого ДополнительныйРеквизит Из ДополнительныеРеквизиты Цикл
			
			Если ДополнительныйРеквизит.Свойство.Пустая()
			 ИЛИ ВыбранныеСвойства.Получить(ДополнительныйРеквизит.Свойство) <> Неопределено Тогда
				
				УдаляемыеСвойства.Добавить(ДополнительныйРеквизит);
			Иначе
				ВыбранныеСвойства.Вставить(ДополнительныйРеквизит.Свойство, Истина);
			КонецЕсли;
		КонецЦикла;
		
		Для каждого УдаляемоеСвойство Из УдаляемыеСвойства Цикл
			ДополнительныеРеквизиты.Удалить(УдаляемоеСвойство);
		КонецЦикла;
		
		ВыбранныеСвойства.Очистить();
		УдаляемыеСвойства.Очистить();
		
		// Дополнительные сведения.
		Для каждого ДополнительноеСведение Из ДополнительныеСведения Цикл
			
			Если ДополнительноеСведение.Свойство.Пустая()
			 ИЛИ ВыбранныеСвойства.Получить(ДополнительноеСведение.Свойство) <> Неопределено Тогда
				
				УдаляемыеСвойства.Добавить(ДополнительноеСведение);
			Иначе
				ВыбранныеСвойства.Вставить(ДополнительноеСведение.Свойство, Истина);
			КонецЕсли;
		КонецЦикла;
		
		Для каждого УдаляемоеСвойство Из УдаляемыеСвойства Цикл
			ДополнительныеСведения.Удалить(УдаляемоеСвойство);
		КонецЦикла;
		
		// Вычисление количества свойств не помеченных на удаление.
		КоличествоРеквизитов = Формат(ДополнительныеРеквизиты.НайтиСтроки(
			Новый Структура("ПометкаУдаления", Ложь)).Количество(), "ЧГ=");
		
		КоличествоСведений   = Формат(ДополнительныеСведения.НайтиСтроки(
			Новый Структура("ПометкаУдаления", Ложь)).Количество(), "ЧГ=");
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		// Обновление состава верхней группы для использования при настройке
		// состава полей динамического списка и его настройки (отборы, ...).
		Если ЗначениеЗаполнено(Родитель) Тогда
			УправлениеСвойствамиСлужебный.ПроверитьОбновитьСоставСвойствГруппы(Родитель);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
