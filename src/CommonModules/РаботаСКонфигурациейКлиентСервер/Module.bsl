
#Область ПрограммныйИнтерфейс

// Команда для запуска выгрузки объектов.
// 
// Параметры:
//  ПараметрыВыполнения - см. РаботаСГитомВызовСервера.ПараметрыВыполнения
//  ПараметрыКонфигурации - см. РаботаСГитомВызовСервера.ПараметрыДляРаботыСКонфигурацией
// 
// Возвращаемое значение:
//  Строка - Команда для запуска выгрузки объектов
Функция КомандаДляЗапускаПолнойВыгрузкиIBCMD(ПараметрыВыполнения, ПараметрыКонфигурации) Экспорт
	ЭтоРасширение = ПараметрыКонфигурации.ЭтоРасширение;
	
	ШаблонКоманды = "type ""%LISTFILEPATH%"" | ""%1CBIN%\%1CVERSION%\bin\ibcmd.exe"" infobase config export " + 
		?(ЭтоРасширение, "--extension ""%EXTENSION_NAME%"" ", "") +
		"""%WORKING_DIR%\bd"" " +
		"--db-server=""%SQL_SERVER_NAME%"" --dbms=MSSQLServer --db-name=""%SQL_BD_NAME%"" --db-user=""%SQL_DB_USER%"" " + 
		"--db-pwd=""%SQL_DB_PWD%"" " + 
		"--user=""%1C_USER%"" --password=""%1C_PWD%""";
		
	СтрокаВыполнения = ЗаполнитьОбщиеПараметрыСтроки(ПараметрыВыполнения, ПараметрыКонфигурации, ШаблонКоманды);
	
	Возврат СтрокаВыполнения;	
КонецФункции

// Команда для запуска выгрузки объектов.
// 
// Параметры:
//  ПараметрыВыполнения - см. РаботаСГитомВызовСервера.ПараметрыВыполнения
//  ПараметрыКонфигурации - см. РаботаСГитомВызовСервера.ПараметрыДляРаботыСКонфигурацией
//  МетаданныеКВыгрузке - Массив Из Строка
// 
// Возвращаемое значение:
//  Строка - Команда для запуска выгрузки объектов
Функция КомандаДляЗапускаВыгрузкиОбъектовIBCMD(ПараметрыВыполнения, ПараметрыКонфигурации, МетаданныеКВыгрузке, Рекурсивно = Ложь) Экспорт
	Если МетаданныеКВыгрузке.Количество() = 0 Тогда
		// Полная выгрузка
		Возврат КомандаДляЗапускаПолнойВыгрузкиIBCMD(ПараметрыВыполнения, ПараметрыКонфигурации);
	КонецЕсли;
	
	ЭтоРасширение = ПараметрыКонфигурации.ЭтоРасширение;
	
	ШаблонКоманды = "type ""%LISTFILEPATH%"" | ""%1CBIN%\%1CVERSION%\bin\ibcmd.exe"" infobase config export " + 
		?(ЭтоРасширение, "--extension ""%EXTENSION_NAME%"" ", "") +
		"objects %R% --out=""%WORKING_DIR%\bd"" " +
		"--db-server=""%SQL_SERVER_NAME%"" --dbms=MSSQLServer --db-name=""%SQL_BD_NAME%"" --db-user=""%SQL_DB_USER%"" " + 
		"--db-pwd=""%SQL_DB_PWD%"" " + 
		"--user=""%1C_USER%"" --password=""%1C_PWD%""";
		
	СтрокаВыполнения = ЗаполнитьОбщиеПараметрыСтроки(ПараметрыВыполнения, ПараметрыКонфигурации, ШаблонКоманды);
	СтрокаМетаданных = СтрСоединить(МетаданныеКВыгрузке, Символы.ПС);
	
	ФайлСписка = ПараметрыВыполнения.РабочийКаталог + "\objects.lst";
	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ТекстовыйДокумент.УстановитьТекст(СтрокаМетаданных);
	ТекстовыйДокумент.Записать(ФайлСписка, КодировкаТекста.ANSI);
	
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "%LISTFILEPATH%", ФайлСписка);
	
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "%R%", ?(Рекурсивно, "-r", ""));
	
	Возврат СтрокаВыполнения;	
КонецФункции   

Функция КомандаДляЗапускаЗагрузкиОбъектовBICMD(ПараметрыВыполнения, ПараметрыКонфигурации, ФайлыКЗагрузке) Экспорт
	ЭтоРасширение = ПараметрыКонфигурации.ЭтоРасширение;	
	ШаблонКоманды = """%1CBIN%\%1CVERSION%\bin\ibcmd.exe"" infobase config import " +
		?(ЭтоРасширение, "--extension ""%EXTENSION_NAME%"" ", "") +
		"files --base-dir=""%WORKING_DIR%\bd"" %LIST_FILES% " +
		"--db-server=""%SQL_SERVER_NAME%"" --dbms=MSSQLServer --db-name=""%SQL_BD_NAME%"" --db-user=""%SQL_DB_USER%"" " + 
		"--db-pwd=""%SQL_DB_PWD%"" " + 
		"--user=""%1C_USER%"" --password=""%1C_PWD%""";
	
	СтрокаВыполнения = ЗаполнитьОбщиеПараметрыСтроки(ПараметрыВыполнения, ПараметрыКонфигурации, ШаблонКоманды);
	СтрокаФайлыКЗагрузке = СтрСоединить(ФайлыКЗагрузке, """ """);
	СтрокаФайлыКЗагрузке = СтрШаблон("""%1""", СтрокаФайлыКЗагрузке);
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "%LIST_FILES%", СтрокаФайлыКЗагрузке);
	
	Возврат СтрокаВыполнения;
КонецФункции

Процедура ДобавитьВыводВФайл(СтрокаВыполнения, ПараметрыВыполнения, ИмяФайла) Экспорт
	СтрокаВыполнения = "cmd /C ""chcp 65001 &&" + СтрокаВыполнения + """ 1> " + ИмяФайла  + " 2>&1";
КонецПроцедуры

Функция КомандаДляСозданияКонфигДампИнфоIBCMD(ПараметрыВыполнения, ПараметрыКонфигурации) Экспорт
	ШаблонКоманды = """%1CBIN%\%1CVERSION%\bin\ibcmd.exe"" infobase config export info --out=""%WORKING_DIR%\"" " +
		"--db-server=""%SQL_SERVER_NAME%"" --dbms=MSSQLServer --db-name=""%SQL_BD_NAME%"" --db-user=""%SQL_DB_USER%"" " + 
		"--db-pwd=""%SQL_DB_PWD%"" " + 
		"--user=""%1C_USER%"" --password=""%1C_PWD%""";
		
	СтрокаВыполнения = ЗаполнитьОбщиеПараметрыСтроки(ПараметрыВыполнения, ПараметрыКонфигурации, ШаблонКоманды);
	
	Возврат СтрокаВыполнения;
КонецФункции

Функция КомандаДляЗахватаОбъектовВХранилищеРежимПакетный(ПараметрыВыполнения, ПараметрыКонфигурации, ПутьКХМЛФайлу) Экспорт
	ШаблонКоманды = """%1CBIN%\%1CVERSION%\bin\1cv8.exe"" designer " +
	"%CONNECTION_STRING% %STORAGE_CONNECTION_STRING% " +
	"/ConfigurationRepositoryLock -Objects ""%STORAGE_XML%""";
	
	Если ПараметрыКонфигурации.ЭтоРасширение Тогда
		ШаблонКоманды = ШаблонКоманды + " -Extension " + СтрокаВКавычках(ПараметрыКонфигурации.ИмяРасширения);
	КонецЕсли;
	
	СтрокаСоединенияСИБ = СтрокаСоединенияСИнформационнойБазой(ПараметрыКонфигурации);
	СтрокаСоединенияСХранилищем = СтрокаСоединенияСХранилищем(ПараметрыКонфигурации);
	
	Команда = ЗаполнитьОбщиеПараметрыСтроки(ПараметрыВыполнения, ПараметрыКонфигурации, ШаблонКоманды);
	Команда = СтрЗаменить(Команда, "%CONNECTION_STRING%", СтрокаСоединенияСИБ);
	Команда = СтрЗаменить(Команда, "%STORAGE_CONNECTION_STRING%", СтрокаСоединенияСХранилищем);
	Команда = СтрЗаменить(Команда, "%STORAGE_XML%", ПутьКХМЛФайлу);
	
	Возврат Команда;
	
КонецФункции

Функция МассивМетаданныхВХМЛДляЗахвата(МетаданныеКВыгрузке) Экспорт
	ЗаписьХМЛ = Новый ЗаписьXML;
	      
	ЗаписьХМЛ.УстановитьСтроку("");
	ЗаписьХМЛ.ЗаписатьНачалоЭлемента("Objects");
	ЗаписьХМЛ.ЗаписатьАтрибут("xmlns", "http://v8.1c.ru/8.3/config/objects");
	ЗаписьХМЛ.ЗаписатьАтрибут("version", "1.0");
	
	МетаданныеДляЗахвата = Новый Массив();
	
	Менеджеры = Новый Массив;
	Менеджеры.Добавить("ValueManagerModule");
	Менеджеры.Добавить("ManagerModule");
	Менеджеры.Добавить("ObjectModule");
	Менеджеры.Добавить("RecordSetModule");
	
	Для Каждого ИмяМетаданных ИЗ МетаданныеКВыгрузке Цикл
		Для Каждого ИмяМенеджера Из Менеджеры Цикл
			Если СтрЗаканчиваетсяНа(ИмяМетаданных, ИмяМенеджера) Тогда
				ВремСтрМассив = СтрРазделить(ИмяМетаданных, ".", Ложь);
				ВремСтрМассив.Удалить(ВремСтрМассив.ВГраница());
				ИмяМетаданных = СтрСоединить(ВремСтрМассив, ".");
			КонецЕсли;
		КонецЦикла;
		
		Если (СтрНачинаетсяС(ИмяМетаданных, "CommonModule")
			И СтрЗаканчиваетсяНа(ИмяМетаданных, "Module"))
		ИЛИ (СтрНачинаетсяС(ИмяМетаданных, "WebService")
			И СтрЗаканчиваетсяНа(ИмяМетаданных, "Module")) 
		Тогда 
		
			ВремСтрМассив = СтрРазделить(ИмяМетаданных, ".", Ложь);
			ВремСтрМассив.Удалить(ВремСтрМассив.ВГраница());
			ИмяМетаданных = СтрСоединить(ВремСтрМассив, ".");
		КонецЕсли;
		
		Если МетаданныеДляЗахвата.Найти(ИмяМетаданных) = Неопределено Тогда
			МетаданныеДляЗахвата.Добавить(ИмяМетаданных);
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
	ТекстХМЛ = ЗаписьХМЛ.Закрыть();
	
	
	Возврат ТекстХМЛ;
КонецФункции

// Путь к файлу ХМЛДля хранилища.
// 
// Параметры:
//  ПараметрыВыполнения - см. РаботаСГитомВызовСервера.ПараметрыВыполнения
// 
// Возвращаемое значение:
//  Строка
Функция ПутьКФайлуХМЛДляХранилища(ПараметрыВыполнения) Экспорт
	Возврат ПараметрыВыполнения.РабочийКаталог + "\repositoryLock.xml";
КонецФункции

// Путь к файлу ХМЛДля хранилища.
// 
// Параметры:
//  ПараметрыВыполнения - см. РаботаСГитомВызовСервера.ПараметрыВыполнения
// 
// Возвращаемое значение:
//  Строка
Функция ПутьКФайлуХМЛДляДампа(ПараметрыВыполнения) Экспорт
	Возврат ПараметрыВыполнения.РабочийКаталог + "\ConfigDumpInfo.xml";
КонецФункции

// Команда для запуска выгрузки объектов.
// 
// Параметры:
//  ПараметрыВыполнения - см. РаботаСГитомВызовСервера.ПараметрыВыполнения
//  ПараметрыКонфигурации - см. РаботаСГитомВызовСервера.ПараметрыДляРаботыСКонфигурацией
// 
// Возвращаемое значение:
//  Строка - Команда для запуска выгрузки объектов
Функция КомандаДляВыгрузкиКонфигДампИнфоРежимПакетный(ПараметрыВыполнения, ПараметрыКонфигурации) Экспорт
	ШаблонКоманды = """%1CBIN%\%1CVERSION%\bin\1cv8.exe"" designer " +
	"%CONNECTION_STRING% " +
	"/DumpConfigToFiles ""%WORKING_DIR%\bd"" " + 
	?(ПараметрыКонфигурации.ЭтоРасширение, "-Extension ""%EXTENSION_NAME%"" ", "") + 
	"-configDumpInfoOnly";
	
	СтрокаСоединенияСИБ = СтрокаСоединенияСИнформационнойБазой(ПараметрыКонфигурации);
	Команда = ЗаполнитьОбщиеПараметрыСтроки(ПараметрыВыполнения, ПараметрыКонфигурации, ШаблонКоманды);
	Команда = СтрЗаменить(Команда, "%CONNECTION_STRING%", СтрокаСоединенияСИБ);
	
	Возврат Команда;
	
КонецФункции

// Команда запуска конфигуратора1 С.
// 
// Параметры:
//  ПараметрыВыполнения - см. РаботаСГитомВызовСервера.ПараметрыВыполнения
//  ПараметрыКонфигурации - см. РаботаСГитомВызовСервера.ПараметрыДляРаботыСКонфигурацией
// 
// Возвращаемое значение:
//  Строка - Команда запуска конфигуратора1 С
Функция КомандаЗапускаКонфигуратора1С(ПараметрыВыполнения, ПараметрыКонфигурации) Экспорт
	ШаблонКоманды = """%1CBIN%\%1CVERSION%\bin\1cv8.exe"" designer " +
	"%CONNECTION_STRING% %STORAGE_CONNECTION_STRING%";
	
	Если ПараметрыКонфигурации.ЭтоРасширение Тогда
		ШаблонКоманды = ШаблонКоманды + " -Extension " + СтрокаВКавычках(ПараметрыКонфигурации.ИмяРасширения);
	КонецЕсли;
	
	СтрокаСоединенияСИБ = СтрокаСоединенияСИнформационнойБазой(ПараметрыКонфигурации);
	СтрокаСоединенияСХранилищем = СтрокаСоединенияСХранилищем(ПараметрыКонфигурации);
	
	Команда = ЗаполнитьОбщиеПараметрыСтроки(ПараметрыВыполнения, ПараметрыКонфигурации, ШаблонКоманды);
	Команда = СтрЗаменить(Команда, "%CONNECTION_STRING%", СтрокаСоединенияСИБ);
	Команда = СтрЗаменить(Команда, "%STORAGE_CONNECTION_STRING%", СтрокаСоединенияСХранилищем);
	
	Возврат Команда;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьСоответствие(Соответствие, Множественное, Единственное)
	Соответствие[Множественное] = Единственное;
	Соответствие[Единственное] = Множественное;
КонецПроцедуры       

// Строка соединения с информационной базой.
// 
// Параметры:
//  ПараметрыКонфигурации - см. РаботаСГитомВызовСервера.ПараметрыДляРаботыСКонфигурацией
// 
// Возвращаемое значение:
//  Строка
Функция СтрокаСоединенияСИнформационнойБазой(ПараметрыКонфигурации)
	
	Если ПараметрыКонфигурации.КонфигурацияФайловая Тогда
		ВидСтрокиСоединения = "/F";
	Иначе
		ВидСтрокиСоединения = "/S";
	КонецЕсли;
	
	КомандаЗапускаМассив = Новый Массив;
	КомандаЗапускаМассив.Добавить(ВидСтрокиСоединения);
	КомандаЗапускаМассив.Добавить(СтрокаВКавычках(ПараметрыКонфигурации.КонфигурацияПуть));
	КомандаЗапускаМассив.Добавить("/N");
	КомандаЗапускаМассив.Добавить(СтрокаВКавычках(ПараметрыКонфигурации.КонфигурацияПользователь));
	КомандаЗапускаМассив.Добавить("/P");
	КомандаЗапускаМассив.Добавить(СтрокаВКавычках(ПараметрыКонфигурации.КонфигурацияПароль));
	
	Возврат СтрСоединить(КомандаЗапускаМассив, " ");
	
КонецФункции

// Строка соединения с хранилищем
// 
// Параметры:
//  ПараметрыКонфигурации - см. РаботаСГитомВызовСервера.ПараметрыДляРаботыСКонфигурацией
// 
// Возвращаемое значение:
//  Строка
Функция СтрокаСоединенияСХранилищем(ПараметрыКонфигурации)
	
	
	КомандаЗапускаМассив = Новый Массив;
	КомандаЗапускаМассив.Добавить("/ConfigurationRepositoryF");
	КомандаЗапускаМассив.Добавить(СтрокаВКавычках(ПараметрыКонфигурации.ХранилищеПуть));
	КомандаЗапускаМассив.Добавить("/ConfigurationRepositoryN");
	КомандаЗапускаМассив.Добавить(СтрокаВКавычках(ПараметрыКонфигурации.ХранилищеПользователь));
	КомандаЗапускаМассив.Добавить("/ConfigurationRepositoryP");
	КомандаЗапускаМассив.Добавить(СтрокаВКавычках(ПараметрыКонфигурации.ХранилищеПароль));
	
	Возврат СтрСоединить(КомандаЗапускаМассив, " ");
	
КонецФункции

Функция СтрокаВКавычках(Строка)
	Возврат СтрШаблон("""%1""", Строка);
КонецФункции

// Заполнить общие параметры строки.
// 
// Параметры:
//  ПараметрыВыполнения - см. РаботаСГитомВызовСервера.ПараметрыВыполнения
//  ПараметрыКонфигурации - см. РаботаСГитомВызовСервера.ПараметрыДляРаботыСКонфигурацией
//  Шаблон - Строка - Шаблон
// 
// Возвращаемое значение:
//  Строка
Функция ЗаполнитьОбщиеПараметрыСтроки(ПараметрыВыполнения, ПараметрыКонфигурации, Знач Шаблон)
	Результат = Шаблон;
	
	
	Результат = СтрЗаменить(Результат, "%1CBIN%", ПараметрыВыполнения.КаталогПлатформ);
	Результат = СтрЗаменить(Результат, "%1CVERSION%", ПараметрыКонфигурации.ВерсияПлатформы);
	Результат = СтрЗаменить(Результат, "%WORKING_DIR%", ПараметрыВыполнения.РабочийКаталог);
	Результат = СтрЗаменить(Результат, "%SQL_SERVER_NAME%", ПараметрыКонфигурации.СКЛСервер);
	Результат = СтрЗаменить(Результат, "%SQL_BD_NAME%", ПараметрыКонфигурации.СКЛИмяБазыДанных);
	Результат = СтрЗаменить(Результат, "%SQL_DB_USER%", ПараметрыКонфигурации.СКЛЛогин);
	Результат = СтрЗаменить(Результат, "%SQL_DB_PWD%", ПараметрыКонфигурации.СКЛПароль);
	
	Результат = СтрЗаменить(Результат, "%1C_USER%", ПараметрыКонфигурации.КонфигурацияПользователь);
	Результат = СтрЗаменить(Результат, "%1C_PWD%", ПараметрыКонфигурации.КонфигурацияПароль);
	
	Результат = СтрЗаменить(Результат, "%EXTENSION_NAME%", ПараметрыКонфигурации.ИмяРасширения);
	
	Возврат Результат;
КонецФункции

#КонецОбласти