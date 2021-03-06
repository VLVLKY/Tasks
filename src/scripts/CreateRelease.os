#Использовать v8runner
#Использовать logos

Перем Лог;
Перем Конфигуратор;
Перем НоваяВерсия;

Процедура Инициализация()
	Лог.УстановитьУровень(УровниЛога.Отладка);

	Конфигуратор = Новый УправлениеКонфигуратором();
	Конфигуратор.УстановитьКонтекст("/FD:\Cloud\Dev\Tasks\Base","Иванов Антон Борисович", "");
	//Конфигуратор.ВыгрузитьКонфигурациюВФайлы("d:\Cloud\Dev\GitRep\Tasks\src\cf\")
	
	//Версия = "1.0.1.012";
	НоваяВерсия = АргументыКоманднойСтроки[0];
	
	СоздатьФайлыПоставкиДляРелиза();
	
	//СоздатьФайлыКомплектаДляРелиза();

Конецпроцедуры

Процедура СоздатьФайлыКомплектаДляРелиза()
	КаталогСозданияФайловКомплектовПоставки = "d:\Cloud\Dev\Tasks\_Rel\distribute\"+НоваяВерсия+"\";

	ИмяФайлаОписанияКомплектаПоставки = "d:\Cloud\Dev\Tasks\_Rel\releases\ОписаниеПоставки.edf";
	Лог.Отладка("ИмяФайлаОписанияКомплектаПоставки "+ ИмяФайлаОписанияКомплектаПоставки);
	Конфигуратор.СоздатьФайлыКомплекта(КаталогСозданияФайловКомплектовПоставки,ИмяФайлаОписанияКомплектаПоставки);
КонецПроцедуры 

Процедура СоздатьФайлыПоставкиДляРелиза()
	КаталогРелизов = "d:\Cloud\Dev\Tasks\_Rel\releases\";
	ПутьФайлаПолнойПоставки = КаталогРелизов + ""+НоваяВерсия+"\1Cv8.cf";
	ПутьФайлаПоставкиОбновления = КаталогРелизов + ""+НоваяВерсия+"\1Cv8.cfu";
	//Сообщить("ПутьФайлаПолнойПоставки "+ ПутьФайлаПолнойПоставки);
	//Сообщить("ПутьФайлаПоставкиОбновления "+ ПутьФайлаПоставкиОбновления);
	
	МассивДистрибутивовДляОбновления = Новый Массив();
	НайденныеФайлы = НайтиФайлы(КаталогРелизов,"*");
	Для каждого пФайл Из НайденныеФайлы Цикл
		Если пФайл.ЭтоКаталог()
			И пФайл.Имя <> НоваяВерсия Тогда			
			ПутьДистрибутиваДляОбновления = пФайл.ПолноеИмя + "\1Cv8.cf";
			МассивДистрибутивовДляОбновления.Добавить(ПутьДистрибутиваДляОбновления);
			Лог.Отладка("ПутьДистрибутиваДляОбновления "+ ПутьДистрибутиваДляОбновления);
		КонецЕсли;
	КонецЦикла;
	
	Конфигуратор.СоздатьФайлыПоставки(ПутьФайлаПолнойПоставки,ПутьФайлаПоставкиОбновления,МассивДистрибутивовДляОбновления);
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////////
// Инициализация
Лог = Логирование.ПолучитьЛог("СоздатьРелиз");
Инициализация();