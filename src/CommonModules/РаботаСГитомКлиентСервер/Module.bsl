#Область ПрограммныйИнтерфейс
	
Функция РазобратьСтрокуНаМетаданные(ИмяФайла, СоответствиеПапкаМетаданные) Экспорт
	Результат = Новый Структура("ТипМетаданных, ИмяМетаданного, ПолныйПутьКМетаданному");
	
	СоответствиеПапкаМетаданные = ПолучитьСоответствияМетаданныхПапкам();
	
	РазделеннаяСтрока = СтрРазделить(ИмяФайла, "/", Ложь);
	
	ТипМетаданныхПапка = РазделеннаяСтрока[0];
	ТипМетаданныхИмя = СоответствиеПапкаМетаданные[ТипМетаданныхПапка];
	
	Результат.ТипМетаданных = ТипМетаданныхИмя;
	Если ТипМетаданныхПапка = "Configuration" Тогда
		Результат.ПолныйПутьКМетаданному = "Configuration";
	ИначеЕсли ТипМетаданныхИмя = "Subsystem" Тогда
		Сч = 1;
		ПолныйПуть = "";
		Шаблон = ".Subsystem.%1";
		Пока Сч <= РазделеннаяСтрока.ВГраница() Цикл
			Если РазделеннаяСтрока[Сч - 1] <> ТипМетаданныхПапка Тогда
				Прервать;
			КонецЕсли;
			
			ПолныйПуть = ПолныйПуть + СтрШаблон(Шаблон, РазделеннаяСтрока[Сч]);
			Сч = Сч + 2;
		КонецЦикла;
		ПолныйПуть = Сред(ПолныйПуть, 2);

		Результат.ПолныйПутьКМетаданному = ПолныйПуть;
	Иначе
		Результат.ТипМетаданных = ТипМетаданныхИмя;
		Результат.ИмяМетаданного = РазделеннаяСтрока[1];
		Результат.ПолныйПутьКМетаданному = Результат.ТипМетаданных + "." + Результат.ИмяМетаданного;
	КонецЕсли;
	
	Если РазделеннаяСтрока.Количество() > 3 Тогда
		ТипМетаданныхПапка = РазделеннаяСтрока[2];
		ТипМетаданныхИмя = СоответствиеПапкаМетаданные[ТипМетаданныхПапка];
		Если ЗначениеЗаполнено(ТипМетаданныхИмя) Тогда
			Если ТипМетаданныхИмя = "Form"
			ИЛИ ТипМетаданныхИмя = "Template" Тогда
				ИмяОбъекта = РазделеннаяСтрока[3];
				Результат.ПолныйПутьКМетаданному = Результат.ПолныйПутьКМетаданному + "." + ТипМетаданныхИмя + "." + ИмяОбъекта;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли РазделеннаяСтрока.Количество() = 3 Тогда
		Если ТипМетаданныхИмя = "CommonForm" Тогда
		Иначе
			ПоследнийЭлемент = РазделеннаяСтрока[2];
			Если Прав(ПоследнийЭлемент, 3) = "bsl" Тогда
				ДлинаБезРасширения = СтрДлина(ПоследнийЭлемент) - СтрДлина(".bsl");
				Результат.ПолныйПутьКМетаданному = Результат.ПолныйПутьКМетаданному + "." + Лев(ПоследнийЭлемент, ДлинаБезРасширения);
			КонецЕсли;    
		КонецЕсли;
	КонецЕсли;
	
	
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьСписокИзменений(Гит, Идентификатор) Экспорт
	ГруппаКоманд = Новый Массив();
	ГруппаКоманд.Добавить("cmd /C chcp 65001");
	
	МассивКомандаГит = Новый Массив();
	МассивКомандаГит.Добавить("git show  --pretty="""" --name-only");
	МассивКомандаГит.Добавить(Идентификатор);
	
	КомандаГит = СтрСоединить(МассивКомандаГит, " ");
	ГруппаКоманд.Добавить(КомандаГит);
	
	КомандаДляЗапуска = СтрСоединить(ГруппаКоманд, " && ");
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("txt");
	
	Команда = КомандаДляЗапуска + " > " + ИмяВременногоФайла;
	ПараметрыГита = РаботаСГитомВызовСервера.ПолучитьОписаниеХранилища(Гит);
	
	Попытка
		ЗапуститьПриложение(Команда, ПараметрыГита.Каталог, Истина);
		
		ТекстовыйДокумент = Новый ТекстовыйДокумент();
		ТекстовыйДокумент.Прочитать(ИмяВременногоФайла, КодировкаТекста.UTF8);
		
		СтрокаЗамены = ПараметрыГита.Проект + "/src/";
		
		МассивСтрок = Новый Массив;
		
		Для Сч = 1 По ТекстовыйДокумент.КоличествоСтрок() Цикл
			СтрокаФайл = ТекстовыйДокумент.ПолучитьСтроку(Сч);
			
			Если Не СтрНачинаетсяС(СтрЗаменить(СтрокаФайл, """", ""), СтрокаЗамены)
			ИЛИ СтрЗаканчиваетсяНа(СтрокаФайл, ".suppress") Тогда
				Продолжить;
			КонецЕсли;
				
			НоваяСтрока = Новый Структура("ИмяФайла");
			НоваяСтрока.ИмяФайла = СтрЗаменить(СтрокаФайл, СтрокаЗамены, "");
			
			МассивСтрок.Добавить(НоваяСтрока);
		КонецЦикла;
	Исключение
		УдалитьФайлы(ИмяВременногоФайла);
		ВызватьИсключение;
	КонецПопытки;
	
	УдалитьФайлы(ИмяВременногоФайла);
	
	Возврат МассивСтрок;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ПолучитьСоответствияМетаданныхПапкам() Экспорт
	Соответствие = Новый Соответствие;
	
	ДобавитьСоответствие(Соответствие, "WSReferences", "WSReference");
	ДобавитьСоответствие(Соответствие, "WebServices", "WebService");
	ДобавитьСоответствие(Соответствие, "Tasks", "Task");
	ДобавитьСоответствие(Соответствие, "SettingsStorages", "SettingsStorage");
	ДобавитьСоответствие(Соответствие, "ScheduledJobs", "ScheduledJob");
	ДобавитьСоответствие(Соответствие, "Reports", "Report");
	ДобавитьСоответствие(Соответствие, "Subsystems", "Subsystem");
	ДобавитьСоответствие(Соответствие, "InformationRegisters", "InformationRegister");
	ДобавитьСоответствие(Соответствие, "FunctionalOptionsParameters", "FunctionalOptionsParameter");
	ДобавитьСоответствие(Соответствие, "DocumentNumerators", "DocumentNumerator");
	ДобавитьСоответствие(Соответствие, "DocumentJournals", "DocumentJournal");
	ДобавитьСоответствие(Соответствие, "EventSubscriptions", "EventSubscription");
	ДобавитьСоответствие(Соответствие, "DefinedTypes", "DefinedType");
	ДобавитьСоответствие(Соответствие, "CommonTemplates", "CommonTemplate");
	ДобавитьСоответствие(Соответствие, "HTTPServices", "HTTPService");
	ДобавитьСоответствие(Соответствие, "Roles", "Role");
	ДобавитьСоответствие(Соответствие, "CommonModules", "CommonModule");
	ДобавитьСоответствие(Соответствие, "FilterCriteria", "FilterCriterion");
	ДобавитьСоответствие(Соответствие, "Enums", "Enum");
	ДобавитьСоответствие(Соответствие, "CommonForms", "CommonForm");
	ДобавитьСоответствие(Соответствие, "CommonCommands", "CommonCommand");
	ДобавитьСоответствие(Соответствие, "CommandGroups", "CommandGroup");
	ДобавитьСоответствие(Соответствие, "FunctionalOptions", "FunctionalOption");
	ДобавитьСоответствие(Соответствие, "ChartsOfCharacteristicTypes", "ChartOfCharacteristicTypes");
	ДобавитьСоответствие(Соответствие, "ChartsOfCalculationTypes", "ChartOfCalculationTypes");
	ДобавитьСоответствие(Соответствие, "ChartsOfAccounts", "ChartOfAccounts");
	ДобавитьСоответствие(Соответствие, "DataProcessors", "DataProcessor");
	ДобавитьСоответствие(Соответствие, "Constants", "Constant");
	ДобавитьСоответствие(Соответствие, "CommonPictures", "CommonPicture");
	ДобавитьСоответствие(Соответствие, "Catalogs", "Catalog");
	ДобавитьСоответствие(Соответствие, "CommonAttributes", "CommonAttribute");
	ДобавитьСоответствие(Соответствие, "Documents", "Document");
	ДобавитьСоответствие(Соответствие, "ExchangePlans", "ExchangePlan");
	ДобавитьСоответствие(Соответствие, "StyleItems", "StyleItem");
	ДобавитьСоответствие(Соответствие, "BusinessProcesses", "BusinessProcess");
	ДобавитьСоответствие(Соответствие, "CalculationRegisters", "CalculationRegister");
	ДобавитьСоответствие(Соответствие, "AccountingRegisters", "AccountingRegister");
	ДобавитьСоответствие(Соответствие, "SessionParameters", "SessionParameter");
	ДобавитьСоответствие(Соответствие, "AccumulationRegisters", "AccumulationRegister");
	ДобавитьСоответствие(Соответствие, "XDTOPackages", "XDTOPackage");
	ДобавитьСоответствие(Соответствие, "Forms", "Form");
	ДобавитьСоответствие(Соответствие, "Templates", "Template");
	ДобавитьСоответствие(Соответствие, "Rights", "Right");
	
	Возврат Соответствие;
	
КонецФункции

#КонецОбласти



#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьСоответствие(Соответствие, Множественное, Единственное)
	Соответствие[Множественное] = Единственное;
	Соответствие[Единственное] = Множественное;
КонецПроцедуры       

#КонецОбласти