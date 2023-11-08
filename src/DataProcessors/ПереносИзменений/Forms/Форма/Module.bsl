
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	ЗаполнитьДеревоКонфигурацииИзКэша();
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура БазаИсточникПриИзменении(Элемент)
	ЗаполнитьДеревоКонфигурацииИзКэша();
КонецПроцедуры

&НаКлиенте
Процедура ПроектПриИзменении(Элемент)
	ЗаполнитьДеревоКонфигурацииИзКэша();
КонецПроцедуры


&НаКлиенте
Процедура ДеревоКонфигурацииВыбранПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ДеревоКонфигурации.ТекущиеДанные;
	Если ТекущиеДанные.Выбран = 2 Тогда
		ТекущиеДанные.Выбран = 0;
	КонецЕсли;
	
	УстановитьЗначениеПодчиненныхЭлементов(ТекущиеДанные, ТекущиеДанные.Выбран);
	УстановитьЗначениеЭлементаВыше(ТекущиеДанные.ПолучитьРодителя(), ТекущиеДанные.Выбран);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы


&НаКлиенте
Процедура ВыгрузитьИзБазыИсточника(Команда)

	ПараметрыКонфигурацииИсточник = РаботаСГитомВызовСервера.ПараметрыДляРаботыСКонфигурацией(БазаИсточник, Проект);
	ПараметрыКонфигурацииПриемник = РаботаСГитомВызовСервера.ПараметрыДляРаботыСКонфигурацией(БазаПриемник, Проект);
	
	Если НЕ ИспользоватьПлатформуИсточника Тогда
		ПараметрыКонфигурацииИсточник.ВерсияПлатформы = ПараметрыКонфигурацииПриемник.ВерсияПлатформы; // Выгружаем той же версией
	КонецЕсли;
	
	ПараметрыВыполнения = РаботаСГитомВызовСервера.ПараметрыВыполнения();
	ОчиститьРабочийКаталог(ПараметрыВыполнения);
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаКоммиты Тогда
		МетаданныеКВыгрузке = МетаданныеКВыгрузкеПоКоммитам();
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаДерево Тогда
		МетаданныеКВыгрузке = МетаданныеКВыгрузкеПоДереву();
	КонецЕсли;
	
	Индекс = МетаданныеКВыгрузке.Найти("Configuration");
	
	Если Индекс <> Неопределено Тогда
		КореньКонфигурацииИсточника = ВыгрузитьКорень(ПараметрыКонфигурацииИсточник);
		МетаданныеКВыгрузке.Удалить(Индекс);
		
		КореньКонфигурацииПриемника = ВыгрузитьКорень(ПараметрыКонфигурацииПриемник);
	КонецЕсли;
	
	КомандаКВыполнению = РаботаСКонфигурациейКлиентСервер.КомандаДляЗапускаВыгрузкиОбъектовIBCMD(ПараметрыВыполнения, 
		ПараметрыКонфигурацииИсточник, МетаданныеКВыгрузке, Истина);
	
	ИмяФайлаЛога = ПараметрыВыполнения.РабочийКаталог + "\log.txt"; 
	РаботаСКонфигурациейКлиентСервер.ДобавитьВыводВФайл(КомандаКВыполнению, ПараметрыВыполнения, ИмяФайлаЛога);
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КомандаКВыполнению);
	ЗапуститьПриложение(КомандаКВыполнению,, Истина);
	
	Каталог = ПараметрыВыполнения.РабочийКаталог + "\bd\";
	Если КореньКонфигурацииИсточника <> Неопределено Тогда
		Для Каждого ФайлСоответствие Из КореньКонфигурацииИсточника.Файлы Цикл
			ИтоговыйФайлПуть = СтрЗаменить(ФайлСоответствие.Ключ, КореньКонфигурацииИсточника.Каталог, Каталог);
			ФайлСоответствие.Значение.Записать(ИтоговыйФайлПуть);
		КонецЦикла;
		ЗаписатьИнформациюОПоддержке(КореньКонфигурацииПриемника, Каталог);
	КонецЕсли;
	
	ПрочитатьЛог(ИмяФайлаЛога);

	
КонецПроцедуры 


&НаКлиенте
Процедура Подбор(Команда)                         
	ПараметрыОткрытия = Новый Структура("ЗакрыватьПриВыборе", Ложь);
	ПараметрыОткрытия.Вставить("МножественныйВыбор", Истина);
	
	Отбор = Новый Структура("Владелец", Проект);
	ПараметрыОткрытия.Вставить("Отбор",  Отбор);
	
	ОткрытьФорму("Справочник.Коммиты.ФормаВыбора", ПараметрыОткрытия, Элементы.Коммиты);
КонецПроцедуры

&НаКлиенте
Процедура ЗахватитьВБазеПриемнике(Команда)
	ПараметрыКонфигурации = РаботаСГитомВызовСервера.ПараметрыДляРаботыСКонфигурацией(БазаПриемник, Проект);
	ПараметрыВыполнения = РаботаСГитомВызовСервера.ПараметрыВыполнения();
	
	КоммитыДляЗахвата = Новый Массив;
	Для Каждого КоммитСтрока Из Коммиты Цикл
		КоммитыДляЗахвата.Добавить(КоммитСтрока.Коммит);
	КонецЦикла;
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаКоммиты Тогда
		МетаданныеКВыгрузке = МетаданныеКВыгрузкеПоКоммитам();
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаДерево Тогда
		МетаданныеКВыгрузке = МетаданныеКВыгрузкеПоДереву();
	КонецЕсли;
	
	ТекстФайлаДляЗахвата = РаботаСКонфигурациейКлиентСервер.МассивМетаданныхВХМЛДляЗахвата(МетаданныеКВыгрузке);
	
	ПутьКФайлу = РаботаСКонфигурациейКлиентСервер.ПутьКФайлуХМЛДляХранилища(ПараметрыВыполнения);
	
	ТекстовыйФайл = Новый ТекстовыйДокумент();
	ТекстовыйФайл.УстановитьТекст(ТекстФайлаДляЗахвата);
	ТекстовыйФайл.Записать(ПутьКФайлу);
	
	КомандаКВыполнению = РаботаСКонфигурациейКлиентСервер.КомандаДляЗахватаОбъектовВХранилищеРежимПакетный(ПараметрыВыполнения, 
		ПараметрыКонфигурации, ПутьКФайлу);
	
	ИмяФайлаЛога = ПараметрыВыполнения.РабочийКаталог + "\log.txt"; 
	РаботаСКонфигурациейКлиентСервер.ДобавитьВыводВФайл(КомандаКВыполнению, ПараметрыВыполнения, ИмяФайлаЛога);
	ЗапуститьПриложение(КомандаКВыполнению);
	
	ПрочитатьЛог(ИмяФайлаЛога);
	
КонецПроцедуры


&НаКлиенте
Процедура ЗапуститьКонфигураторПриемник(Команда)
	ПараметрыКонфигурации = РаботаСГитомВызовСервера.ПараметрыДляРаботыСКонфигурацией(БазаПриемник, Проект);
	ПараметрыВыполнения = РаботаСГитомВызовСервера.ПараметрыВыполнения();
	
	КомандаЗапуска = РаботаСКонфигурациейКлиентСервер.КомандаЗапускаКонфигуратора1С(ПараметрыВыполнения, 
		ПараметрыКонфигурации);
	ЗапуститьПриложение(КомандаЗапуска,, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьКонфигДампИнфо(Команда)
	ПараметрыКонфигурации = РаботаСГитомВызовСервера.ПараметрыДляРаботыСКонфигурацией(БазаИсточник, Проект);
	ПараметрыВыполнения = РаботаСГитомВызовСервера.ПараметрыВыполнения();
	
	СохранитьКонфигДампИнфо(ПараметрыВыполнения,  ПараметрыКонфигурации);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОбъекты(Команда)
	ПараметрыВыполнения = РаботаСГитомВызовСервера.ПараметрыВыполнения();
	
	КаталогБД = ПараметрыВыполнения.РабочийКаталог + "\bd\";
	Файл = Новый Файл(КаталогБД);
	Если НЕ Файл.Существует()  Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Нет выгрузки");
		Возврат;
	КонецЕсли;
	
	ФайлыКЗагрузкеОтносительные = ФайлыКЗагрузке();
	Отказ = ПроверитьСуществованиеФайлов(ФайлыКЗагрузкеОтносительные, ПараметрыВыполнения);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ИтоговыйСписокФайлов = ПреобразоватьСлешВОбратныйУМассиваПутей(ФайлыКЗагрузкеОтносительные);

	//Для Сч = 0 По ФайлыКЗагрузкеОтносительные.ВГраница() Цикл
	//	ОтносительныйПутьКФайлуEDT = ФайлыКЗагрузкеОтносительные[Сч];
	//	
	//	ПутьКФайлу = ПутьEDTВПутьКонфигуратора(ОтносительныйПутьКФайлуEDT);
	//	ФайлыКЗагрузкеСтроки.Добавить(ПутьКФайлу);
	//КонецЦикла;
	
	//ИтоговыйСписок = Новый Массив;
	//ИтоговыйСписокОтносительный = Новый Массив;
	//Для Сч = 0 По ФайлыКЗагрузкеСтроки.ВГраница() Цикл
	//	
	//	ОтносительныйПутьКФайлу = ФайлыКЗагрузкеСтроки[Сч];
	//	Файл = Новый Файл(КаталогБД + СтрЗаменить(ОтносительныйПутьКФайлу, "/", "\"));
	//	Если Не Файл.Существует() Тогда
	//		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Файл.ПолноеИмя + " Не существует!");
	//		Продолжить;
	//	КонецЕсли;
	//	
	//	Если СокрЛП(ОтносительныйПутьКФайлу) = "" Тогда
	//		Продолжить;
	//	КонецЕсли;
	//	
	//	ПутьИтоговый = КаталогБД + СтрЗаменить(ОтносительныйПутьКФайлу, "/", "\");
	//	Если ИтоговыйСписок.Найти(ПутьИтоговый) = Неопределено Тогда
	//		ИтоговыйСписок.Добавить(ПутьИтоговый);
	//	КонецЕсли;
	//	
	//	Если Лев(ОтносительныйПутьКФайлу, 1) = "/" Тогда
	//		ОтносительныйПутьКФайлу = Сред(ОтносительныйПутьКФайлу, 2);
	//	КонецЕсли;
	//	ПутьИтоговый = СтрЗаменить(ОтносительныйПутьКФайлу, "/", "\");
	//	Если ИтоговыйСписокОтносительный.Найти(ПутьИтоговый) = Неопределено Тогда
	//		ИтоговыйСписокОтносительный.Добавить(ПутьИтоговый);
	//	КонецЕсли;
	//	
	//КонецЦикла;
		
	ПараметрыКонфигурацииПриемник = РаботаСГитомВызовСервера.ПараметрыДляРаботыСКонфигурацией(БазаПриемник, Проект);
	Если ИспользоватьПлатформуИсточника Тогда
		ПараметрыКонфигурацииИсточник = РаботаСГитомВызовСервера.ПараметрыДляРаботыСКонфигурацией(БазаИсточник, Проект);
		
		ПараметрыКонфигурацииПриемник.ВерсияПлатформы = ПараметрыКонфигурацииИсточник.ВерсияПлатформы;
	КонецЕсли;
	
	КомандаЗапуска = РаботаСКонфигурациейКлиентСервер.КомандаДляЗапускаЗагрузкиОбъектовBICMD(ПараметрыВыполнения,
		ПараметрыКонфигурацииПриемник, ИтоговыйСписокФайлов);
		
	ИмяФайлаЛога = ПараметрыВыполнения.РабочийКаталог + "\log.txt"; 
	РаботаСКонфигурациейКлиентСервер.ДобавитьВыводВФайл(КомандаЗапуска, ПараметрыВыполнения, ИмяФайлаЛога);
	
	ЗапуститьПриложение(КомандаЗапуска,, Истина);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КомандаЗапуска);
	ПрочитатьЛог(ИмяФайлаЛога);
	
КонецПроцедуры

&НаКлиенте
Функция ПреобразоватьСлешВОбратныйУМассиваПутей(МассивПутей)
	Результат = Новый Массив;
	
	Для Каждого Путь Из МассивПутей Цикл
		Результат.Добавить(СтрЗаменить(Путь, "/", "\"));
	КонецЦикла;
	
	Возврат Результат;
КонецФункции


&НаКлиенте
Процедура ОбновитьСтруктуруИнформационнойБазы(Команда)
	ПараметрыКонфигурации = РаботаСГитомВызовСервера.ПараметрыДляРаботыСКонфигурацией(БазаИсточник, Проект);
	ПараметрыВыполнения = РаботаСГитомВызовСервера.ПараметрыВыполнения();
	
	СохранитьКонфигДампИнфо(ПараметрыВыполнения,  ПараметрыКонфигурации);
	
	Файл = Новый Файл(ПараметрыВыполнения.РабочийКаталог + "\bd\ConfigDumpInfo.xml");
	Если НЕ Файл.Существует() Тогда
		ВызватьИсключение "Не найден ConfigDumpInfo";
	КонецЕсли;
	
	ДвоичныеДанные = Новый ДвоичныеДанные(Файл.ПолноеИмя);
	ЗаполнитьИЗакэшироватьДеревоКонфигурацииПоФайлуНаСервере(ДвоичныеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	УстановитьЗначениеПодчиненныхЭлементов(ДеревоКонфигурации, Истина);
КонецПроцедуры


&НаКлиенте
Процедура СнятьВсе(Команда)
	УстановитьЗначениеПодчиненныхЭлементов(ДеревоКонфигурации, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВМетаданныхПоТекущимКоммитам(Команда)
	ВыбратьМетаданныеПоТекущимКоммитамНаСервере();
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаДерево;
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПроверитьСуществованиеФайлов(СписокОтносительныхПутей, ПараметрыВыполнения)
	Отказ = Ложь;
	
	КаталогБД = ПараметрыВыполнения.РабочийКаталог + "\bd\";
	Файл = Новый Файл(КаталогБД);
	Если НЕ Файл.Существует()  Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не найдено каталога выгрузки!");
		Отказ = Истина;
		
		Возврат Отказ;
	КонецЕсли;
	
	Для Сч = 0 По СписокОтносительныхПутей.ВГраница() Цикл
		
		ОтносительныйПутьКФайлу = СписокОтносительныхПутей[Сч];
		Файл = Новый Файл(КаталогБД + СтрЗаменить(ОтносительныйПутьКФайлу, "/", "\"));
		Если Не Файл.Существует() Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Файл.ПолноеИмя + " Не существует!");
			Отказ = Истина;
			Продолжить;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Отказ;

КонецФункции

&НаКлиенте
Процедура ЗапускКлиентаОкончание(Результат, ДополнительныеПараметры) Экспорт
	УстановитьСостояниеБлокировкиФормы(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСостояниеБлокировкиФормы(Заблокировано)
	ТолькоПросмотр = Заблокировано;
	
	Элементы.ГруппаРеквизитыФормы.ТолькоПросмотр = Заблокировано;
	Элементы.Меню.ТолькоПросмотр = Заблокировано;
	Элементы.СтраницаДерево.ТолькоПросмотр = Заблокировано;
	Элементы.СтраницаКоммиты.ТолькоПросмотр = Заблокировано;
КонецПроцедуры

&НаСервере
Процедура ВыбратьМетаданныеПоТекущимКоммитамНаСервере()
	Дерево = РеквизитФормыВЗначение("ДеревоКонфигурации");
	ВыгружатьКореньКонфигурации = Ложь;
	
	ВыбранныеСтроки = Дерево.Строки.НайтиСтроки(Новый Структура("Выбран", Истина), Истина);
	Для Каждого Строка Из ВыбранныеСтроки Цикл
		Строка.Выбран = 1;
	КонецЦикла;
	
	МассивКоммитов = Коммиты.Выгрузить().ВыгрузитьКолонку("Коммит");
	ВыгружатьКореньКонфигурации = Ложь;
	
	МассивМетаданныхПоКоммитам = МетаданныеКВыгрузкеПоКоммитам();
	Для Каждого СтрокаМетаданное Из МассивМетаданныхПоКоммитам Цикл
		Отбор = Новый Структура("ПолноеИмя", СтрокаМетаданное);
		Если СтрокаМетаданное = "Configuration" Тогда
			ВыгружатьКореньКонфигурации = Истина;
			Продолжить;
		КонецЕсли;
		
		НайденныеСтроки = Дерево.Строки.НайтиСтроки(Отбор, Истина);
		Если НайденныеСтроки.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон("Не найден ""%1""", СтрокаМетаданное));
		КонецЕсли;
		
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			Если НайденнаяСтрока.Выбран <> 1 Тогда
				НайденнаяСтрока.Выбран = 1;
				
				УстановитьЗначениеПодчиненныхЭлементов(НайденнаяСтрока, 1);
				УстановитьЗначениеЭлементаВыше(НайденнаяСтрока.Родитель, 1);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоКонфигурации");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗначениеЭлементаВыше(СтрокаРодитель, Значение)
	
	Если СтрокаРодитель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЕстьВыбранный = Ложь;
	ЕстьНеВыбранный = Ложь;
	
	ПодчиненныеСтроки = ПодчиненныеСтрокиДерева(СтрокаРодитель);
	Родитель = РодительСтрокиДерева(СтрокаРодитель);
	
	Для Каждого СтрокаПодчиненная Из ПодчиненныеСтроки Цикл
		Если СтрокаПодчиненная.Выбран = 1 Тогда
			ЕстьВыбранный = Истина;
		ИначеЕсли СтрокаПодчиненная.Выбран = 0 Тогда
			ЕстьНеВыбранный = Истина;
		Иначе
			ЕстьВыбранный = Истина;
			ЕстьНеВыбранный = Истина;
			
			Прервать
		КонецЕсли;
	КонецЦикла;
	
	Если ЕстьВыбранный И ЕстьНеВыбранный Тогда
		СтрокаРодитель.Выбран = 2;
	ИначеЕсли ЕстьВыбранный Тогда
		СтрокаРодитель.Выбран = 1;
	Иначе
		СтрокаРодитель.Выбран = 0;
	КонецЕсли;
	
	УстановитьЗначениеЭлементаВыше(Родитель, Значение);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗначениеПодчиненныхЭлементов(ТекущаяСтрока, Значение)
	
	ПодчиненныеСтроки = ПодчиненныеСтрокиДерева(ТекущаяСтрока);
	
	Для Каждого ПодчиненнаяСтрока Из ПодчиненныеСтроки Цикл
		УстановитьЗначениеПодчиненныхЭлементов(ПодчиненнаяСтрока, Значение);
		ПодчиненнаяСтрока.Выбран = Значение;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПодчиненныеСтрокиДерева(ТекущаяСтрока)
	#Если Сервер Тогда
		Если ТипЗнч(ТекущаяСтрока) = Тип("СтрокаДереваЗначений") Тогда
			ПодчиненныеСтроки = ТекущаяСтрока.Строки;
		Иначе
			ПодчиненныеСтроки = ТекущаяСтрока.ПолучитьЭлементы();
		КонецЕсли;
	#Иначе
		ПодчиненныеСтроки = ТекущаяСтрока.ПолучитьЭлементы();
	#КонецЕсли
	
	Возврат ПодчиненныеСтроки;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция РодительСтрокиДерева(ТекущаяСтрока)
	#Если Сервер Тогда
		Если ТипЗнч(ТекущаяСтрока) = Тип("СтрокаДереваЗначений") Тогда
			Родитель = ТекущаяСтрока.Родитель;
		Иначе
			Родитель = ТекущаяСтрока.ПолучитьРодителя();
		КонецЕсли;
	#Иначе
		Родитель = ТекущаяСтрока.ПолучитьРодителя();
	#КонецЕсли
	
	Возврат Родитель;
КонецФункции


&НаСервере
Процедура ЗаполнитьДеревоКонфигурацииИзКэша()
	НаборЗаписей = РегистрыСведений.ЗакэшированноеДеревоКонфигурации.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Проект.Установить(Проект);
	НаборЗаписей.Отбор.Конфигурация.Установить(БазаИсточник);
	
	НаборЗаписей.Прочитать();
	
	ЗаписатьПустойНабор = Ложь;
	Если НаборЗаписей.Количество() > 0 Тогда
		ДеревоОбъект = НаборЗаписей[0].ХранилищеДерево.Получить();
		Попытка
			ЗначениеВРеквизитФормы(ДеревоОбъект, "ДеревоКонфигурации");
		Исключение
			ИнформацияООшибке = ИнформацияОбОшибке();
			Сообщение = СтрШаблон("Не удалось загрузить закэшированное дерево конфигурации: %1", 
				ПодробноеПредставлениеОшибки(ИнформацияООшибке));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщение);
			
			ЗаписатьПустойНабор = Истина;
		КонецПопытки;
	Иначе
		ДеревоКонфигурации.ПолучитьЭлементы().Очистить();
	КонецЕсли;
	
	
	Если ЗаписатьПустойНабор Тогда
		НаборЗаписей.Очистить();
		НаборЗаписей.Записать();
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИЗакэшироватьДеревоКонфигурацииПоФайлуНаСервере(Знач ДвоичныеДанные)
	Поток = ДвоичныеДанные.ОткрытьПотокДляЧтения();
	
	ДеревоОбъект = РазборКонфигДампИнфо.РазобратьФайл(Поток);
	
	Поток.Закрыть();
	ЗначениеВРеквизитФормы(ДеревоОбъект, "ДеревоКонфигурации");
	
	НаборЗаписей = РегистрыСведений.ЗакэшированноеДеревоКонфигурации.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Проект.Установить(Проект);
	НаборЗаписей.Отбор.Конфигурация.Установить(БазаИсточник);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Проект = Проект;
	НоваяЗапись.Конфигурация = БазаИсточник;
	НоваяЗапись.ХранилищеДерево = Новый ХранилищеЗначения(ДеревоОбъект);
	
	НаборЗаписей.Записать();
КонецПроцедуры


&НаКлиенте
Процедура ОчиститьРабочийКаталог(ПараметрыВыполнения)
	УдалитьФайлы(ПараметрыВыполнения.РабочийКаталог + "\", "*");
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКонфигДампИнфо(ПараметрыВыполнения, ПараметрыКонфигурации) 
	УдалитьФайлы(ПараметрыВыполнения.РабочийКаталог + "\", "*");
	
	Если ПараметрыКонфигурации.ЭтоРасширение Тогда
		// Требуется полная выгрузка, иначе глючат и дискретная выгрузка пакетная, и выгрузка ibcmd
		КомандаКВыполнению = РаботаСКонфигурациейКлиентСервер.КомандаДляЗапускаПолнойВыгрузкиIBCMD(ПараметрыВыполнения,
			ПараметрыКонфигурации);
	Иначе
		КомандаКВыполнению = РаботаСКонфигурациейКлиентСервер.КомандаДляВыгрузкиКонфигДампИнфоРежимПакетный(ПараметрыВыполнения, 
			ПараметрыКонфигурации);
	КонецЕсли;
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КомандаКВыполнению);

		
	ИмяФайлаЛога = ПараметрыВыполнения.РабочийКаталог + "\log.txt";
	РаботаСКонфигурациейКлиентСервер.ДобавитьВыводВФайл(КомандаКВыполнению, ПараметрыВыполнения, ИмяФайлаЛога);
	ЗапуститьПриложение(КомандаКВыполнению,, Истина);
	
КонецПроцедуры


&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииРежимаРаботы(Элементы, РежимРаботы)
	
	Если РежимРаботы = "ПоКоммитам" Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаКоммиты;
	ИначеЕсли РежимРаботы = "ПоДереву" Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаДерево;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
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
		ИначеЕсли СтрЗаканчиваетсяНа(РазобранныйПуть[РазобранныйПуть.ВГраница()], ".rights") Тогда
			
			Результат = "Roles/" + РазобранныйПуть[РазобранныйПуть.ВГраница() - 1] + ".xml";
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

&НаКлиентеНаСервереБезКонтекста
Функция ПутьКМетаданнымВПутьXML(ПутьКМетаданным)
	СоответствиеИменаМетаданныхПапки = РаботаСГитомКлиентСервер.ПолучитьСоответствияМетаданныхПапкам();
	
	РазделенныйПуть = СтрРазделить(ПутьКМетаданным, ".");
	Если РазделенныйПуть.Количество() = 1
	И РазделенныйПуть[0] = "Configuration" Тогда
		Возврат ПутьККорнюКонфигурации();
	ИначеЕсли РазделенныйПуть.Количество() = 2 Тогда // Отдельный объект
		Возврат ПутьКОбъектуXML(РазделенныйПуть);
	Иначе
		Возврат ПутьКОбъектуXMLПроизвольный(РазделенныйПуть);
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПутьККорнюКонфигурации()
	Возврат "Configuration.xml";
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПутьКОбъектуXML(РазделенныйПутьПутьКМетаданным)
	Соответствие = РаботаСГитомКлиентСервер.ПолучитьСоответствияМетаданныхПапкам();
	
	ПутьККаталогуМассив = Новый Массив;
	
	ВидМетаданного = РазделенныйПутьПутьКМетаданным[0];
	Каталог = Соответствие[ВидМетаданного];
	Если Не ЗначениеЗаполнено(Каталог) Тогда
		ВызватьИсключение СтрШаблон("Вид метаданного ""%1"" не найден!", Каталог);
	КонецЕсли;
	
	ПутьККаталогуМассив.Добавить(Каталог);
	ИмяОбъекта = РазделенныйПутьПутьКМетаданным[1];
	
	ПутьККаталогуМассив.Добавить(СтрШаблон("%1.xml", ИмяОбъекта));
	
	Возврат СтрСоединить(ПутьККаталогуМассив, "/");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПутьКОбъектуXMLПроизвольный(РазделенныйПутьПутьКМетаданным)
	Граница = РазделенныйПутьПутьКМетаданным.ВГраница();
	
	КонечныйОбъект = РазделенныйПутьПутьКМетаданным[Граница];
	Если СтрЗаканчиваетсяНа(КонечныйОбъект, "Module") Тогда
		Формат = "bsl";
	Иначе
		Формат = "xml";
	КонецЕсли;
	
	Если КонечныйОбъект = "Form" Тогда
		Граница = Граница - 1;
	КонецЕсли;
	
	Соответствие = РаботаСГитомКлиентСервер.ПолучитьСоответствияМетаданныхПапкам();
	
	ИтоговыйПутьМассив = Новый Массив;
	Для Сч = 0 По Граница Цикл
		НачальныйПуть = РазделенныйПутьПутьКМетаданным[Сч];
		Если Сч % 2 = 0 Тогда
			Если СтрЗаканчиваетсяНа(НачальныйПуть, "Module") Тогда
				ИтоговыйПУть = СтрШаблон("Ext/%1", НачальныйПуть);
			Иначе
				ИтоговыйПуть = Соответствие[НачальныйПуть];
				Если Не ЗначениеЗаполнено(ИтоговыйПуть) Тогда
					ВызватьИсключение СтрШаблон("Не найдено соответствие поля ""%1"".", НачальныйПуть);
				КонецЕсли;
			КонецЕсли;
		Иначе
			ИтоговыйПуть = НачальныйПуть;
		КонецЕсли;
		
		Если Сч = Граница Тогда
			ИтоговыйПуть = СтрШаблон("%1.%2", ИтоговыйПуть, Формат);
		КонецЕсли;
		ИтоговыйПутьМассив.Добавить(ИтоговыйПуть);
	КонецЦикла;
	
	Возврат СтрСоединить(ИтоговыйПутьМассив, "/");
КонецФункции


&НаКлиенте
Функция ПутьКПодчиненномуОбъектуXML(РазделенныйПутьПутьКМетаданным)
	ВидМетаданного = РазделенныйПутьПутьКМетаданным[0];
	ТипМетаданного = РазделенныйПутьПутьКМетаданным[2];
КонецФункции

&НаКлиенте
Функция ВыгрузитьКорень(ПараметрыКонфигурации)
	КореньКВыгрузкеМетаданные = Новый Массив;
	КореньКВыгрузкеМетаданные.Добавить("Configuration");
	
	ПараметрыВыполнения = РаботаСГитомВызовСервера.ПараметрыВыполнения();
	ВременныйКаталог = ПолучитьИмяВременногоФайла() + "\";
	СоздатьКаталог(ВременныйКаталог);
	
	ПараметрыВыполнения.РабочийКаталог = ВременныйКаталог;
	
	КомандаКВыполнению = РаботаСКонфигурациейКлиентСервер.КомандаДляЗапускаВыгрузкиОбъектовIBCMD(ПараметрыВыполнения, 
		ПараметрыКонфигурации, КореньКВыгрузкеМетаданные);
	КомандаКВыполнению = СтрШаблон("cmd /C ""%1""", КомандаКВыполнению);
	
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
Функция МетаданныеКВыгрузкеПоКоммитам()
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
Функция МетаданныеКВыгрузкеПоДереву()
	Отбор = Новый Структура("Выбран", 1);
	Дерево = РеквизитФормыВЗначение("ДеревоКонфигурации");
	
	НайденныеСтроки = Дерево.Строки.НайтиСтроки(Отбор, Истина);
	
	МассивМетаданных = Новый Массив;
	Если ВыгружатьКореньКонфигурации Тогда
		МассивМетаданных.Добавить("Configuration");
	КонецЕсли;
	
	Для Каждого СтрокаДерева Из НайденныеСтроки Цикл
		ДобавитьВМассивВыбранныеМетаданныеСПодчиненными(МассивМетаданных, СтрокаДерева);
	КонецЦикла;
	МассивМетаданных = ОбщегоНазначенияКлиентСервер.СвернутьМассив(МассивМетаданных);
	
	Возврат МассивМетаданных;
	
КонецФункции

&НаСервере
Процедура ДобавитьВМассивВыбранныеМетаданныеСПодчиненными(МассивМетаданных, Строка)
	МассивМетаданных.Добавить(Строка.ПолноеИмя);
	Для Каждого ПодчиненнаяСтрока Из Строка.Строки Цикл
		ДобавитьВМассивВыбранныеМетаданныеСПодчиненными(МассивМетаданных, ПодчиненнаяСтрока);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ФайлыКЗагрузке()
	Результат = Новый Массив;
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаКоммиты Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	КоммитыИзмененныеФайлы.ИмяФайла КАК ИмяФайла
		|ИЗ
		|	Справочник.Коммиты.ИзмененныеФайлы КАК КоммитыИзмененныеФайлы
		|ГДЕ
		|	КоммитыИзмененныеФайлы.Ссылка В(&Ссылка)";
		Запрос.УстановитьПараметр("Ссылка", Коммиты.Выгрузить().ВыгрузитьКолонку("Коммит"));
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			ПутьКФайлу = ПутьEDTВПутьКонфигуратора(Выборка.ИмяФайла);
			Результат.Добавить(ПутьКФайлу);
		КонецЦикла;
		
		//ТЗФайлыКЗагрузке = Запрос.Выполнить().Выгрузить();
		//Результат = ТЗФайлыКЗагрузке.ВыгрузитьКолонку("ИмяФайла");
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаДерево Тогда
		НайденныеСтроки = ОбщегоНазначенияКлиентСервер.НайтиСтрокиВДереве(ДеревоКонфигурации,
			Новый Структура("Выбран", Истина));
			
		Результат = Новый Массив;
		Для Каждого СтрокаДерева Из НайденныеСтроки Цикл
			ИтоговыйПуть = ПутьКМетаданнымВПутьXML(СтрокаДерева.ПолноеИмя);
			ОбщегоНазначенияКлиентСервер.ДобавитьУникальноеЗначениеВМассив(Результат,
				ИтоговыйПуть);
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ПрочитатьЛог(Файл)
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(Файл, КодировкаТекста.UTF8);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстовыйДокумент.ПолучитьТекст());
КонецПроцедуры

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

&НаКлиенте
Процедура ЗаписатьИнформациюОПоддержке(КореньКонфигурации, КонечныйКаталог)
	Для Каждого ФайлСоответствие Из КореньКонфигурации.Файлы Цикл
		ОтносительныйПуть = СтрЗаменить(ФайлСоответствие.Ключ, КореньКонфигурации.Каталог, "");
		
		РазобранныйПуть = СтрРазделить(ОтносительныйПуть, "\", Ложь);
		Если РазобранныйПуть.Количество() < 2 Тогда
			Продолжить;
		КонецЕсли;
		
		Если ВРЕГ(СокрЛП(РазобранныйПуть[0])) <> Врег("Ext") Тогда
			Продолжить;
		КонецЕсли;
		
		Если Врег(РазобранныйПуть[1]) = Врег("ParentConfigurations.bin") Тогда
			ФайлСоответствие.Значение.Записать(КонечныйКаталог + ОтносительныйПуть);
			Продолжить;
		КонецЕсли;
		
		Если РазобранныйПуть.Количество() < 3 Тогда
			Продолжить;
		КонецЕсли;
		
		Если Врег(РазобранныйПуть[1]) = Врег("ParentConfigurations") Тогда
			ФайлСоответствие.Значение.Записать(КонечныйКаталог + ОтносительныйПуть);
		КонецЕсли;
		
	КонецЦикла;     
	
КонецПроцедуры




#КонецОбласти


