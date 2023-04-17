
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыгрузитьИзБазыИсточника(Команда)

	ПараметрыКонфигурацииИсточник = РаботаСГитомВызовСервера.ПараметрыДляРаботыСКонфигурацией(БазаИсточник);
	ПараметрыКонфигурацииПриемник = РаботаСГитомВызовСервера.ПараметрыДляРаботыСКонфигурацией(БазаПриемник);
	
	ПараметрыКонфигурацииИсточник.ВерсияПлатформы = ПараметрыКонфигурацииПриемник.ВерсияПлатформы; // Выгружаем той же версией
	ПараметрыВыполнения = РаботаСГитомВызовСервера.ПараметрыВыполнения();
	
	МетаданныеКВыгрузке = МетаданныеКВыгрузке();
	Индекс = МетаданныеКВыгрузке.Найти("Configuration");
	
	Если Индекс <> Неопределено Тогда
		КореньКонфигурации = ВыгрузитьКорень(ПараметрыКонфигурацииИсточник);
		МетаданныеКВыгрузке.Удалить(Индекс);
	КонецЕсли;
	
	КомандаКВыполению = РаботаСКонфигурациейКлиентСервер.КомандаДляЗапускаВыгрузкиОбъектов(ПараметрыВыполнения, 
		ПараметрыКонфигурацииИсточник, МетаданныеКВыгрузке, Истина);
	
	ИмяФайлаЛога = ПараметрыВыполнения.РабочийКаталог + "\log.txt"; 
	РаботаСКонфигурациейКлиентСервер.ДобавитьВыводВФайл(КомандаКВыполению, ПараметрыВыполнения, ИмяФайлаЛога);
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КомандаКВыполению);
	УдалитьФайлы(ПараметрыВыполнения.РабочийКаталог + "\", "*");
	ЗапуститьПриложение(КомандаКВыполению,, Истина);
	
	Если КореньКонфигурации <> Неопределено Тогда
		Для Каждого ФайлСоответствие Из КореньКонфигурации.Файлы Цикл
			ИтоговыйФайлПуть = СтрЗаменить(ФайлСоответствие.Ключ, КореньКонфигурации.Каталог, ПараметрыВыполнения.РабочийКаталог + "\bd\");
			ФайлСоответствие.Значение.Записать(ИтоговыйФайлПуть);
		КонецЦикла;
	КонецЕсли;
	
	ПрочитатьЛог(ИмяФайлаЛога);

	
КонецПроцедуры 

&НаКлиенте
Процедура Подбор(Команда)                         
	ПараметрыОткрытия = Новый Структура("ЗакрыватьПриВыборе", Ложь);
	ПараметрыОткрытия.Вставить("МножественныйВыбор", Истина);
	ОткрытьФорму("Справочник.Коммиты.ФормаВыбора", ПараметрыОткрытия, Элементы.Коммиты);
КонецПроцедуры

&НаКлиенте
Процедура ЗахватитьВБазеПриемнике(Команда)
	ПараметрыЗапуска = ПараметрыЗапускаКонфигуратора(БазаПриемник);
	
	ФайлИзменений = ПараметрыЗапуска.ПутьКФайлуИзмененияХранилища;
	МассивИменМетаданныхВФайлДляХранилища(ПараметрыЗапуска.МетаданныеКВыгрузке).Записать(ФайлИзменений);
	
	НоваяКоманда = Новый Массив;
	НоваяКоманда.Добавить(ПараметрыЗапуска.СтрокаЗапуска1С);
	НоваяКоманда.Добавить(ПараметрыЗапуска.СтрокаПодключенияКБД);
	НоваяКоманда.Добавить(ПараметрыЗапуска.СтрокаПодключенияКХранилищу);
	НоваяКоманда.Добавить(КомандаЗахватаОбъектовВХранилище(ФайлИзменений));
	НоваяКоманда.Добавить(ПараметрыЗапуска.СтрокаРезультата);
	
	КомандаЗапуска = СтрСоединить(НоваяКоманда, " ");
	
	ЗапуститьПриложение(КомандаЗапуска,, Истина);
	
	ПрочитатьЛоги(ПараметрыЗапуска.РабочийКаталог);
	
КонецПроцедуры


&НаКлиенте
Процедура ЗапуститьКонфигураторПриемник(Команда)
	ПараметрыЗапуска = ПараметрыЗапускаКонфигуратора(БазаПриемник);
	
	ФайлИзменений = ПараметрыЗапуска.ПутьКФайлуИзмененияХранилища;
	МассивИменМетаданныхВФайлДляХранилища(ПараметрыЗапуска.МетаданныеКВыгрузке).Записать(ФайлИзменений);
	
	НоваяКоманда = Новый Массив;
	НоваяКоманда.Добавить(ПараметрыЗапуска.СтрокаЗапуска1С);
	НоваяКоманда.Добавить(ПараметрыЗапуска.СтрокаПодключенияКБД);
	НоваяКоманда.Добавить(ПараметрыЗапуска.СтрокаПодключенияКХранилищу);
	
	КомандаЗапуска = СтрСоединить(НоваяКоманда, " ");
	
	ЗапуститьПриложение(КомандаЗапуска,, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОбъекты(Команда)
	ПараметрыВыполнения = РаботаСГитомВызовСервера.ПараметрыВыполнения();
	ПараметрыЗапуска = ПараметрыЗапускаКонфигуратора(БазаПриемник);
	
	КаталогБД = ПараметрыЗапуска.РабочийКаталог + "\bd\";
	Файл = Новый Файл(КаталогБД);
	Если НЕ Файл.Существует()  Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Нет выгрузки");
		Возврат;
	КонецЕсли;
	
	ФайлыКЗагрузкеОтносительные = ФайлыКЗагрузке();
	
	ФайлыКЗагрузкеСтроки = Новый Массив;

	Для Сч = 0 По ФайлыКЗагрузкеОтносительные.ВГраница() Цикл
		ОтносительныйПутьКФайлуEDT = ФайлыКЗагрузкеОтносительные[Сч];
		
		ПутьКФайлу = ПутьEDTВПутьКонфигуратора(ОтносительныйПутьКФайлуEDT);
		ФайлыКЗагрузкеСтроки.Добавить(ПутьКФайлу);
	КонецЦикла;
	
	ИтоговыйСписок = Новый Массив;
	ИтоговыйСписокОтносительный = Новый Массив;
	Для Сч = 0 По ФайлыКЗагрузкеСтроки.ВГраница() Цикл
		
		ОтносительныйПутьКФайлу = ФайлыКЗагрузкеСтроки[Сч];
		Файл = Новый Файл(КаталогБД + СтрЗаменить(ОтносительныйПутьКФайлу, "/", "\"));
		Если Не Файл.Существует() Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Файл.ПолноеИмя + " Не существует!");
			Продолжить;
		КонецЕсли;
		
		Если СокрЛП(ОтносительныйПутьКФайлу) = "" Тогда
			Продолжить;
		КонецЕсли;
		
		ПутьИтоговый = КаталогБД + СтрЗаменить(ОтносительныйПутьКФайлу, "/", "\");
		Если ИтоговыйСписок.Найти(ПутьИтоговый) = Неопределено Тогда
			ИтоговыйСписок.Добавить(ПутьИтоговый);
		КонецЕсли;
		
		Если Лев(ОтносительныйПутьКФайлу, 1) = "/" Тогда
			ОтносительныйПутьКФайлу = Сред(ОтносительныйПутьКФайлу, 2);
		КонецЕсли;
		ПутьИтоговый = СтрЗаменить(ОтносительныйПутьКФайлу, "/", "\");
		Если ИтоговыйСписокОтносительный.Найти(ПутьИтоговый) = Неопределено Тогда
			ИтоговыйСписокОтносительный.Добавить(ПутьИтоговый);
		КонецЕсли;
		
	КонецЦикла;
		
	ПараметрыКонфигурацииПриемник = РаботаСГитомВызовСервера.ПараметрыДляРаботыСКонфигурацией(БазаПриемник);
	
	КомандаЗапуска = РаботаСКонфигурациейКлиентСервер.КомандаДляЗапускаЗагрузкиОбъектовBICMD(ПараметрыВыполнения,
		ПараметрыКонфигурацииПриемник, ИтоговыйСписокОтносительный);
		
	ИмяФайлаЛога = ПараметрыВыполнения.РабочийКаталог + "\log.txt"; 
	РаботаСКонфигурациейКлиентСервер.ДобавитьВыводВФайл(КомандаЗапуска, ПараметрыВыполнения, ИмяФайлаЛога);
	
	ЗапуститьПриложение(КомандаЗапуска,, Истина);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КомандаЗапуска);
	ПрочитатьЛог(ИмяФайлаЛога);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции


&НаКлиенте
Функция ПутьEDTВПутьКонфигуратора(ОтносительныйПуть)
	РазобранныйПуть = СтрРазделить(ОтносительныйПуть, "/", Ложь);
	Результат = "";
	
	Граница = РазобранныйПуть.ВГраница();
	
	Если РазобранныйПуть.Количество() = 2 Тогда
		Если РазобранныйПуть[1] = "Configuration.mdo" Тогда
			Результат = "/Configuration.xml";
		КонецЕсли;
		
	ИначеЕсли РазобранныйПуть.Количество() = 3 Тогда
		
		//Общие модули, непосредственно объекты, кроме подсистем
		Расширение = Прав(РазобранныйПуть[2], 4);
		Если Расширение = ".bsl" Тогда
			//Модуль, например общий
			Для Сч = 0 По 1 Цикл
				Результат = Результат + "/" + РазобранныйПуть[Сч];
			КонецЦикла;
			Результат = Результат + "/Ext/";
			Результат = Результат + РазобранныйПуть[2];
		ИначеЕсли Расширение = ".mdo" Тогда
			// Объект
			//Для Сч = 0 По 0 Цикл
			//	Результат = Результат + "/" + РазобранныйПуть[Сч];
			//КонецЦикла;       
			Результат = РазобранныйПуть[0];
			Результат = Результат + "/" + СтрЗаменить(РазобранныйПуть[2], ".mdo", ".xml");
		КонецЕсли;
		
	ИначеЕсли РазобранныйПуть.Количество() > 3 Тогда
		
		Если РазобранныйПуть[2] = "Forms" Тогда
			//Формы
			Расширение = Прав(РазобранныйПуть[РазобранныйПуть.ВГраница()], 4);
			
			// Модуль
			Если Расширение = ".bsl"
			Или Прав(РазобранныйПуть[РазобранныйПуть.ВГраница()], 5) = ".form" Тогда
			
				Для Сч = 0 По РазобранныйПуть.ВГраница() - 2 Цикл
					Результат = Результат + "/" + РазобранныйПуть[Сч];
				КонецЦикла;
				Результат = Результат + "/" + СтрШаблон("%1.xml", РазобранныйПуть[Граница - 1]);
				
			КонецЕсли;
			
		ИначеЕсли Прав(РазобранныйПуть[РазобранныйПуть.ВГраница()], 4) = ".dcs" Тогда
			Для Сч = 0 По РазобранныйПуть.ВГраница() - 2 Цикл
				Результат = Результат + "/" + РазобранныйПуть[Сч];
			КонецЦикла;
			Результат = Результат + "/" + СтрШаблон("%1.xml", РазобранныйПуть[Граница - 1]);
			
		ИначеЕсли РазобранныйПуть[2] = "Subsystems" Тогда
			Расширение = Прав(РазобранныйПуть[РазобранныйПуть.ВГраница()], 4);
			
			Для Сч = 0 По Граница - 2 Цикл
				Результат = Результат + "/" + РазобранныйПуть[Сч];
			КонецЦикла;
			
			Если Расширение = ".mdo" Тогда
				Результат = Результат + "/" + РазобранныйПуть[Граница - 1] + ".xml";
				//Результат = Результат + "/" + СтрЗаменить(РазобранныйПуть[РазобранныйПуть.ВГраница()], ".mdo", ".xml");
			ИначеЕсли Расширение = ".cmi" Тогда
				Результат = Результат + "/Ext/" + СтрЗаменить(РазобранныйПуть[РазобранныйПуть.ВГраница()], ".cmi", ".xml");
			КонецЕсли;
		ИначеЕсли РазобранныйПуть[2] = "Templates" Тогда
			Для Сч = 0 По Граница - 1 Цикл
				Результат = Результат + "/" + РазобранныйПуть[сч];
			КонецЦикла;
			Результат = Результат + ".xml";
		КонецЕсли;
			
	КонецЕсли;

	Возврат Результат;
	
КонецФункции



&НаКлиенте
Функция ВыгрузитьКорень(ПараметрыКонфигурации)
	КореньКВыгрузкеМетаданные = Новый Массив;
	КореньКВыгрузкеМетаданные.Добавить("Configuration");
	
	ПараметрыВыполнения = РаботаСГитомВызовСервера.ПараметрыВыполнения();
	ВременныйКаталог = ПолучитьИмяВременногоФайла() + "\";
	СоздатьКаталог(ВременныйКаталог);
	
	ПараметрыВыполнения.РабочийКаталог = ВременныйКаталог;
	
	КомандаКВыполнению = РаботаСКонфигурациейКлиентСервер.КомандаДляЗапускаВыгрузкиОбъектов(ПараметрыВыполнения, 
		ПараметрыКонфигурации, КореньКВыгрузкеМетаданные);
	ЗапуститьПриложение(КомандаКВыполнению,, Истина);
	
	Результат = Новый Структура("Каталог, Файлы", "", Новый Соответствие);
	Результат.Каталог = ВременныйКаталог + "bd";
	
	Файлы = НайтиФайлы(ВременныйКаталог + "\bd", "*", Истина);
	
	Для Каждого Файл Из Файлы Цикл
		Если Файл.ЭтоФайл() Тогда
			Результат.Файлы[Файл.ПолноеИмя] = Новый ДвоичныеДанные(Файл.ПолноеИмя);
		КонецЕсли;
	КонецЦикла;
	УдалитьФайлы(ВременныйКаталог, "*");
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция МетаданныеКВыгрузке()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	КоммитыИзмененныеФайлы.ИмяМетаданных КАК ИмяМетаданных
	|ИЗ
	|	Справочник.Коммиты.ИзмененныеФайлы КАК КоммитыИзмененныеФайлы
	|ГДЕ
	|	КоммитыИзмененныеФайлы.Ссылка В (&Ссылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	КоммитыИзмененныеФайлы.ИмяМетаданных";
	Запрос.УстановитьПараметр("Ссылка", Коммиты.Выгрузить().ВыгрузитьКолонку("Коммит"));
	МетаданныеКВыгрузке = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ИмяМетаданных");
	Возврат МетаданныеКВыгрузке;
КонецФункции

&НаСервере
Функция ФайлыКЗагрузке()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	КоммитыИзмененныеФайлы.ИмяФайла КАК ИмяФайла
	|ИЗ
	|	Справочник.Коммиты.ИзмененныеФайлы КАК КоммитыИзмененныеФайлы
	|ГДЕ
	|	КоммитыИзмененныеФайлы.Ссылка В(&Ссылка)";
	Запрос.УстановитьПараметр("Ссылка", Коммиты.Выгрузить().ВыгрузитьКолонку("Коммит"));
	
	ТЗФайлыКЗагрузке = Запрос.Выполнить().Выгрузить();
	
	Возврат ТЗФайлыКЗагрузке.ВыгрузитьКолонку("ИмяФайла");
КонецФункции

&НаКлиенте
Процедура ПрочитатьЛог(Файл)
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(Файл, КодировкаТекста.UTF8);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстовыйДокумент.ПолучитьТекст());
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьЛоги(РабочийКаталог)
	ИмяФайлаOut = РабочийКаталог + "\out.txt";
	ИмяФайлаРезультат = РабочийКаталог + "\result.txt";
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ИмяФайлаOut);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Out");
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстовыйДокумент.ПолучитьТекст());
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Result");
	ТекстовыйДокумент.Прочитать(ИмяФайлаРезультат);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстовыйДокумент.ПолучитьТекст());
КонецПроцедуры

&НаСервере
Функция ПараметрыЗапускаКонфигуратора(База)
	ВерсияПлатформы = База.ВерсияПлатформы;
	
	Результат = Новый Структура;
	
	СтрокаЗапуска1С = """" + Константы.КаталогПлатформ.Получить();
	РабочийКаталог = Константы.РабочаяПапка.Получить();
	Результат.Вставить("РабочийКаталог", РабочийКаталог);
	
	Если Прав(СтрокаЗапуска1С, 1) <> "\" Тогда
		СтрокаЗапуска1С = СтрокаЗапуска1С + "\";
	КонецЕсли;
	СтрокаЗапуска1С = СтрокаЗапуска1С + ВерсияПлатформы + "\bin\1cv8.exe" + """";
	СтрокаЗапуска1С = СтрокаЗапуска1С + " designer"; // /WA-  /DisableStartupDialogs";
	
	Результат.Вставить("СтрокаЗапуска1С", СтрокаЗапуска1С);
	
	ТипБД = ?(База.Файловая, "F", "S");
	ПутьКБД = База.ПутьКБазе;
	Логин = База.Пользователь;
	Пароль = База.Пароль;
	
	СтрокаПодключенияКБД = СтрШаблон("/%1 ""%2"" /N ""%3"" /P ""%4""",
		ТипБД,
		ПутьКБД,
		Логин,
		Пароль);
		
	ИмяФайлаИзменений = "changes.txt";
	
	ПутьКФайлуИзменений = РабочийКаталог + "\" + ИмяФайлаИзменений;
	Результат.Вставить("ПутьКФайлуИзменений", ПутьКФайлуИзменений);
	
	ПутьКФайлуИзмененияХранилища = РабочийКаталог + "\repositoryLock.xml";
	Результат.Вставить("ПутьКФайлуИзмененияХранилища", ПутьКФайлуИзмененияХранилища);
	
	ПутьКФайлуЗагрузки = РабочийКаталог + "\changesUpload.txt";
	Результат.Вставить("ПутьКФайлуСпискаЗагрузки", ПутьКФайлуЗагрузки);
	
	ПутьКВыгрузкеБД = РабочийКаталог + "\bd\";
	Результат.Вставить("ПутьКВыгрузкеБД", ПутьКВыгрузкеБД);
		
	Результат.Вставить("СтрокаВыгрузкиДампа", КомандаВыгрузкиДампаВФайлы(РабочийКаталог, ПутьКВыгрузкеБД, ПутьКФайлуИзменений));	
	Результат.Вставить("СтрокаЗагрузкиДампа", КомандаЗагрузкиДампаИзФайлов(РабочийКаталог, ПутьКВыгрузкеБД, ПутьКФайлуЗагрузки));	
	Результат.Вставить("СтрокаПодключенияКБД", СтрокаПодключенияКБД);
	Результат.Вставить("СтрокаРезультата", КомандаВыводаРезультатов(РабочийКаталог));	
	Результат.Вставить("СтрокаПодключенияКХранилищу", КомандаПодключенияКХранилищу(База.ПутьКХранилищу, 
		База.ПользовательХранилища, 
		База.ПарольХранилища));	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	КоммитыИзмененныеФайлы.ИмяМетаданных КАК ИмяМетаданных
	|ИЗ
	|	Справочник.Коммиты.ИзмененныеФайлы КАК КоммитыИзмененныеФайлы
	|ГДЕ
	|	КоммитыИзмененныеФайлы.Ссылка В (&Ссылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	КоммитыИзмененныеФайлы.ИмяМетаданных";
	Запрос.УстановитьПараметр("Ссылка", Коммиты.Выгрузить().ВыгрузитьКолонку("Коммит"));
	МетаданныеКВыгрузке = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ИмяМетаданных");
	
	Результат.Вставить("МетаданныеКВыгрузке", МетаданныеКВыгрузке);
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция МассивИменМетаданныхВФайлДляХранилища(МетаданныеКВыгрузке)
	
	ЗаписьХМЛ = Новый ЗаписьXML;      
	ВремФайл = ПолучитьИмяВременногоФайла();
	
	ЗаписьХМЛ.ОткрытьФайл(ВремФайл);
	ЗаписьХМЛ.ЗаписатьНачалоЭлемента("Objects");
	ЗаписьХМЛ.ЗаписатьАтрибут("xmlns", "http://v8.1c.ru/8.3/config/objects");
	ЗаписьХМЛ.ЗаписатьАтрибут("version", "1.0");
	
	МетаданныеДляЗахвата = Новый Массив();
	
	Менеджеры = Новый Массив;
	Менеджеры.Добавить("ValueManagerModule");
	Менеджеры.Добавить("ManagerModule");
	Менеджеры.Добавить("ObjectModule");
	
	Для Каждого ИмяМетаданных ИЗ МетаданныеКВыгрузке Цикл
		Для Каждого ИмяМенеджера Из Менеджеры Цикл
			Если СтрЗаканчиваетсяНа(ИмяМетаданных, ИмяМенеджера) Тогда
				ВремСтрМассив = СтрРазделить(ИмяМетаданных, ".", Ложь);
				ВремСтрМассив.Удалить(ВремСтрМассив.ВГраница());
				ИмяМетаданных = СтрСоединить(ВремСтрМассив, ".");
			КонецЕсли;
		КонецЦикла;
		
		Если СтрНачинаетсяС(ИмяМетаданных, "CommonModule")
		И СтрЗаканчиваетсяНа(ИмяМетаданных, "Module") Тогда
			ВремСтрМассив = СтрРазделить(ИмяМетаданных, ".", Ложь);
			ВремСтрМассив.Удалить(ВремСтрМассив.ВГраница());
			ИмяМетаданных = СтрСоединить(ВремСтрМассив, ".")
		КонецЕсли;
		
		Если МетаданныеДляЗахвата.Найти(ИмяМетаданных) = Неопределено Тогда
			МетаданныеДляЗахвата.Добавить(ИмяМетаданных);
			Сообщить(ИмяМетаданных);
		КонецЕсли;
	КонецЦикла;
	    
	    
	Для Каждого ИмяМетаданных Из МетаданныеДляЗахвата Цикл
		Если ИмяМетаданных = "Configuration" Тогда
			ЗаписьХМЛ.ЗаписатьНачалоЭлемента("Configuration");
			ЗаписьХМЛ.ЗаписатьАтрибут("includeChildObjects", "false");
			ЗаписьХМЛ.ЗаписатьКонецЭлемента();
			Продолжить;
		КонецЕсли;
		
		ЗаписьХМЛ.ЗаписатьНачалоЭлемента("Object");
		ЗаписьХМЛ.ЗаписатьАтрибут("fullName", ИмяМетаданных);
		ЗаписьХМЛ.ЗаписатьАтрибут("includeChildObjects", "false");
		ЗаписьХМЛ.ЗаписатьКонецЭлемента();
	КонецЦикла;
	
	ЗаписьХМЛ.ЗаписатьКонецЭлемента();
	ЗаписьХМЛ.Закрыть();
	
	ДвоичныеДанные = Новый ДвоичныеДанные(ВремФайл);
	УдалитьФайлы(ВремФайл);
	Возврат ДвоичныеДанные;
	
КонецФункции


&НаСервере
Функция КомандаВыгрузкиДампаВФайлы(РабочийКаталог, КаталогВыгрузки, ИмяФайлаИзменений = Неопределено)
	Массив = Новый Массив;
	Массив.Добавить("/DumpConfigToFiles");
	Массив.Добавить("""" + КаталогВыгрузки + """");
	
	Если ИмяФайлаИзменений <> Неопределено Тогда
		Массив.Добавить("-listfile");
		Массив.Добавить(ИмяФайлаИзменений);
	КонецЕсли;
	
	Возврат СтрСоединить(Массив, " ");
	
КонецФункции   

&НаСервере
Функция КомандаЗагрузкиДампаИзФайлов(РабочийКаталог, КаталогЗагрузки, ИмяФайлаИзменений = Неопределено, ИзмененныеМетаданные = Неопределено)
	Массив = Новый Массив;
	Массив.Добавить("/LoadConfigFromFiles");
	Массив.Добавить("""" + КаталогЗагрузки + """");
	
	Если ИмяФайлаИзменений <> Неопределено Тогда
		Массив.Добавить("-listFile");
		Массив.Добавить(ИмяФайлаИзменений);
	ИначеЕсли ИзмененныеМетаданные <> Неопределено Тогда
		Массив.Добавить("-files");
		Массив.Добавить("""" + СтрСоединить(ИзмененныеМетаданные, ",") + """");
	КонецЕсли;
	
	Возврат СтрСоединить(Массив, " ");
	
КонецФункции




&НаСервере
Функция КомандаВыводаРезультатов(РабочийКаталог)
	Массив = Новый Массив;
	
	Массив.Добавить(СтрШаблон("/out ""%1\out.txt""", РабочийКаталог));
	Массив.Добавить(СтрШаблон("/DumpResult ""%1\result.txt""", РабочийКаталог));
	
	Возврат СтрСоединить(Массив, " ");	
КонецФункции

&НаСервере
Функция КомандаПодключенияКХранилищу(Путь, Пользователь = "", Пароль = "")
	Шаблон = "/ConfigurationRepositoryF ""%1"" /ConfigurationRepositoryN ""%2"" /ConfigurationRepositoryP ""%3""";
	
	Возврат СтрШаблон(Шаблон, Путь, Пользователь, Пароль);
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция КомандаЗахватаОбъектовВХранилище(ПутьКФайлу)
	Шаблон = "/ConfigurationRepositoryLock -Objects ""%1""";
	
	Возврат СтрШаблон(Шаблон, ПутьКФайлу);
КонецФункции

&НаКлиенте
Процедура КоммитыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Для Каждого Коммит Из ВыбранноеЗначение Цикл
		СуществующиеСтроки = Коммиты.НайтиСтроки(Новый Структура("Коммит", Коммит));
		Если СуществующиеСтроки.Количество() = 0 Тогда
			НоваяСтрока = Коммиты.Добавить();
			НоваяСтрока.Коммит = Коммит;
		Иначе
			Элементы.Коммиты.ТекущаяСтрока = СуществующиеСтроки[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

